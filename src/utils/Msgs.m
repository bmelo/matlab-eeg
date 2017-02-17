classdef Msgs
    %MSGS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static = true)
        function out = confirm( msg, title )
            if ~exist('title', 'var'); title = 'Confirm Dialog'; end;
            answer = questdlg(msg, title, 'Yes', 'No', 'Yes');
            out = strcmp(answer, 'Yes');
        end
    end
    
end

