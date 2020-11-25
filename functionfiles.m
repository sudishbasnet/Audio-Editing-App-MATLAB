classdef functionfiles
    %This function flis contains the error alert messages fucntions as well
    %as other important functions for the system which are called by the
    %main GUI
    
    properties
    end
    
    methods
        
    end
    
    methods(Static)
        
        %% Setting the plot upon the call
        function PlotSettingUp(axesHandle)
            global editDat;
            axs = axesHandle;
            cla(axs);
            plot(editDat.data_music.sounStrem,'b','Parent',axs);
            title(axs,editDat.data_music.fname);
            xlabel(axs,strcat('T (s)'));
            %giving the labels to x axes ad y as well
            ylabel(axs,'Amplitude');
            limitofy = get(axs, 'YLim'); % knowing the y axis limit
            editDat.data_music.dataaPlot = [limitofy(1):0.1:limitofy(2)];
            plot(zeros(size(editDat.data_music.dataaPlot)), editDat.data_music.dataaPlot, 'r','Parent',axs); % plotting marker for the axis
        end
        
        %% To update the marker in rela time this is the fucntion
        function MarkerPlot(obj,eventdata,player,figHandle,plottingdata)
            % Validate if sound is playing or not then only replot if
            % needed
            if strcmp(player.Running, 'on')
                % Gettig the current handle and updating with new value
                axs = figHandle;
                mk = findobj(figHandle, 'Color', 'r');
                delete(mk);
                % Know the current playing sound sample
                x = player.CurrentSample;
                % Plotting the new marker
                plot(repmat(x, size(plottingdata)), plottingdata, 'r','Parent',axs);
            end
            
        end
        
        %% Function for showing error messages in the system
        function fileerror
            msgbox('No audio file loaded please check the file again','Error');
        end
        
        
        %% Function for showing error messages in the system
        function nosounderror
            msgbox('No audio file loaded please check the file','Error');
        end
        
        %% Function for showing error messages in the system
        function stoperror
            msgbox('The sound played is stooped. You can eithe play or stop','Warning');
        end
        
        %% Function for showing error messages in the system
        function invalidnumerror
            msgbox('Invalid input for the duration which is number error','Warning');
        end
        
        %% Functions for validating sound instance
        function v = validateSounds
            global musdat1;
            global musdat2;
            if((isempty(musdat1) ||  isempty(musdat1.fname)) || (isempty(musdat2) ||  isempty(musdat2.fname)))
                v = 1;
            else
                v = 0;
            end
        end
        
        %% fucntion for validatig sound instance
        function v = validatemusdat2
            global musdat2;
            if(isempty(musdat2) == 1 || isempty(musdat2.fname))
                v = 1;
            else
                v = 0;
            end
        end
        %% function for validating sound instance
        function v = validatemusdat1
            global musdat1;
            if(isempty(musdat1) == 1 || isempty(musdat1.fname))
                v = 1;
            else
                v = 0;
            end
        end
        
        
        
        %% Merging two audio files after the call from main GUI
        function mergeSounds(filepos,handles)
            global editDat;
            global musdat1;
            global musdat2;
            global plotaxis1;
            global plotaxis2;
            
            
            %Getting the sound sample duration to decide which portion to             % add
            startingminfor1 = str2num(get(handles.pos1durstartmin,'String'));
            startingsecfor1 = str2num(get(handles.pos2durstartsec,'String'));
            starttotaltime1 = startingminfor1 * 60 + startingsecfor1;
            
            endminfor1 = str2num(get(handles.pos2durendmin,'String'));
            endsecfor1 = str2num(get(handles.pos1durendsec,'String'));
            endtotaltime1 = endminfor1 * 60 + endsecfor1;
            
            startingminfor2 = str2num(get(handles.pos2durstartmin,'String'));
            startingsecfor2 = str2num(get(handles.pos2durstartsec,'String'));
            starttotaltime2 = startingminfor2 * 60 + startingsecfor2;
            
            endminfor2 = str2num(get(handles.pos2durendmin,'String'));
            endsecfor2 = str2num(get(handles.pos2durendsec,'String'));
            endtotaltime2 = endminfor2 * 60 + endsecfor2;
            
            % transforming the collected sample time to know they are within
            % range
            sample1starting = (musdat1.samRate * starttotaltime1) + 80;
            sample1ending = musdat1.samRate * endtotaltime1 ;
            if(sample1ending > length(musdat1.sounStrem))
                sample1ending = length(musdat1.sounStrem);
            end
            
            sample2beginning = (musdat2.samRate * starttotaltime2) + 80;
            sample2end = musdat2.samRate * endtotaltime2 ;
            if(sample2end > length(musdat2.sounStrem))
                sample2end = length(musdat2.sounStrem);
            end
            
            % Concating the matrcies after getting corresponding samples
            newsample1 = musdat1.sounStrem(sample1starting:sample1ending,:);
            newsample2 = musdat2.sounStrem(sample2beginning:sample2end,:);
            newsamRate = (musdat1.samRate + musdat2.samRate) / 2;
            
            if(filepos == 1)
                generatedsound = vertcat(newsample1,newsample2);
                 %With selection of positon 1 now the new data values for
                 %psoiton 1
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 1, assign the new sound
                musdat1.sounStrem = generatedsound;
                musdat1.samRate = newsamRate;             
                editDat.customdatareplot(plotaxis1,musdat1);                     
                musdat1.fname = 'New sound merged';
                editDat.data_music = musdat1;
                %setting the UI variables for system
                set(handles.durationText1,'String',editDat.data_music.timedurationinstr);
                set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
            else
                generatedsound = vertcat(newsample2,newsample1);
                 %With selection of positon 2 now the new data values for psoiton 2 
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 2, assign the new sound
                musdat2.sounStrem = generatedsound;
                musdat2.samRate = newsamRate;
                editDat.customdatareplot(plotaxis2,musdat2);                  
                musdat2.fname = 'MergedSound.wav';
                editDat.data_music = musdat2;
                
                %setting the UI variables for system
                set(handles.durationText2,'String',editDat.data_music.timedurationinstr);
                set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
                
                
                
            end
            
        end
        
        
        
        
        
        
        
        
        %% Does the triming of the two sounds
        function trimSound(filepos,handles)
            global editDat;
            global musdat1;
            global musdat2;
            global plotaxis1;
            global plotaxis2;
            %Getting the sound sample duration to decide which portion to add
            startingminfor1 = str2num(get(handles.pos1durstartmin,'String'));
            startingsecfor1 = str2num(get(handles.pos1durstartsec,'String'));
            starttotaltime1 = startingminfor1 * 60 + startingsecfor1;
            
            endminfor1 = str2num(get(handles.pos1durendmin,'String'));
            endsecfor1 = str2num(get(handles.pos1durendsec,'String'));
            endtotaltime1 = endminfor1 * 60 + endsecfor1;
            
            startingminfor2 = str2num(get(handles.pos2durstartmin,'String'));
            startingsecfor2 = str2num(get(handles.pos2durstartsec,'String'));
            starttotaltime2 = startingminfor2 * 60 + startingsecfor2;
            
            endminfor2 = str2num(get(handles.pos2durendmin,'String'));
            endsecfor2 = str2num(get(handles.pos2durendsec,'String'));
            endtotaltime2 = endminfor2 * 60 + endsecfor2;
            
            % transforming the collected sample time to know they are within
            sample1starting = (musdat1.samRate * starttotaltime1) + 80;
            sample1ending = musdat1.samRate * endtotaltime1 ;
            if(sample1ending > length(musdat1.sounStrem))
                sample1ending = length(musdat1.sounStrem);
            end
            
            sample2beginning = (musdat2.samRate * starttotaltime2) + 80;
            sample2end = musdat2.samRate * endtotaltime2 ;
            if(sample2end > length(musdat2.sounStrem))
                sample2end = length(musdat2.sounStrem);
            end
            
            % Concating the matrcies after getting corresponding samples
            newsample1 = musdat1.sounStrem(sample1starting:sample1ending,:);
            newsample2 = musdat2.sounStrem(sample2beginning:sample2end,:);
            
            if(filepos == 1)
                newsamRate = musdat1.samRate;
                generatedsound = newsample1;
                 %With selection of positon 2 now the new data values for psoiton 2 
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 2, assign the new sound
                musdat1.sounStrem = generatedsound;
                musdat1.samRate = newsamRate;             
                editDat.customdatareplot(plotaxis1,musdat1);                     
                musdat1.fname = 'TrimmedSound.wav';
                editDat.data_music = musdat1;
                %setting the UI variables for system
                set(handles.durationText1,'String',editDat.data_music.timedurationinstr);
                set(handles.pos1durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
            else
                newsamRate = musdat2.samRate;
                generatedsound = newsample2;
                 %With selection of positon 2 now the new data values for psoiton 2 
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 2, assign the new sound
                musdat2.sounStrem = generatedsound;
                musdat2.samRate = newsamRate;
                editDat.customdatareplot(plotaxis2,musdat2);                  
                musdat2.fname = 'TrimmedSound.wav';
                editDat.data_music = musdat2;
                
                %setting the UI variables for system
                set(handles.durationText2,'String',editDat.data_music.timedurationinstr);
                set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos2durendsec,'String',editDat.data_music.timedurationinsec);
                
                
                
            end
            
        end
        
        
        
        
        
        
        %% Does the removing noise from the sounds
        function noiseRemove(filepos,handles)
            global editDat;
            global musdat1;
            global musdat2;
            global plotaxis1;
            global plotaxis2;
            
            
            % Getting the sound sample duration to decide which portion to
            % add
            startingminfor1 = str2num(get(handles.pos1durstartmin,'String'));
            startingsecfor1 = str2num(get(handles.pos2durstartsec,'String'));
            starttotaltime1 = startingminfor1 * 60 + startingsecfor1;
            
            endminfor1 = str2num(get(handles.pos2durendmin,'String'));
            endsecfor1 = str2num(get(handles.pos1durendsec,'String'));
            endtotaltime1 = endminfor1 * 60 + endsecfor1;
            
            startingminfor2 = str2num(get(handles.pos2durstartmin,'String'));
            startingsecfor2 = str2num(get(handles.pos2durstartsec,'String'));
            starttotaltime2 = startingminfor2 * 60 + startingsecfor2;
            
            endminfor2 = str2num(get(handles.pos2durendmin,'String'));
            endsecfor2 = str2num(get(handles.pos2durendsec,'String'));
            endtotaltime2 = endminfor2 * 60 + endsecfor2;
            
            % Making the sampled sound rate or simply duration matched in
            % case of not matching
            sample1starting = (musdat1.samRate * starttotaltime1) + 80;
            sample1ending = musdat1.samRate * endtotaltime1 ;
            if(sample1ending > length(musdat1.sounStrem))
                sample1ending = length(musdat1.sounStrem);
            end
            
            sample2beginning = (musdat2.samRate * starttotaltime2) + 80;
            sample2end = musdat2.samRate * endtotaltime2 ;
            if(sample2end > length(musdat2.sounStrem))
                sample2end = length(musdat2.sounStrem);
            end
            
            %Concating the matrices with corresponding sound inorderto get
            %the new generated sound
            newsample1 = musdat1.sounStrem(sample1starting:sample1ending,:);
            newsample2 = musdat2.sounStrem(sample2beginning:sample2end,:);
            
            if(filepos == 1)
                newsamRate = musdat1.samRate;
                generatedsound = newsample1;
                 %With selection of positon 1 now the new data values for
                 %positon 1
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 1, assign the new sound
                musdat1.sounStrem = generatedsound;
                musdat1.samRate = newsamRate;             
                editDat.customdatareplot(plotaxis1,musdat1);                     
                musdat1.fname = 'AntiNoise.wav';
                editDat.data_music = musdat1;
                %setting the UI variables for system
                set(handles.durationText1,'String',editDat.data_music.timedurationinstr);
                set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
            else
                newsamRate = musdat2.samRate;
                generatedsound = newsample2;
                 %With selection of positon 2 now the new data values for psoiton 2 
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 2, assign the new sound
                musdat2.sounStrem = generatedsound;
                musdat2.samRate = newsamRate;
                editDat.customdatareplot(plotaxis2,musdat2);                  
                musdat2.fname = 'AntiNoise.wav';
                editDat.data_music = musdat2;
                
                %setting the UI variables for system
                set(handles.durationText1,'String',editDat.data_music.timedurationinstr);
                set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
                
                
                
            end
            
        end
        
        
        
        
        
        
        
        %% reversig the sound whenever the main gui calls
        function reverseSound(filepos,handles)
            global editDat;
            global musdat1;
            global musdat2;
            global plotaxis1;
            global plotaxis2;

            
            %Concating the two different sound in one single form for the
            %new sound generation with audio
            newsample1 = musdat1.sounStrem();
            newsample2 = musdat2.sounStrem();            
            if(filepos == 1)
                newsamRate = musdat1.samRate;
                generatedsound = flipud(newsample1);
                %With selection of positon 1 now the new data values for psoiton 1 
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 1, assign the new sound
                musdat1.sounStrem = generatedsound;
                musdat1.samRate = newsamRate;             
                editDat.customdatareplot(plotaxis1,musdat1);                     
                musdat1.fname = 'ReversedSound.wav';
                editDat.data_music = musdat1;
                
                % Setting variable for UI
                set(handles.durationText1,'String',editDat.data_music.timedurationinstr);
                set(handles.pos1durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
                
            else
                newsamRate = musdat2.samRate;
                generatedsound = flipud(newsample2);
                %With selection of positon 2 now the new data values for psoiton 2 
                %will be assigned for music data like sample rate, axis data, anme as well as 
                %generated sound Since we've selected the filepos 2, assign the new sound
                
                musdat2.sounStrem = generatedsound;
                musdat2.samRate = newsamRate;
                editDat.customdatareplot(plotaxis2,musdat2);                  
                musdat2.fname = 'ReversedSound.wav';
                editDat.data_music = musdat2;
                
                % Setting variables for UI
                set(handles.durationText2,'String',editDat.data_music.timedurationinstr);
                set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
                set(handles.pos2durendsec,'String',editDat.data_music.timedurationinsec);
                
            end
              
            
        end
        
        
        
        
        
        function p2 = pos1startendvalidate(handles)
            % vvalidate input duration for filepos 1
            validate = 1;
            a = str2num(get(handles.pos1durstartmin,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            a = str2num(get(handles.pos2durstartsec,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            a = str2num(get(handles.pos2durendmin,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            a = str2num(get(handles.pos1durendsec,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            if(validate == 0)
                p2 = 0;
            else
                p2 = 1;
            end
        end
        
        function p2 = pos2startendvalidate(handles)
            % vvalidate input duration for filepos 2
            validate = 1;
            
            a = str2num(get(handles.pos2durstartmin,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            
            a = str2num(get(handles.pos2durstartsec,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            a = str2num(get(handles.pos2durendmin,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            a = str2num(get(handles.pos2durendsec,'String'))
            if(isempty(a) == 1)
                validate = 0;
            end
            
            if(validate == 0)
                p2 = 0;
            else
                p2 = 1;
            end
        end
        
    end
end
