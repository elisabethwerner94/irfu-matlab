function getRData(st,dt,varargin)
%getRData prepare data from all SC: do all steps until spinfits and despin
% getRData(start_time,dt,[sc_list],[options ...])
% Input:
% start_time - ISDAT epoch
% dt - length of time interval in sec
% sc_list - list of SC [optional]
% Options: go in pair 'option', value
% 'sp' - storage directory;
%   // default: '.'
% 'dp' - storage directory;
%   // default: '/data/cluster'
% 'db' - ISDAT database;
%   // default: 'disco:10|disco:20'
% 'sc_list' - list of SC;
%   // default: 1:4
% 'vars' - variables to get data for (see help ClusterDB/getData)
%   supplied as a string separated by '|' or as a cell array;
%   // default: {'e','p','a','sax','r','v','whip','b','edi', ...
%   'ncis','vcis','vce','bfgm'}
%   // + {'dies','die'} which are always added if 'noproc' is not specified.
% 'noproc' - do not run ClusterProc/getData for {'dies','die'};
% 'extrav' - extra variables in addition to default;
% 'cdb' - ClusterDB object;
% 
% Example:
% getRData(toepoch([2002 03 04 10 00 00]),30*60,...
% 'sp','/home/yuri/caa-data/20020304')
%
% $Id$
%
% See also ClusterDB/getData, ClusterProc/getData

% Copyright 2004 Yuri Khotyaintsev

error(nargchk(2,15,nargin))

sc_list = 1:4;

if nargin>2, have_options = 1; args = varargin;
else, have_options = 0;
end

sp = '.';
db = 'disco:10|disco:20';
dp = '/data/cluster';
cdb = '';
vars = {'e','p','a','sax','r','v','whip','b','edi','ncis','vcis','vce','bfgm'};
varsProc = {'dies','die'};

if have_options
	if isnumeric(args{1}), 
		sc_list = args{1};
		args = args(2:end);
	end
end

while have_options
	l = 2;
	if length(args)>=1
		switch(args{1})
		case 'sp'
			if ischar(args{2}), sp = args{2};
			else, warning('caa:wrongArgType','sp must be string')
			end
		case 'dp'
			if ischar(args{2}), dp = args{2};
			else, warning('caa:wrongArgType','dp must be string')
			end
		case 'db'
			if ischar(args{2}), db = args{2};
			else, warning('caa:wrongArgType','db must be string')
			end
		case 'sc_list'
			if isnumeric(args{2}), sc_list = args{2};
			else, warning('caa:wrongArgType','sc_list must be numeric')
			end
		case 'vars'
			if ischar(args{2})
				vars = {};
				p = tokenize(args{2},'|');
				for i=1:length(p), vars(length(vars)+1) = p(i); end
			elseif iscell(args{2}), vars = args{2};
			else, warning('caa:wrongArgType','vars must be eather string or cell array')
			end
		case 'extrav'
			if ischar(args{2})
				p = tokenize(args{2},'|');
				for i=1:length(p), vars(length(vars)+1) = p(i); end
			elseif iscell(args{2}), vars = [vars args{2}];
			else, warning('caa:wrongArgType','extrav must be eather string or cell array')
			end
		case 'cdb'
			if (isa(args{2},'ClusterDB')), cdb = args{2};
			else, warning('caa:wrongArgType','cdb must be a ClusterDB object')
			end
		case 'noproc'
			varsProc = '';	l = 1;
		otherwise
        	disp(['Option ''' args{i} '''not recognized'])
    	end
		if length(args) > l, args = args(l+1:end);
		else break
		end
	else
		error('caa:wrongArgType','use getRData(..,''option'',''value'')')
	end
end

if isempty(cdb), cdb = ClusterDB(db,dp,sp); end

if ~isempty(vars)
	for cl_id=sc_list
		for k=1:length(vars)
			getData(cdb,st,dt,cl_id,vars{k});
		end
	end
end

if ~isempty(varsProc)
	cp=ClusterProc(sp);
	for cl_id=sc_list
		for k=1:length(varsProc)
			getData(cp,cl_id,varsProc{k});
		end
	end
end

