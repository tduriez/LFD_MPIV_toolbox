function [parameters,varargout]=parameters_parser(args, allowed_args, allowed_args_type,default,permisivity)
%PARAMETERS_PARSER      Function to parse arbitrary parameters as obtained
%with VARARGIN.
%
% PARAMETERS=PARAMETERS_PARSER(ARGS) creates the PARAMETERS structure with
% fields depending on ARGS. ARGS can be a cell (as obtained with VARARGIN)
% which should contain a parameter-value pair. Parameters are given as
% stings. Also ARGS can be a structure, set as ARGS.parameter=value.
%
% Ex: PARAMETERS=PARAMETERS_PARSER({'option1',2,'option2','house'})
% returns:
%
% parameters = 
%
%   option1: 2
%   option2: 'house'
%
% PARAMETERS=PARAMETERS_PARSER(ARGS,ALLOWED_ARGS) only adds to PARAMETERS
% parameters which case-independant name are included in the cell
% ALLOWED_ARGS.
%
% Ex: PARAMETERS=PARAMETERS_PARSER({'option1',2,'option2','house'},...
%                                  {'OptiOn2','Option3'});
% returns:
%
% Error using parameters_parser (line 60)
% Parameter 'option1' unknown. Allowed parameters are: 'OptiOn2' and 'Option3'.
%
% Ex: PARAMETERS=PARAMETERS_PARSER({'option3',2,'option2','house'},...
%                                  {'OptiOn2','Option3'});
% returns:
%
% parameters = 
%
%   Option3: 2
%   OptiOn2: 'house'
%
% PARAMETERS=PARAMETERS_PARSER(ARGS,ALLOWED_ARGS,ALLOWED_CLASS) returns
% error when the value associated with a parameter is not included in
% ALLOWED_CLASS. ALLOWED_CLASS is a cell containing allowed classes as
% string or cell of string if several classes are allowed. 'numeric' can be
% used to design the use of any of the numeric classes.
%
% Ex: PARAMETERS=PARAMETERS_PARSER({'option3','door','option2','house'},...
%                                  {'OptiOn2','Option3'},...
%                                  {'char',{'double','single'}})
% returns
%
% Error using parameters_parser (line 68)
% Only variables of class 'double' or 'single' are allowed for parameter 'Option3'.
%
% [PARAMETERS,ERRORMSG]=PARAMETERS_PARSER(...) doesn't issues error if an
% error would have been generated, but captures the error and stocks the
% message in ERRORMSG. 
%
% [PARAMETERS,ERRORMSG]=PARAMETERS_PARSER(ARGS,ALLOWED_ARGS,ALLOWED_CLASS,DEFAULT)
% applies values in DEFAULT to non assigned parameters in ARGS.
%
% Ex: PARAMETERS=PARAMETERS_PARSER({'option2','house'},...
%                                  {'OptiOn2','Option3'},...
%                                  {'char',{'double','single'}},{'door',3})
% returns:
%
% parameters = 
%
%   Option3: 3
%   OptiOn2: 'house' 
%
% [PARAMETERS,ERRORMSG]=PARAMETERS_PARSER(ARGS,ALLOWED_ARGS,ALLOWED_CLASS,DEFAULT,PERMISIVITY) 
%     issues errors or warnings depending on PERMISIVITY
%
%     PERMISIVITY        ACTION
%         3              Issues error only if ARGS cannot be parsed.
%                        No Warnings.
%         2              The above + warnings for out of class args (not
%                        included to output)
%         1              The above + errors for out of class args. Warnings
%                        for unknown args. (Default)
%         0              The above + errors if unknown args
%
%
%   Copyright (c) 2017, Thomas Duriez (Distributed under GPLv3)

%% Copyright
%    Copyright (c) 2017, Thomas Duriez
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
%% Dealing with incomplete arguments

if nargin<2
    allowed_args=[];
end

if nargin<3
    allowed_args_type=[];
end

if nargin<4
    default=[];
end

if nargin<5
    permisivity=1;
end

%% Calling the real parser
[parameters,errormsg]=param_parser(args, allowed_args, allowed_args_type,...
    default,permisivity); 

%% Preparing output
if nargout<2 % if error is not collected, any errormsg will generate an error
    if ~isempty(errormsg)
        error(errormsg)
    end
else
    varargout{1}=errormsg;
end




end

function [parameters,errormsg]=param_parser(args, allowed_args, allowed_args_type,default,permisivity)

%% Default values 
errormsg=[]; 
parameters=struct;

%% Dealing with one structure argument
% Transforming structure args.parameter1: value1 in cell {'parameter1',value1,...}
if isa(args,'cell') && numel(args)>0
if isa(args{1},'LFD_MPIV_parameters') && numel(args)==1
    args=args{1};
end
end

