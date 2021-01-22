%
% Execute a "S/W mode" as (indirectly) specified by the CLI arguments. This
% function should be agnostic of CLI syntax.
%
%
% ARGUMENTS AND RETURN VALUES
% ===========================
% SwModeInfo
% InputFilePathMap  : containers.Map with
%    key   = prodFuncInputKey
%    value = Path to input file
% OutputFilePathMap : containers.Map with
%    key   = prodFuncOutputKey
%    value = Path to output file
%
%
% "BUGS"
% ======
% - Sets GlobalAttributes.Generation_date in local time (no fixed time zone,
%   e.g. UTC+0).
% - Calls derive_output_dataset_GlobalAttributes for ALL input dataset and uses
%   the result for ALL output datasets.
%   ==> If a S/W mode has multiple output datasets based on different sets of
%   input datasets, then the GlobalAttributes might be wrong. Should ideally be
%   run on the exact input datasets (~EIn PDs) used to produce a specific output
%   dataset.
%
%
% Author: Erik P G Johansson, IRF, Uppsala, Sweden
% First created 2016-06-09
%
function execute_sw_mode(...
        SwModeInfo, InputFilePathMap, OutputFilePathMap, ...
        masterCdfDir, rctDir, NsoTable, SETTINGS, L)
    
    % TODO-NI: How verify dataset ID and dataset version against constants?
    %    NOTE: Need to read CDF first.
    %    NOTE: Need S/W mode.
    %
    % PROPOSAL: Verify output zVariables against master CDF zVariable dimensions
    %           (accessible with dataobj, even for zero records).
    %   PROPOSAL: function matchesMaster(DataObj, MasterDataobj)
    %       PRO: Want to use dataobj to avoid reading file (input dataset) twice.
    %
    % NOTE: Things that need to be done when writing PDV-->CDF
    %       Read master CDF file.
    %       Compare PDV variables with master CDF variables (only write a subset).
    %       Check variable types, sizes against master CDF.
    %       Write GlobalAttributes: Calibration_version, Parents, Parent_version,
    %           Generation_date, Logical_file_id,
    %           Software_version, SPECTRAL_RANGE_MIN/-MAX (optional?), TIME_MIN/-MAX
    %       Write VariableAttributes: pad value? (if master CDF does not contain
    %           a correct value), SCALE_MIN/-MAX
    %
    % PROPOSAL: Print variable statistics also for zVariables which are created with fill values.
    %   NOTE: These do not use NaN, but fill values.

    
    
    % ASSERTION: Check that all input & output dataset paths (strings) are
    % unique.
    % NOTE: Manually entering CLI argument, or copy-pasting BICAS call, can
    % easily lead to reusing the same path by mistake, and e.g. overwriting an
    % input file.
    datasetFileList = [InputFilePathMap.values(), OutputFilePathMap.values()];
    assert(numel(unique(datasetFileList)) == numel(datasetFileList), ...
        'BICAS:execute_sw_mode:CLISyntax', ...
        ['Input and output dataset paths are not all unique.', ...
        ' This hints of a manual mistake', ...
        ' in the CLI arguments in call to BICAS.'])
    
    
    
    %=================================
    % READ CDFs
    % ---------
    % Iterate over all the INPUT CDFs
    %=================================
    InputDatasetsMap = containers.Map();
    for i = 1:length(SwModeInfo.inputsList)
        prodFuncInputKey = SwModeInfo.inputsList(i).prodFuncInputKey;
        inputFilePath    = InputFilePathMap(prodFuncInputKey);
        
        %=======================
        % Read dataset CDF file
        %=======================
        [Zv, GlobalAttributes]             = bicas.read_dataset_CDF(...
            inputFilePath, SETTINGS, L);
        InputDatasetsMap(prodFuncInputKey) = struct(...
            'Zv', Zv, ...
            'Ga', GlobalAttributes);
        
        
        
        %===========================================
        % ASSERTIONS: Check GlobalAttributes values
        %===========================================
        % NOTE: Can not use
        % bicas.proc_utils.assert_struct_num_fields_have_same_N_rows(Zv) since
        % not all zVariables have same number of records.
        % Ex: Metadata such as ACQUISITION_TIME_UNITS.
        if ~isfield(GlobalAttributes, 'Dataset_ID')
            error('BICAS:execute_sw_mode:Assertion:DatasetFormat', ...
                ['Input dataset does not contain (any accepted variation', ...
                ' of) the global attribute Dataset_ID.\n    File: "%s"'], ...
                inputFilePath)
        end
        cdfDatasetId = GlobalAttributes.Dataset_ID{1};
        
        if ~strcmp(cdfDatasetId, SwModeInfo.inputsList(i).datasetId)
            [settingValue, settingKey] = SETTINGS.get_fv(...
                'INPUT_CDF.GA_DATASET_ID_MISMATCH_POLICY');
            anomalyDescrMsg = sprintf(...
                ['The input CDF dataset''s stated DATASET_ID does', ...
                ' not match value expected from the S/W mode.\n', ...
                '    File: %s\n', ...
                '    Global attribute GlobalAttributes.Dataset_ID{1} : "%s"\n', ...
                '    Expected value:                                 : "%s"\n'], ...
                inputFilePath, cdfDatasetId, SwModeInfo.inputsList(i).datasetId);
            bicas.default_anomaly_handling(L, ...
                settingValue, settingKey, ...
                'E+W+illegal', anomalyDescrMsg, 'BICAS:DatasetFormat')
        end
    end
    
    
    
    %==============
    % PROCESS DATA
    %==============
    [settingNpefValue, settingNpefKey] = SETTINGS.get_fv(...
        'OUTPUT_CDF.NO_PROCESSING_EMPTY_FILE');
    if ~settingNpefValue
        %==========================
        % CALL PRODUCTION FUNCTION
        %==========================
        OutputDatasetsMap = SwModeInfo.prodFunc(InputDatasetsMap, rctDir, NsoTable);
    else
        OutputDatasetsMap = [];
        L.logf('warning', ...
            'Disabled processing due to setting %s.', settingNpefKey)
    end
    
    
    
    %==================================
    % WRITE CDFs
    % ----------
    % Iterate over all the OUTPUT CDFs
    %==================================
    % ASSERTION: The output datasets generated by processing equal the datasets
    % required by the s/w mode.
    EJ_library.assert.castring_sets_equal(...
        OutputDatasetsMap.keys, ...
        {SwModeInfo.outputsList.prodFuncOutputKey});
    % ITERATE
    for iOutputCdf = 1:length(SwModeInfo.outputsList)
        OutputInfo = SwModeInfo.outputsList(iOutputCdf);
        
        prodFuncOutputKey = OutputInfo.prodFuncOutputKey;
        outputFilePath    = OutputFilePathMap(prodFuncOutputKey);
        
        
        
        %========================
        % Write dataset CDF file
        %========================
        masterCdfPath = fullfile(...
            masterCdfDir, ...
            bicas.get_master_CDF_filename(...
                OutputInfo.datasetId, ...
                OutputInfo.skeletonVersion));
        
        if ~settingNpefValue      
            % CASE: Nominal
            OutputDataset = OutputDatasetsMap(OutputInfo.prodFuncOutputKey);
            
            ZvsSubset = OutputDataset.Zv;            
            
            GaSubset = derive_output_dataset_GlobalAttributes(...
                InputDatasetsMap, OutputDataset.Ga, SETTINGS, L);
        else
            % CASE: No processing.
            ZvsSubset = [];
        end
        bicas.write_dataset_CDF( ...
            ZvsSubset, GaSubset, outputFilePath, masterCdfPath, ...
            SETTINGS, L );
    end
    
    
    
