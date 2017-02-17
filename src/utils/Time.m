classdef Time
    %TIME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static = true)
        %Extract Date from text
        function outdate = extractDate( text, milliseconds)
            if ~exist('milliseconds','var'), milliseconds = false; end
            outdate = false; %Default value
            %% Extracting information from string
            pattern = '(\d{4}[\.\/-]\d{2}[\.\/-]\d{2}[-_\s]\d{2}[\.:-]\d{2}[\.:-]\d{2})';
            if( milliseconds )
                pattern = [pattern '(.\d{3})'];
            end
            datestr = regexp(text, pattern, 'match');
            %% Converting
            if( ~isempty(datestr) )
                datestr = regexprep(datestr, '\.|\/|-|:|_',' ');
                if( milliseconds )
                    outdate = datenum(datestr ,'yyyy mm dd HH MM SS FFF');
                else
                    outdate = datenum(datestr ,'yyyy mm dd HH MM SS');
                end
            end
        end
        
        %Output with the difference in seconds
        function seconds = diff( timeEnd, timeBegin )
            seconds = (timeEnd - timeBegin) * 86400;
        end
    end
    
end

