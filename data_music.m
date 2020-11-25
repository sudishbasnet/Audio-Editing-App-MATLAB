classdef data_music

    properties
        sounStrem;
        samRate;
        soundPlay;
        dataaPlot;
        fname;
        time_dur;
    end
    
    methods
        function obj = data_music(temp_sounStrem, temp_samRate, temp_sounPlay, tempdataaPlot,tempfname)         
            if nargin == 5
                obj.sounStrem = temp_sounStrem;
                obj.samRate = temp_samRate;
                obj.soundPlay = temp_sounPlay;
                obj.dataaPlot = tempdataaPlot;
                obj.fname = tempfname;
            else                
                error('Arguments are invalid');                
            end            
        end      
        
        function td = timedurationinstr(obj)
            mins =  ( length(obj.sounStrem) / obj.samRate ) / 60 ;
            min = fix(mins);
            secs = int16( mod( length(obj.sounStrem) / obj.samRate,60) );
            td = strcat(int2str(min),'min',int2str(secs),'s');
        end
        
        function td = timedurationinsec(obj)
            secs = int16(mod( length(obj.sounStrem) / obj.samRate,60) );
            td = int2str(secs);
        end
        
        function td = timedurationinmin(obj)
            mins =   (length(obj.sounStrem) / obj.samRate ) / 60 ;
            min = fix(mins);
            td = int2str(min);
        end
        
        function td = timedurationintotal(obj)
            totaldur = int16( length(obj.sounStrem) / obj.samRate );
            td = totaldur;
        end
        
        
        
    end
    
end