end   % execute_sw_mode



% Function for determining SOME global attributes for an output dataset given
% the global attributes of multiple input datasets.
%
%
% SOOP_TYPE, Datetime, OBS_ID
% ===========================
% XB on RCS telecon 2020-09-17: SOOP_TYPE, Datetime, OBS_ID should be taken from
% L1 (not HK, unless implicit that it should).
% --
% Global attributes Datetime, OBS_ID, SOOP_TYPE appear to be present in BICAS
% input L1R datasets, CURRENT datasets, and BIAS HK datasets. Not true for old
% SBM1 datasets (at least).
% Exception: OBS_ID is not in BIAS HK. /2020-09-17
%
%
% ARGUMENTS
% =========
% InputDatasetsMap
%       NOTE: This function does not really need all of InputDatasetsMap as
%       input (contains zVars) but the function uses that input argument since
%       it is easily accessible where this function is called.
% OutputDatasetGa
%       Struct with fields for (subset of) global attributes that should be used
%       for the output dataset instead of from other locations. This should come
%       from the processing. Currently only includes:
%           .Datetime
%
%
% RETURN VALUE
% ============
% OutGaSubset
%       Struct where each field name corresponds to a CDF global atttribute.
%       NOTE: Deviates from the usual variable naming conventions.
%       GlobalAttributesSubset field names have
%               the exact names of CDF global attributes.
%
function OutGaSubset = derive_output_dataset_GlobalAttributes(...
        InputDatasetsMap, OutputDatasetGa, SETTINGS, L)
    
    % PGA = Parents' GlobalAttributes.

    if ~isscalar(OutputDatasetGa.Datetime)
        [settingValue, settingKey] = SETTINGS.get_fv(...
            'OUTPUT_CDF.GLOBAL_ATTRIBUTES.Datetime_NOT_SCALAR_POLICY');
        bicas.default_anomaly_handling(L, settingValue, settingKey, 'E+W+illegal', ...
            ['Global attribute "Datetime" for output dataset', ...
            ' is not a MATLAB scalar (i.e. the global attribute does not consist', ...
            ' of exactly ONE string). This may be due to the corresponding input', ...
            ' dataset value being similarily incorrect.'], ...
            'BICAS:execute_sw_mode:Datetime')
    end

    OutGaSubset = OutputDatasetGa;



    OutGaSubset.Parent_version = {};
    OutGaSubset.Parents        = {};
    OutGaSubset.Provider       = {};
    keysCa = InputDatasetsMap.keys;
    for i = 1:numel(keysCa)
        InputGa = InputDatasetsMap(keysCa{i}).Ga;
    
        % ASSERTION
        % NOTE: ROC DFMD is not completely clear on which version number should
        % be used.
        % NOTE: Stores all values to be safe.
        assert(isscalar(InputGa.Data_version), ...
            'BICAS:execute_sw_mode:DatasetFormat', ...
            ['Global attribute "Data_version" for input dataset', ...
            ' with key=%s is not a MATLAB scalar (i.e. the global attribute is', ...
            ' not exactly ONE string).'], ...
            keysCa{i})
        
        % 2020-12-16, EJ: Has found input datasets to have global
        % attribute "Data_version" values which are either NUMERIC or STRINGS
        % (e.g. "02"). Varies.
        
        % NOTE: Using Data_version to set Parent_version.
        OutGaSubset.Parent_version{end+1} = InputGa.Data_version{1};
        OutGaSubset.Parents       {end+1} = ['CDF>', InputGa.Logical_file_id{1}];
        OutGaSubset.Provider              = union(OutGaSubset.Provider, InputGa.Provider);
    end
    
    
    
    % ~ASSERTION
    if ~isscalar(OutGaSubset.Parents)
        [settingValue, settingKey] = SETTINGS.get_fv(...
            'INPUT_CDF.GA_PROVIDER_MISMATCH_POLICY');
        bicas.default_anomaly_handling(...
            L, settingValue, settingKey, 'E+W+illegal', ...
            ['The value of the input CDF files'' global attribute "Provider"', ...
            ' differ (and they should not, or?).'], ...
            'BICAS:execute_sw_mode:DatasetFormat')
        % NOTE: Maybe wrong choice of error ID "DatasetFormat".
    end
    
    % ASSERTION: Required subset for every dataset.
    EJ_library.assert.struct(OutGaSubset, ...
        {'Parents', 'Parent_version', 'Provider', ...
        'Datetime', 'OBS_ID', 'SOOP_TYPE'}, 'all')