if isa(args,'LFD_MPIV_parameters')
    the_fields=properties(args);
    the_fields=the_fields(~strcmp(the_fields','release'));
    new_args=cell(1,numel(the_fields)*2);
    for i=1:numel(the_fields)
        new_args{2*i-1}=the_fields{i};
        new_args{2*i}=args.(the_fields{i});
    end
    args=new_args;
    clear new_args
end

%% Creating default args cell from default input

if ~isempty(default)
    if isa(default,'LFD_MPIV_parameters') % same as above for args. No check for number of args. (lazy: #FIXME)
        the_fields=properties(default);
        the_fields=the_fields(~strcmp(the_fields','release'));
        new_def=cell(1,numel(the_fields)*2);
        for i=1:numel(the_fields)
            new_def{2*i-1}=the_fields{i};
            new_def{2*i}=default.(the_fields{i});
        end
        default=new_def;
        clear new_def
    else                % default given as cell (could check that too #FIXME)
        
        if numel(default)==numel(allowed_args);
            new_def=cell(1,numel(default)*2);
            for i=1:numel(default) % use allowed_args for parameter name
                new_def{2*i-1}=allowed_args{i};
                new_def{2*i}=default{i};
            end
            default=new_def;
            clear new_def
        else
            if permisivity>2
                default=[];
                warning('Enter as many default values as allowed arguments (%d). Defaults ignored',numel(allowed_args))
            else
                errormsg=sprintf('Enter as many default values as allowed arguments (%d).',numel(allowed_args));return
            end
        end
    end
    args=[default,args]; %% Default params will be overwritten if present in args.
end

%% Check if we have as many types as parameters (if used)

if length(allowed_args)~=length(allowed_args_type) && ~isempty(allowed_args_type)
    if permisivity<2
        errormsg='Enter as many types as allowed parameters';return
    end
    if permisivity>=2
        allowed_args_type=[];
        if permisivity==2
            warning('Enter as many types as allowed parameters. Ignoring types');
        end
    end
end

%% The parsing starts here

if mod(length(args),2)~=0 % check that we have pairs
    errormsg='Only Parameters-Value pairs allowed';return 
else
    for i_args=1:length(args)/2
        if isempty(allowed_args) % if nothing specified everything goes
            parameters.(args{i_args*2-1})=args{i_args*2};
        else
            if any(strcmpi(allowed_args,args{i_args*2-1})) % case independant check for allowed_args
                idx = strcmpi(allowed_args,args{i_args*2-1}); % which one
                if ~isempty(allowed_args_type)   % do we care about type ?
                    if ischar(allowed_args_type{idx})
                        if strcmp(allowed_args_type{idx},'numeric')  % just so 'numeric' can be allowed
                            allowed_args_type{idx}={'double','single','uint16','uint8','uint32','uint64',...
                                                                           'logical','int16','int8','int32','int64'};
                        end
                    end
                    if ~any(strcmp(allowed_args_type{idx},class(args{i_args*2}))) % do we have incorrect type ?                 
                        if ischar(allowed_args_type{idx}) % only one type (as one string)
                            if permisivity<2  % issue error and exit
                                errormsg=sprintf('Only variables of class ''%s'' are allowed for parameter ''%s''.',...
                                allowed_args_type{idx}, allowed_args{idx});return
                            elseif permisivity <3 % issue warning and continue
                                warning('Only variables of class ''%s'' are allowed for parameter ''%s''. Ignored',...
                                allowed_args_type{idx}, allowed_args{idx});
                            end
                        else                      % several types (as cell)
                            if permisivity<2  % issue error and exit
                                errormsg=sprintf('Only variables of class ''%s''',allowed_args_type{idx}{1});
                                for i_allowed=2:length(allowed_args_type{idx})-1
                                    errormsg=sprintf('%s, ''%s''',errormsg,allowed_args_type{idx}{i_allowed});
                                end
                                errormsg=sprintf('%s or ''%s'' are allowed for parameter ''%s''.',...
                                    errormsg,allowed_args_type{idx}{end},allowed_args{idx});return
                            elseif  permisivity <3  % issue warning and continue
                                warnmsg=sprintf('Only variables of class ''%s''',allowed_args_type{idx}{1});
                                for i_allowed=2:length(allowed_args_type{idx})-1
                                    warnmsg=sprintf('%s, ''%s''',warnmsg,allowed_args_type{idx}{i_allowed});
                                end
                                warning('%s or ''%s'' are allowed for parameter ''%s''. Ignored',...
                                    warnmsg,allowed_args_type{idx}{end},allowed_args{idx}); 
                            end
                            
                        end
                    else  %% Type is correct !!
                        parameters.(allowed_args{idx})=args{i_args*2}; % name specified in allowed_args is used 
                    end
                else %% We don't care about type anyway !!
                    parameters.(allowed_args{idx})=args{i_args*2};
                end


            else  %% parameter unknown
                if length(allowed_args)==1
                    errormsg=sprintf('Parameter ''%s'' unknown. Allowed parameter is ''%s''',args{i_args*2-1},allowed_args{1});
                else
                    errormsg=sprintf('Parameter ''%s'' unknown. Allowed parameters are: ''%s''',args{i_args*2-1},allowed_args{1});
                    for i_allowed=2:length(allowed_args)-1
                        errormsg=sprintf('%s, ''%s''',errormsg,allowed_args{i_allowed});
                    end
                    errormsg=sprintf('%s and ''%s''.',errormsg,allowed_args{end});
                end
                if permisivity <1     % issue error
                    return
                elseif permisivity <2 % issue warning
                    warning(errormsg); 
                end
                errormsg=[];
            end
        end
    end
end

end