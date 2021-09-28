%
% matlab.unittest automatic test code for
% solo.BSACT_utils.parse_testlogbook_DCC_DCV_TF_IC.
%
%
% Author: Erik P G Johansson, IRF, Uppsala, Sweden
% First created 2017-10-12
%
classdef parse_testlogbook_DCC_DCV_TF_IC___UTEST < matlab.unittest.TestCase



    %##############
    %##############
    % TEST METHODS
    %##############
    %##############
    methods(Test)

        
        
        function test_DCC(testCase)
            
            function Record = create_CTR_DCC(testIdNbr, inputVoltageLogbookVolt)
                %
                % Convenience function for assigning components in struct array.
                % CTR = Calibration Table Record
                %
                % NOTE: Does not assign all values, only some.
                % NOTE: Arguments are deliberately in the same order as the
                % quoted testlogbook*.txt printouts.

                Record = struct(...
                    'antennaSignals',          [], ...
                    'stimuliOhm',              [], ...
                    'testIdNbr',               testIdNbr, ...
                    'inputVoltageLogbookVolt', inputVoltageLogbookVolt);
            end
            
            function test(inputsCa, expOutputsCa)
                % Pre-allocate correct size for later assignment via function
                actOutputs = cell(size(expOutputsCa));
                
                [actOutputs{:}] = solo.BSACT_utils.parse_testlogbook_DCC_DCV_TF_IC(inputsCa{:});
                testCase.verifyEqual(actOutputs, expOutputsCa)
            end
            
            import solo.BSACT_utils.parse_testlogbook_DCC_DCV_TF_IC___UTEST.set_field
            %###################################################################
            exp = EJ_library.ds.empty_struct([0,1], ...
                'antennaSignals', ...
                'stimuliOhm', ...
                'testIdNbr', ...
                'inputVoltageLogbookVolt');

            rowList = {};
            %====================================================================================================
            rowList = [rowList, {...
                '18. Calculate straight-line equation for set current vs. measured current', ...
                '19. Check limits on slope, offset and standard deviation for the calculated straight-line equation.', ...
                '20. Set voltage bias level to 30 and -30 and for each setting repeat measurements from 9 to 19. (the voltage setting order is not critical for the test)', ...
                '21. Set temperature to maximum expected temperature (+65 deg C) and minimum expected temperature (-20 deg C), and for each setting repeat measurements from 7 to 20. (the temperature setting order is not critical for the test)', ...
                'The ID numbers to be used are:' ...
                }];
            %====================================================================================================
            rowList = [rowList, {...
                'Antenna 1, LFR_1 Output, Mode 4 (cal mode 0)', ...
                'Ant 1 = Signal, Ant 2 = GND, Ant 3 = GND, Stimuli = 100kohm', ...
                'ID100 = input voltage = -30V', ...
                'ID101 = input voltage = 0V', ...
                'ID102 = input voltage = +30V'}];
            exp(end+1) = create_CTR_DCC(100, -30);
            exp(end+1) = create_CTR_DCC(101,   0);
            exp(end+1) = create_CTR_DCC(102,  30);
            exp = set_field(exp, 3, 'antennaSignals', [1 0 0]);
            exp = set_field(exp, 3, 'stimuliOhm',     1e5);
            %exp = set_field(exp, 3, 'outputChNbr',    1);
            %====================================================================================================
            rowList = [rowList, {...
                'Antenna 2, LFR_2 Output, Mode 4 (cal mode 0)', ...
                'Ant 1 = GND, Ant 2 = Signal, Ant 3 = GND, Stimuli = 100kohm', ...
                'ID103 = input voltage = -30V', ...
                'ID104 = input voltage = 0V', ...
                'ID105 = input voltage = +30V'}];
            exp(end+1) = create_CTR_DCC(103, -30);
            exp(end+1) = create_CTR_DCC(104,   0);
            exp(end+1) = create_CTR_DCC(105,  30);
            exp = set_field(exp, 3, 'antennaSignals', [0 1 0]);
            exp = set_field(exp, 3, 'stimuliOhm',     1e5);
            %exp = set_field(exp, 3, 'outputChNbr',    2);
            %====================================================================================================
            rowList = [rowList, {...
                'Antenna 3, LFR_3 Output, Mode 4 (cal mode 0)', ...
                'Ant 1 = GND, Ant 2 = GND, Ant 3 = Signal, Stimuli = 100kohm', ...
                'ID106 = input voltage = -30V', ...
                'ID107 = input voltage = 0V', ...
                'ID108 = input voltage = +30V'}];
            exp(end+1) = create_CTR_DCC(106, -30);
            exp(end+1) = create_CTR_DCC(107,   0);
            exp(end+1) = create_CTR_DCC(108,  30);
            exp = set_field(exp, 3, 'antennaSignals', [0 0 1]);
            exp = set_field(exp, 3, 'stimuliOhm',     1e5);
            %exp = set_field(exp, 3, 'outputChNbr',    3);
            %====================================================================================================
            rowList = [rowList, {...
                'For FM tests only:', ...
                'If during a test an out of limit is detected the test will be stopped.', ...
                'The test system action is then notified to the test operator and optionally also turns off power and present stimuli.', ...
                'To proceed, proper actions must be taken including analysis, making a decision to terminate or continue the test, and writing a preliminary test report .' ...
                }];


            
            test({rowList, 'DCC'}, {exp});
        end
        
        
        
        function test_DCV_TF(testCase)
            
            function Record = create_CTR_DCV_TF(...
                    testIdNbr, muxMode, outputChNbr, inputChNbr, acGain, ...
                    invertedInput, commonModeInput)
                %
                % Convenience function for assigning components in struct array.
                % CTR = Calibration Table Record
                %
                % NOTE: Does not assign all values, only some.
                % NOTE: Arguments are deliberately in the same order as the
                % quoted testlogbook*.txt printouts.

                assert(ismember(invertedInput,   [0,1]))
                assert(ismember(commonModeInput, [0,1]))
                Record = struct(...
                    'antennaSignals',  [], ...
                    'stimuliOhm',      [], ...
                    'testIdNbr',       testIdNbr, ...
                    'muxMode',         muxMode, ...
                    'outputChNbr',     outputChNbr, ...
                    'inputChNbr',      inputChNbr, ...
                    'acGain',          acGain, ...
                    'invertedInput',   logical(invertedInput), ...
                    'commonModeInput', logical(commonModeInput));
            end

            function test(inputsCa, expOutputsCa)
                % Pre-allocate correct size for later assignment via function
                actOutputs = cell(size(expOutputsCa));
                
                [actOutputs{:}] = solo.BSACT_utils.parse_testlogbook_DCC_DCV_TF_IC(inputsCa{:});
                testCase.verifyEqual(actOutputs, expOutputsCa)
            end
            
            import solo.BSACT_utils.parse_testlogbook_DCC_DCV_TF_IC___UTEST.set_field
            %###################################################################
            
            
            exp = EJ_library.ds.empty_struct([0,1], ...
                'antennaSignals', ...
                'stimuliOhm',     ...
                'testIdNbr',      ...
                'muxMode',        ...
                'outputChNbr',    ...
                'inputChNbr',     ...
                'acGain',         ...
                'invertedInput',  ...
                'commonModeInput');



            rowList = {};
            %====================================================================================================
            rowList = [rowList, {...
                '4-5 AC Transfer Functions', ...
                'All transfer functions will be obtained using zero bias, at a minimum of three temperatures and using two types of stimuli, using a network analyser. ', ...
                'To see bandwidth behaviour, the measurement range will be extended from 10kHz to 1MHz. ', ...
                'Automatic limit checks are made of the whole frequency range, however, in the band of interest, additional limit checks are performed.', ...
                'The measurements shall be performed as follows:', ...
                '44. Standard test setup shall be used for this test/verification.', ...
                '45. Select correct test IDs', ...
                '46. If needed run the test file on an EM model to confirm correct EGSE operation.', ...
                '47. Load the standard Network settings file test1.sta' ...
                }];
            %====================================================================================================
            rowList = [rowList, {...
                'Antenna 2, LFR Output ', ...
                'Ant 1 = GND, Ant 2 = Signal, Ant 3 = GND, Stimuli = 100kohm', ...
                'ID11 = Mode 0 (std operation), LFR_2 = V12_DC*', ...
                'ID12 = Mode 0 (std operation), LFR_3 = V23_DC', ...
                'ID13 = Mode 0 (std operation), LFR_4 = V12_AC*, Gain = 5', ...
                'ID14 = Mode 0 (std operation), LFR_4 = V12_AC*, Gain = 100', ...
                'ID15 = Mode 0 (std operation), LFR_5 = V23_AC, Gain = 5', ...
                'ID16 = Mode 0 (std operation), LFR_5 = V23_AC, Gain = 100', ...
                'ID17 = Mode 1 (probe 1 fails), LFR_1 = V2_DC', ...
                'ID18 = Mode 1 (probe 1 fails), LFR_3 = V23_DC', ...
                'ID19 = Mode 3 (probe 3 fails), LFR_2 = V2_DC', ...
                'ID20 = Mode 3 (probe 3 fails), LFR_3 = V12_DC*', ...
                'ID21 = Mode 4 (cal mode 0), LFR_2 = V2_DC' } ];
            exp(end+1) = create_CTR_DCV_TF(11, 0, 2, [1 2], NaN, 1, 0);
            exp(end+1) = create_CTR_DCV_TF(12, 0, 3, [2 3], NaN, 0, 0);
            exp(end+1) = create_CTR_DCV_TF(13, 0, 4, [1 2], 5,   1, 0);
            exp(end+1) = create_CTR_DCV_TF(14, 0, 4, [1 2], 100, 1, 0);
            exp(end+1) = create_CTR_DCV_TF(15, 0, 5, [2 3], 5,   0, 0);
            exp(end+1) = create_CTR_DCV_TF(16, 0, 5, [2 3], 100, 0, 0);
            exp(end+1) = create_CTR_DCV_TF(17, 1, 1, [2],   NaN, 0, 0);
            exp(end+1) = create_CTR_DCV_TF(18, 1, 3, [2 3], NaN, 0, 0);
            exp(end+1) = create_CTR_DCV_TF(19, 3, 2, [2],   NaN, 0, 0);
            exp(end+1) = create_CTR_DCV_TF(20, 3, 3, [1 2], NaN, 1, 0);
            exp(end+1) = create_CTR_DCV_TF(21, 4, 2, [2],   NaN, 0, 0);
            exp = set_field(exp, 11, 'antennaSignals', [0 1 0]);
            exp = set_field(exp, 11, 'stimuliOhm', 1e5);
            %====================================================================================================
            rowList = [rowList, {...
                'Antenna 1-2 Common Mode, LFR Output', ...
                'Ant 1 = Signal, Ant 2 = Signal, Ant 3 = GND, Stimuli = 100kohm', ...
                'ID32 = Mode 0 (std operation), LFR_2 = V12_DC*', ...
                'ID33 = Mode 0 (std operation), LFR_4 = V12_AC*, Gain = 5', ...
                'ID34 = Mode 0 (std operation), LFR_4 = V12_AC*, Gain = 100', ...
                'ID35 = Mode 3 (probe 3 fails), LFR_3 = V12_DC*' }];
            exp(end+1) = create_CTR_DCV_TF(32, 0, 2, [1 2], NaN, 0, 1);
            exp(end+1) = create_CTR_DCV_TF(33, 0, 4, [1 2], 5,   0, 1);
            exp(end+1) = create_CTR_DCV_TF(34, 0, 4, [1 2], 100, 0, 1);
            exp(end+1) = create_CTR_DCV_TF(35, 3, 3, [1 2], NaN, 0, 1);
            exp = set_field(exp, 4, 'antennaSignals', [1 1 0]);
            exp = set_field(exp, 4, 'stimuliOhm', 1e5);
            %====================================================================================================
            rowList = [rowList, {...
                'Antenna 2-3 Common Mode, LFR Output ', ...
                'Ant 1 = GND, Ant 2 = Signal, Ant 3 = Signal, Stimuli = 1Mohm', ...
                'ID36 = Mode 0 (std operation), LFR_3 = V23_DC', ...
                'ID37 = Mode 0 (std operation), LFR_5 = V23_AC, Gain = 5', ...
                'ID38 = Mode 0 (std operation), LFR_5 = V23_AC, Gain = 100', ...
                'ID39 = Mode 1 (probe 1 fails), LFR_3 = V23_DC' }];
            exp(end+1) = create_CTR_DCV_TF(36, 0, 3, [2 3], NaN, 0, 1);
            exp(end+1) = create_CTR_DCV_TF(37, 0, 5, [2 3], 5,   0, 1);
            exp(end+1) = create_CTR_DCV_TF(38, 0, 5, [2 3], 100, 0, 1);
            exp(end+1) = create_CTR_DCV_TF(39, 1, 3, [2 3], NaN, 0, 1);
            exp = set_field(exp, 4, 'antennaSignals', [0 1 1]);
            exp = set_field(exp, 4, 'stimuliOhm', 1e6);
            %====================================================================================================
            rowList = [rowList, {...
                'TDS Output ', ...
                'Ant 1 = Signal, Ant 2 = Signal, Ant 3 = Signal, Stimuli = 100kohm', ...
                'ID43 = Mode 4 (cal mode 0), TDS_1 = V1_DC', ...
                'ID44 = Mode 4 (cal mode 0), TDS_2 = V2_DC', ...
                'ID45 = Mode 4 (cal mode 0), TDS_3 = V3_DC' }];
            exp(end+1) = create_CTR_DCV_TF(43, 4, 1, [1], NaN, 0, 0);
            exp(end+1) = create_CTR_DCV_TF(44, 4, 2, [2], NaN, 0, 0);
            exp(end+1) = create_CTR_DCV_TF(45, 4, 3, [3], NaN, 0, 0);
            exp = set_field(exp, 3, 'antennaSignals', [1 1 1]);
            exp = set_field(exp, 3, 'stimuliOhm', 1e5);
            %====================================================================================================
            rowList = [rowList, {...
                'For FM tests only:', ...
                'If during a test an out of limit is detected the test will be stopped. ', ...
                'The test system action is then notified to the test operator and optionally also turns off power and present stimuli. ', ...
                'To proceed, proper actions must be taken including analysis, making a decision to terminate or continue the test, and writing a preliminary test report. ', ...
                'At the end the decision needs to be signed by the test operator.', ...
                'A detailed description of how to perform the test setup is provided by running the file SO_BIAS_Test_Setup.txt.)', ...
                'This script will be generated at the first build of the test bench (photos of the test bench are required to generate this script).', ...
                '   ', ...
                '====================================================================================================================================================', ...
                '   ', ...
                'Time: 2016-06-22 _09-19-38    ver = C:\Documents and Settings\Administrator\Desktop\SOB_EGSE_EMQ_9_b.vee   OS = Windows_XP    Program started 2016-06-21 _15-20-31   Comment:    Program version information', ...
                '    ', ...
                'Time: 2016-06-22 _09-19-38    suni = 0   Comment:    DUT ID <BIAS board number>' ...
                }];
            %====================================================================================================



            test({rowList, 'DCV'}, {exp});
        end
        
        
        
        function test_IC(testCase)
            
            function test(inputsCa, expOutputsCa)
                % Pre-allocate correct size for later assignment via function
                actOutputs = cell(size(expOutputsCa));
                
                [actOutputs{:}] = solo.BSACT_utils.parse_testlogbook_DCC_DCV_TF_IC(inputsCa{:});
                testCase.verifyEqual(actOutputs, expOutputsCa)
            end
            %###################################################################
            
            % NOTE: In a sense, kind of silly test since it contains all the data in
            % 20160621_FS0_EG_Test_Flight_Harness_Preamps/4-8_BIAS_DC_INTERNAL_CAL> k Log/testlogbook_2016-06-22\ _10-42-30__VER_FS.txt

            exp = struct(...
                'stimuliOhm',      {1e6, 1e6, 1e6, 1e6, 1e6, 1e6}, ...
                'testIdNbr',       {300,301,302,303,304,305}, ...
                'muxMode',         {4,4,4,0,0,0}, ...
                'outputChNbr',     {1,2,3, 2,2,3}, ...
                'inputChNbr',      {1,2,3, [1,2], [1,3], [2,3]}, ...
                'acGain',          {NaN,NaN,NaN,NaN,NaN,NaN} ...
                );



            %====================================================================================================
            rowList = {...
                'Enough steps in the sweep should be used to obtain good statistic for the straight-line calculation of the bias current vs. bias settings. ', ...
                'The obtained parameters are used to correct the bias setting and the voltage readings. ', ...
                'Combining this test with the BIAS output calibration will calibrate the whole path from antenna input to telemetry data. ', ...
                'It should be noted that only functional limits are applied to this test as it is a calibration.)', ...
                'The IDs to be used for the DC Internal Calibrartion tests are as follows:', ...
                'Stimuli = 1Mohm', ...
                'ID300 = Mode 4 (cal mode 0), LFR_1 = V1_DC', ...
                'ID301 = Mode 4 (cal mode 0), LFR_2 = V2_DC', ...
                'ID302 = Mode 4 (cal mode 0), LFR_3 = V3_DC', ...
                'ID303 = Mode 0 (std operation), LFR_2 = V12_DC*', ...
                'ID304 = Mode 0 (std operation), LFR_2 = V13_DC*', ...
                'ID305 = Mode 0 (std operation), LFR_3 = V23_DC', ...
                '   ', ...
                '====================================================================================================================================================', ...
                '   ', ...
                'Time: 2016-06-22 _10-42-30    ver = C:\Documents and Settings\Administrator\Desktop\SOB_EGSE_EMQ_9_b.vee   OS = Windows_XP    Program started 2016-06-21 '
                };
            %====================================================================================================

            test({rowList, 'IC'}, {exp})

        end
        
        
        
    end    % methods(Test)
        
        
    
    %########################
    %########################
    % PRIVATE STATIC METHODS
    %########################
    %########################
    methods(Static, Access=private)
        
        
        
        function StructArray = set_field(StructArray, nLastIndices, fieldName, fieldValue)
            % Utility function for assigning a specified field in the last N components
            % in a 1D struct array.

            for i = numel(StructArray) + [(-nLastIndices+1) : 0]
                StructArray(i).(fieldName) = fieldValue;
            end

        end
        
        

    end    % methods(Static, Access=private)

    
    
end
