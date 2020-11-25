classdef editData
 
    properties
        volume;
        speedcontrol;
        selIdofOD;
        data_music;
    end
    
    methods
        %function for editing data
        function obj = editData(tempvol,speedcontrolTemp,selIdofODTemp)
            if nargin == 3
                if (isnumeric(tempvol)) && (isnumeric(speedcontrolTemp)) && (isnumeric(selIdofODTemp))
                    obj.volume = tempvol;
                    obj.speedcontrol = speedcontrolTemp;
                    obj.selIdofOD = selIdofODTemp;
                else
                    error('Numeric values are only accepted')
                end
            end
        end
        
        
        %function for data plotting to axis
        function dataReplot(obj,axs)
            global editData;
            cla(axs);
            plot(editData.data_music.sounStrem,'b','Parent',axs); % Audio data plotting for axis
            title(editData.data_music.fname,'Parent',axs);
            xlabel(strcat('T (s)'));
            ylabel('Amp');
            limitofy = get(axs, 'YLim'); % Knowing the y axis data plot for the axis
            editData.data_music.dataaPlot = [limitofy(1):0.1:limitofy(2)];
            editData.data_music.soundPlay.TimerFcn = {@functionfiles.MarkerPlot,editData.data_music.soundPlay, axs, editData.data_music.dataaPlot};
            editData.data_music.soundPlay.TimerPeriod = 0.01; % getting timer period in second for this section
        end
        
        
        %fucntion for cstom data plottin to axis
        function customdatareplot(obj,axs,data_music)
            cla(axs);
            plot(data_music.sounStrem,'b','Parent',axs); % Plotting the audio data
            title('New Sound Merged');
            xlabel(strcat('T (s)'));
            
            ylabel('Amp');
            limitofy = get(axs, 'YLim'); % getting the y axis limit for the plot
            data_music.dataaPlot = [limitofy(1):0.1:limitofy(2)];
            plot(zeros(size(data_music.dataaPlot)), data_music.dataaPlot, 'r','Parent',axs); % plottig the marker
        end
    end
    
end