end



% Utility function to shorten & clarify code.
% Not very efficient, but that is unimportant here.
%
% Modifies OutGa such that field "fieldName" is potentially modified.
% Essentially, do 
%   OutGa.(fieldName) := UNION[ OutGa.(fieldName) InGa.(fieldName) ]
% with precautions.
%
% NOTE: Can tolerate InGa.(fieldName) not existing. Then skipping union.
% NOTE: Eliminates duplicated values in end result.
% NOTE: Removes ' ', unless it is the only value. ' ' is (empirically) like a
%       fill value for global attributes.
% NOTE: Assumes that values are cell arrays (of strings).
%
% function OutGa = add_to_set_if_found(InGa, OutGa, fieldName)
%     outValue = OutGa.(fieldName);
%     
%     if isfield(InGa, fieldName)
%         outValue = union(outValue, InGa.(fieldName));
%     end
%     
%     % ~HACK
%     % Remove ' ', unless it is the only value.
%     % NOTE: Empirically, ' ' is like a fill value for global attributes (but it
%     % is probably not a formal fill value(?) since only zvars have fill values).
%     outValue2 = setdiff(outValue, ' ');
%     if ~isempty(outValue2)
%         outValue = outValue2;
%     end
%     
%     OutGa.(fieldName) = outValue;
% end
