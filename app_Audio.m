
%Opening function for varargout which is default by matlab
function varargout = app_Audio(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @app_Audio_OpeningFcn, ...
    'gui_OutputFcn',  @app_Audio_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


%Opening function for app_Audio_OpeningFcn
function app_Audio_OpeningFcn(hObject, ~, handles, varargin)
global musdat1;
global musdat2;
global editDat;
global d1;
global d2;
d1 = 0;
d2 = 0;
global samRate;
samRate = 48000;
musdat1 = data_music(0,0,0,0,'');
musdat2 = data_music(0,0,0,0,'');
editDat = editData(1.0,1.0,0);
editDat.selIdofOD = 0;
% moving gui in center
movegui('center')

handles.output = hObject;
guidata(hObject, handles);




%Opening function for varargout
function varargout = app_Audio_OutputFcn(~, eventdata, handles)
varargout{1} = handles.output;

%Opening function for OpenMenuItem_Callback
function OpenMenuItem_Callback(~, ~, handles)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

%Opening function for PrintMenuItem_Callback
function PrintMenuItem_Callback(hObject, ~, handles)
printdlg(handles.mainFigure)



%Opening function for CloseMenuItem_Callback
function CloseMenuItem_Callback(hObject, ~, handles)
dialogboxx = questdlg(['Close ' get(handles.mainFigure,'Name') '?'],...
    ['Close ' get(handles.mainFigure,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(dialogboxx,'No')
    return;
end

delete(handles.mainFigure)



%Opening function for popupmenu1_CreateFcn
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%Opening function for Exit_Callback
function Exit_Callback(~, ~, ~)
cl = questdlg('Do you want to close?','EXIT',...
            'Yes','No','No');
switch cl
    case 'Yes'
        close();
        clear all;
        return;
    case 'No'
        quit cancel;
end 

%Opening function for New_File_Callback
function New_File_Callback(~, ~, ~)
fname = fopen( 'sudish.wav', 'w' );


%Opening function for Open_Callback
function Open_Callback(~, eventdata, handles)
global editDat;
global musdat1;
global musdat2;
global plotaxis2;
global plotaxis1;
global d1;
global d2;
global samRate;
global sampsound1;
global sampsound2;
[fileSelected, pathname] = ...
    uigetfile({'*.wav';'*.mp3'},'Selector for audio track');
if isequal(fileSelected,0)
    % pass the fucntion to next lavel
elseif(get(handles.pos2Btn,'Value') == 1.0)
    axs = plotaxis2;
    cla(axs);
    [musdat2.sounStrem,musdat2.samRate] = audioread(fileSelected);
    if musdat2.samRate ~= samRate %check sample rate
        [P,Q] = rat(samRate/musdat2.samRate); %approximation rational for global sample 
        d2 = resample(musdat2.sounStrem,P,Q); 
    else
        d2 = musdat2.sounStrem;
    end
    sampsound2 = audioplayer(d2,samRate); 
    musdat2.soundPlay = audioplayer(musdat2.sounStrem,musdat2.samRate);
    editDat.customdatareplot(axs,musdat2);
    try
        plot(zeros(size(musdat2.dataaPlot)), musdat2.dataaPlot, 'r','Parent',axs); % ploting  marker for axs
    catch exception
        %pass
    end
    set(handles.audiofile2,'String',fileSelected);
    musdat2.fname = fileSelected;
    editDat.data_music = musdat2;
    set(handles.durationText2,'String',editDat.data_music.timedurationinstr);
    set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
    set(handles.pos2durendsec,'String',editDat.data_music.timedurationinsec);
    endminfor1 = str2num(editDat.data_music.timedurationinmin);
    endsecfor1 = str2num(editDat.data_music.timedurationinsec);
    endtime = endminfor1 * 60 + endsecfor1;
    set(handles.mixerSlider,'Max',endtime);
else

    axs = plotaxis1;
    cla(axs);
    [musdat1.sounStrem,musdat1.samRate] = audioread(fileSelected);
    if musdat1.samRate ~= samRate 
        [P,Q] = rat(samRate/musdat1.samRate); 
        d1 = resample(musdat1.sounStrem,P,Q); 
    else
        d1 = musdat1.sounStrem;
    end
    sampsound1 = audioplayer(d1,samRate); 
    musdat1.soundPlay = audioplayer(musdat1.sounStrem, musdat1.samRate);   
    editDat.customdatareplot(axs,musdat1);
    try
        plot(zeros(size(musdat1.dataaPlot)), musdat1.dataaPlot, 'r','Parent',axs);
    catch exception
        %pass
    end
    set(handles.audiofile1,'String',fileSelected);
    musdat1.fname = fileSelected;
    editDat.data_music = musdat1;
    set(handles.durationText1,'String',editDat.data_music.timedurationinstr);
    set(handles.pos1durendmin,'String',editDat.data_music.timedurationinmin);
    set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
    endminfor1 = str2num(editDat.data_music.timedurationinmin);
    endsecfor1 = str2num(editDat.data_music.timedurationinsec);
    endtime = endminfor1 * 60 + endsecfor1;
    set(handles.mixerSlider,'Max',endtime);
end




%Opening function for Save_Callback
function Save_Callback(hObject, eventdata, handles)
global editDat;

if(isempty(editDat.data_music) == 1)
    functionfiles.fileerror;
else
    if(~isempty(editDat.data_music.sounStrem))
        audiowrite(editDat.data_music.fname,editDat.data_music.sounStrem,editDat.data_music.samRate);
    else
        functionfiles.nosounderror;
    end
end




%Opening function for play button Callback
function playBtn_Callback(hObject, eventdata, handles)
global editDat;
global plotaxis1;
global plotaxis2;
if(isempty(editDat.data_music) || isempty(editDat.data_music.fname))
    functionfiles.fileerror;
else
    if(handles.pos2Btn.Value == 1)
        axis = plotaxis2;
    else
        axis = plotaxis1;
    end
    functionfiles.PlotSettingUp(axis);
    editDat.data_music.soundPlay = audioplayer(editDat.data_music.sounStrem ,editDat.data_music.samRate,16,editDat.selIdofOD);
    editDat.data_music.soundPlay.TimerFcn = {@functionfiles.MarkerPlot,editDat.data_music.soundPlay, axis, editDat.data_music.dataaPlot};
    editDat.data_music.soundPlay.TimerPeriod = 0.01; % period of the timer in seconds
    play(editDat.data_music.soundPlay);
    set(handles.outputDevList,'Enable','off');
    set(handles.sampleRateValue,'String',editDat.data_music.samRate);
    set(handles.pauseBtn,'String','Pause');
end




%Opening function for pauseButton_Callback
function pauseBtn_Callback(hObject, eventdata, handles)
global editDat;

if(isempty(editDat.data_music) || isempty(editDat.data_music.fname))
    functionfiles.fileerror
else
    if(editDat.data_music.soundPlay.isplaying)
        pause(editDat.data_music.soundPlay)
        set(handles.pauseBtn,'string','Resume');
    elseif(get(editDat.data_music.soundPlay,'CurrentSample') == 1)
        functionfiles.stoperror;
    else
        resume(editDat.data_music.soundPlay)
        set(handles.pauseBtn,'string','Pause');
    end
    display(editDat.data_music.soundPlay);
    set(handles.sampleRateValue,'String',editDat.data_music.samRate);
end




%Opening function for stopButton_Callback
function stopBtn_Callback(hObject, eventdata, handles)
global editDat;
global plotaxis1;
global plotaxis2;
if(isempty(editDat.data_music) || isempty(editDat.data_music.fname))
    functionfiles.fileerror;
else
    stop(editDat.data_music.soundPlay);
    set(handles.pauseBtn,'string','Pause');
    if(handles.pos1Btn.Value == 1)
        axis = plotaxis1;
        cla(axis);
        plot(editDat.data_music.sounStrem,'b','Parent',axis);
    else
        axis = plotaxis2;
        cla(axis);
        plot(editDat.data_music.sounStrem,'b','Parent',axis);
    end
    set(handles.outputDevList,'Enable','on');
end



%Opening function for mainFigure_CloseRequestFcn
function mainFigure_CloseRequestFcn(hObject, eventdata, handles)
cl = questdlg('Do you want to close?','close',...
            'Yes','No','No');
switch cl
    case 'Yes'
        delete(hObject);
        return;
    case 'No'
        quit cancel;
end 



%Opening function for speedcontrol_Callback
function speedcontrol_Callback(hObject, eventdata, handles)
global editDat;
global plotaxis1;
global plotaxis2;
set(handles.playbackSpeedNoText,'String',get(hObject,'Value') );
currentspeedcontrol = get(hObject,'Value');

if(handles.pos1Btn.Value == 1)
    axs = plotaxis1;
else
    axs = plotaxis2;
end

if(isempty(editDat.data_music) || isempty(editDat.data_music.fname))
    
else
    if(editDat.data_music.soundPlay.isplaying)
        currentSample = get(editDat.data_music.soundPlay,'CurrentSample') / editDat.data_music.samRate;
        editDat.data_music.samRate = ((editDat.data_music.samRate / editDat.speedcontrol )* currentspeedcontrol);
        editDat.data_music.soundPlay = audioplayer(editDat.data_music.sounStrem, editDat.data_music.samRate,16,editDat.selIdofOD);
        resumeSample = currentSample * editDat.data_music.soundPlay.sampleRate;
        resumeSample = fix(resumeSample);
        plot(editDat.data_music.sounStrem,'b','Parent',axs);
        play(editDat.data_music.soundPlay,resumeSample);
    else
        editDat.data_music.samRate = (editDat.data_music.samRate / editDat.speedcontrol) * currentspeedcontrol;
    end
    
    set(handles.sampleRateValue,'String',editDat.data_music.samRate);
end

editDat.speedcontrol = currentspeedcontrol;



%Opening function for speedcontrol_CreateFcn 
function speedcontrol_CreateFcn(hObject, eventdata, handles)
global editDat;
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
editDat.speedcontrol = get(hObject,'Value');




%Opening function for outputDevList_Callback
function outputDevList_Callback(hObject, eventdata, handles)
global editDat;
editDat.selIdofOD = hObject.Value - 1;


%Opening function for outputDevList_CreateFcn
function outputDevList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%Opening function for inputDevList_CreateFcn
function inputDevList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

x = audiodevinfo(1) 
if x > 0
    for i = 1:x
        inputDevArr{i} =  audiodevinfo(1,(i-1));
    end
    set(hObject, 'String', inputDevArr); 
end


%Opening function for volumeSlider_Callback
function vlmnSlider_Callback(hObject, ~, handles)
global editDat;
global plotaxis1;
global plotaxis2;
cuVolume = hObject.Value;
if(handles.pos1Btn.Value == 1)
    axs = plotaxis1;
else
    axs = plotaxis2;
end

if(isempty(editDat.data_music) || isempty(editDat.data_music.fname))
    %pass
else
    if(editDat.data_music.soundPlay.isplaying)
        %collecting the exisitng sample before reinitilizing
        resumeSample = get(editDat.data_music.soundPlay,'CurrentSample') / editDat.data_music.samRate * editDat.data_music.soundPlay.sampleRate;
        editDat.data_music.sounStrem = ((editDat.data_music.sounStrem / editDat.volume ) * cuVolume);
        editDat.data_music.soundPlay = audioplayer(editDat.data_music.sounStrem, editDat.data_music.samRate,16,editDat.selIdofOD);
        plot(editDat.data_music.sounStrem,'b','Parent',axs);
        play(editDat.data_music.soundPlay,resumeSample);
    else
        editDat.data_music.sounStrem = (editDat.data_music.sounStrem / editDat.volume) * cuVolume;
    end
    
    set(handles.sampleRateValue,'String',editDat.data_music.samRate);
end

editDat.volume = cuVolume;



%Opening function for volumeSlider_CreateFcn
function vlmnSlider_CreateFcn(hObject, ~, ~)
global editDat;
editDat.volume = hObject.Value;
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%Opening function for pushbutton9_CreateFcn
function pushbtn9_CreateFcn(hObject, ~, ~)
dir = imread('img/soundOut.png');
set(hObject,'CData',dir);


%Opening function for pushbutton10_CreateFcn
function pushbtn10_CreateFcn(hObject, ~, ~)
dir = imread('img/mic.png');
set(hObject,'CData',dir);


%Opening function for saveAsButton_Callback
function saveBtn_Callback(~, ~, ~)
global editDat;
fname = uiputfile('/','Export this Sound file','newsample.wav');
if(fname == 0)
    %pass this to another level
else
    if(~isempty(editDat.data_music))
        try
            audiowrite(fname,editDat.data_music.sounStrem,editDat.data_music.samRate);
        catch exception
            msgbox('Unable to save now','Warning');
        end
    else
        
        functionfiles.nosounderror;
    end
end


%Opening function for saveAsButton_CreateFcn
function saveBtn_CreateFcn(hObject, ~, ~)
dir = imread('img/save.png');
set(hObject,'CData',dir);


%Opening function for filepos2Button_Callback
function filepos2Button_Callback(~, ~, handles)
global editDat;
global musdat2;

notEmpty = ~isempty(editDat.data_music);
if(notEmpty > 0)
    if(editDat.data_music.sounStrem > 0)
        if(editDat.data_music.soundPlay.isplaying)
            stop(editDat.data_music.soundPlay)
            set(handles.pauseBtn,'string','Pause');
        end
    end
    endminfor1 = str2num(get(handles.pos2durendmin,'String'));
    endsecfor1 = str2num(get(handles.pos2durendmin,'String'));
    endtime = endminfor1 * 60 + endsecfor1;
    set(handles.mixerSlider,'Max',endtime);
end

editDat.data_music = musdat2;
set(handles.sampleRateValue,'string',editDat.data_music.samRate);



%Opening function for filepos1Button_Callback
function filepos1Button_Callback(~, eventdata, handles)
global editDat;
global musdat1;
notEmpty = ~isempty(editDat.data_music);
if(notEmpty > 0)
    if(editDat.data_music.sounStrem > 0)
        if(editDat.data_music.soundPlay.isplaying)
            stop(editDat.data_music.soundPlay)
            set(handles.pauseBtn,'string','Pause');
        end
    end
    endminfor1 = str2num(get(handles.pos2durendmin,'String'));
    endsecfor1 = str2num(get(handles.pos1durendsec,'String'));
    endtime = endminfor1 * 60 + endsecfor1;
    set(handles.mixerSlider,'Max',endtime);
end

editDat.data_music = musdat1;

set(handles.sampleRateValue,'string',editDat.data_music.samRate);





%Opening function for edit1_CreateFcn
function edit1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%Opening function for edit2_CreateFcn
function edit2_CreateFcn(hObject)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%Opening function for edit3_CreateFcn
function edit3_CreateFcn(hObject)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%Opening function for pos1durstartmin_CreateFcn
function pos1durstartmin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Opening function for pos2durstartsec_Callback
function pos2durstartsec_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on



%Opening function for pos2durstartmin_Callback
function pos2durstartmin_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on



%Opening function for pos2durstartsec_CreateFcn
function pos2durstartsec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Opening function for pos2durendmin_Callback
function pos2durendmin_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on




%Opening function for pos2durendmin_CreateFcn
function pos2durendmin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Opening function for pos1durendsec_Callback
function pos1durendsec_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on



%Opening function for pos1durendsec_CreateFcn
function pos1durendsec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Opening function for time_durPos2samplestartmin_Callback
function time_durPos2samplestartmin_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on




%Opening function for time_durPos2samplestartmin_CreateFcn
function time_durPos2samplestartmin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Opening function for time_durPos2samplestartsec_Callback
function time_durPos2samplestartsec_Callback()
%letting the function blank as it will be called when inputing number for
%the duration and pass on



%Opening function for time_durPos2samplestartsec_CreateFcn
function time_durPos2samplestartsec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







%Opening function for pos2durendsec_Callback
function pos2durendsec_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration


%Opening function for pos2durendsec_CreateFcn
function pos2durendsec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Opening function for playButtonPos1_Callback
function playBtnPos1_Callback(hObject, eventdata, handles)
global musdat1;
global editDat;
global plotaxis1;

if(functionfiles.validatemusdat1 == 1)
    functionfiles.fileerror;
else
    if(functionfiles.pos1startendvalidate(handles) == 1)
        axs = plotaxis1;
        
        samplestartmin = str2num(get(handles.pos1durstartmin,'String'));
        samplestartsec = str2num(get(handles.pos2durstartsec,'String'));
        totalStart = samplestartmin * 60 + samplestartsec;
        
        sampleendmin = str2num(get(handles.pos2durendmin,'String'));
        sampleendsec = str2num(get(handles.pos1durendsec,'String'));
        sampleeEnd = sampleendmin * 60 + sampleendsec ;
        
        tempsoundPlay = audioplayer(musdat1.sounStrem * handles.vlmnSlider.Value,musdat1.samRate * handles.speedcontrol.Value,16,editDat.selIdofOD);
        beginningSample =(musdat1.samRate * totalStart) + 80;
        limitofY = get(axs, 'YLim'); % get the y-axis limits
        dataaPlot = [limitofY(1):0.1:limitofY(2)];
        
        tempsoundPlay.TimerPeriod = 0.01;
        tempsoundPlay.TimerFcn = {@functionfiles.MarkerPlot,tempsoundPlay, axs, dataaPlot};
        
        sampleeEnd = musdat1.samRate * sampleeEnd ;
        if(sampleeEnd > length(musdat1.sounStrem))
            sampleeEnd = length(musdat1.sounStrem);
        end
        playblocking(tempsoundPlay,[beginningSample sampleeEnd]);
        % set UI fields
        set(handles.outputDevList,'Enable','off');
        set(handles.sampleRateValue,'String',musdat1.samRate);
    else
        functionfiles.invalidnumerror;
    end
end


%Opening function for playButtonPos2_Callback
function playBtnPos2_Callback(hObject, eventdata, handles)
global musdat2;
global editDat;
global plotaxis2;

% To validate the sound stream and through error incase of any issues
if(functionfiles.validatemusdat2 == 1)
    functionfiles.fileerror;
else
    if(functionfiles.pos2startendvalidate(handles) == 1)
        %check the handle value for the end filepos of 2
        axs = plotaxis2;
        samplestartmin = str2num(get(handles.pos2durstartmin,'String'));
        samplestartsec = str2num(get(handles.pos2durstartsec,'String'));
        totalStart = samplestartmin * 60 + samplestartsec;
        
        sampleendmin = str2num(get(handles.pos2durendmin,'String'));
        sampleendsec = str2num(get(handles.pos2durendsec,'String'));
        sampleeEnd = sampleendmin * 60 + sampleendsec ;
        
        
        tempsoundPlay = audioplayer((musdat2.sounStrem * handles.vlmnSlider.Value),...
            (musdat2.samRate * handles.speedcontrol.Value),...
            16,editDat.selIdofOD);
        beginningSample = (musdat2.samRate * totalStart ) + 80;
        sampleeEnd = musdat2.samRate * sampleeEnd ;
        if(sampleeEnd > length(musdat2.sounStrem))
            sampleeEnd = length(musdat2.sounStrem);
        end
        limitofY = get(axs, 'YLim'); % to retrieve the y axis limit for the plot
        dataaPlot = [limitofY(1):0.1:limitofY(2)];
        
        tempsoundPlay.TimerPeriod = 0.01;
        tempsoundPlay.TimerFcn = {@functionfiles.MarkerPlot,tempsoundPlay, axs, dataaPlot};
        
        playblocking(tempsoundPlay,[beginningSample sampleeEnd]);
        % setting the fileds for ui
        set(handles.sampleRateValue,'String',musdat2.samRate);
    else
        functionfiles.invalidnumerror;
    end
end



%Opening function for Edit_Callback
function Edit_Callback(hObject, eventdata, ~)
%letting the function blank as it will be called when inputing number for
%the duration and pass on



%Opening function for joinButton_Callback
function joinBtn_Callback(hObject, eventdata, handles)
global editDat;
global musdat1;
global musdat2;

filepos = 1;
if(handles.pos2Btn.Value == 1)
    filepos = 2;
end

if(functionfiles.pos1startendvalidate(handles) == 0 || functionfiles.pos2startendvalidate(handles) == 0 )
    functionfiles.invalidnumerror;
else
    if(functionfiles.validateSounds == 1)
        functionfiles.nosounderror;
    else
        functionfiles.mergeSounds(filepos,handles);
    end
end





%Opening function for plotaxispos1_CreateFcn
function plotaxis1_CreateFcn(hObject, ~, handles)
global plotaxis1;
plotaxis1 = hObject;
set(plotaxis1,'NextPlot','add')


%Opening function for plotaxispos2_CreateFcn
function plotaxis2_CreateFcn(hObject, ~, handles)
global plotaxis2;
plotaxis2 = hObject;
set(plotaxis2,'NextPlot','add')



%Opening function for generate_tone_Callback 
function generate_tone_Callback(hObject, eventdata, handles)
generate_tone;
%calling another file with the gui name tone_generaion



%Opening function for reverse_Callback
function reverse_Callback(hObject, eventdata, handles)
global editDat;
global musdat1;
global musdat2;
if(isempty(editDat.data_music) || isempty(editDat.data_music.fname))
    functionfiles.fileerror;
    %check and validate the sound file other throw error by system
else
    % creating new sound and play with global variable
    if(handles.pos2Btn.Value == 1)
        filepos = 2;
    else
        filepos = 1;
    end
        functionfiles.reverseSound(filepos,handles);
        %calling the function which is in next file  functionfiles
    
end





%Opening function for trimButton_Callback
function trimButton_Callback(hObject, eventdata, handles)
global editDat;
filepos = 1;
if(handles.pos2Btn.Value == 1)
    filepos = 2;
end

if(functionfiles.pos1startendvalidate(handles) == 0 || functionfiles.pos2startendvalidate(handles) == 0 )
    functionfiles.invalidnumerror;
else
    if(isempty(editDat.data_music) || isempty(editDat.data_music.fname))
        functionfiles.fileerror;
    else
        try
            functionfiles.trimSound(filepos,handles);
        throw exception
            msgbox('Input the correct data duration','Warning');        
        end
    end
end



%Opening function for recordAudio_Callback
function recordAudio_Callback(hObject, eventdata, handles)
record_audio; 
%calling another file with the gui name record_audio


%Opening function for mixerSlider_Callback
function mixerSlider_Callback(hObject, eventdata, handles)
addlistener(handles.mixerSlider,'Value','PostSet',@(s,e) set(handles.insertTime, 'String', round(handles.mixerSlider.Value, 1)));



%Opening function for mixerSlider_CreateFcn
function mixerSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%Opening function for mixButton_Callback
function mixButton_Callback(hObject, eventdata, handles)
global sampsound1;
global sampsound2;
global d1;
global d2;
global editDat;
global musdat1;
global musdat2;
global plotaxis1;
global plotaxis2;
if(functionfiles.pos1startendvalidate(handles) == 0 || functionfiles.pos2startendvalidate(handles) == 0 )
    functionfiles.invalidnumerror;
    %validating the input duration or section number for the audio file
else
    if(functionfiles.validateSounds == 1)
        functionfiles.nosounderror;
        %validating with sound file check to throw error
    else
        filepos = 1;
        if(handles.pos2Btn.Value == 1)
            %checking the filepos value so that it can be know that which
            %file is choosen
            filepos = 2;
        end
        if filepos == 1
            if get(sampsound2, 'NumberOfChannels') == 1 
                %make duplicate in case of track 2 is single channel
                tempdata2 = [d2 d2];
            else
                tempdata2 = d2;
            end
            if get(sampsound1, 'NumberOfChannels') == 1
                %make duplicate in case of track 1 is single channel
                d1 = [d1 d1];
            end
            sound1data=get(sampsound1,'TotalSamples');
            sample1freq=get(sampsound1,'sampleRate');

            sound2data=get(sampsound2,'TotalSamples');

            gettime=round(get(handles.mixerSlider,'value')) * sample1freq; 
            %Calculate the known value of the section where to add the nex
            %sample according to time duration of main file

            if (sound2data+gettime) > sound1data %if irst track have more than second track and the knwon time of section then pass
                %track 1 need to be extended for this case
                newsoundadd = sound2data+gettime-sound1data; %know the track value and determine how many duration blank sample is needed to add
                blankaudio = zeros(newsoundadd,2); %with the matrix of zero create new sample
                d1 = [d1 ; blankaudio];  %adding the null sample before track 1
            end

            newsoundaddPre = gettime; %new sample data value for further references
            blankaudioPre = zeros(newsoundaddPre,2); %with the matrix of zeros create sample track to be added before track 1

            if (sound2data+gettime) < sound1data %know if the sound data 1 have more sample rate than sound sample2 and the time requested to join 
                newsoundaddPost = sound1data - gettime - sound2data; %process to generalize how to add the next audio for needed section.
                blankaudioPost = zeros(newsoundaddPost,2); %as a matrix of zero empty the audio with two channels
                d2Manip = [blankaudioPre ; tempdata2 ; blankaudioPost]; %adding empty section aefore and after of sample 2 for justifing equality
            else %In case of two sample sound with same sample rate then just pass it on
                d2Manip = [blankaudioPre ; tempdata2];
            end

            d1 = d1 + d2Manip; %New combined track data in  d1
            sampsound1 = audioplayer(d1,sample1freq); %giving the new sound sampe with audioplayer for sampsound1 for fututre reference
            musdat1.sounStrem = d1;
            musdat1.samRate = sample1freq;             
            editDat.customdatareplot(plotaxis1,musdat1);                     
            musdat1.fname = 'MixedSound.wav'; %giving name for new audio sound which is generated just now
            editDat.data_music = musdat1;
            % Setting variables for ui
            set(handles.durationText1,'String',editDat.data_music.timedurationinstr);
            set(handles.pos1durendmin,'String',editDat.data_music.timedurationinmin);
            set(handles.pos1durendsec,'String',editDat.data_music.timedurationinsec);
            
            
        else
            % in case of choosen of second file as main file so that the
            % first position sound will be overlapped
            
            if get(sampsound1, 'NumberOfChannels') == 1 
                %%make duplicate in case of track 2 is single channel
                tempdata1 = [d1 d1];
            else
                tempdata1 = d1;
            end
            if get(sampsound2, 'NumberOfChannels') == 1
                %make duplicate in case of track 1 is single channel
                d2 = [d2 d2];
            end
            sound2data=get(sampsound2,'TotalSamples');
            sample2freq=get(sampsound2,'sampleRate');

            sound1data=get(sampsound1,'TotalSamples');

            gettime=round(get(handles.mixerSlider,'value')) * sample2freq; 
            %Calculate the known value of the section where to add the nex
            %sample according to time duration of main file

            if (sound1data+gettime) > sound2data %if irst track have more than second track and the knwon time of section then pass
                %track need to be extended for this case
                newsoundadd = sound1data+gettime-sound2data; %know the track value and determine how many duration blank sample is needed to add
                blankaudio = zeros(newsoundadd,2); %with the matrix of zero create new sample
                d2 = [d2 ; blankaudio];  %adding the null sample before track 1
            end

            newsoundaddPre = gettime; %new sample data value for further references
            blankaudioPre = zeros(newsoundaddPre,2); %with the matrix of zeros create sample track to be added before track 1

            if (sound1data+gettime) < sound2data %know if the sound data 1 have more sample rate than sound sample2 and the time requested to join 
                newsoundaddPost = sound2data - gettime - sound1data; %process to generalize how to add the next audio for needed section.
                blankaudioPost = zeros(newsoundaddPost,2); %as a matrix of zero empty the audio with two channels
                d1Manip = [blankaudioPre ; tempdata1 ; blankaudioPost]; %adding empty section aefore and after of sample 2 for justifing equality
            else %In case of two sample sound with same sample rate then just pass it on
                d1Manip = [blankaudioPre ; tempdata1];
            end

            d2 = d2 + d1Manip; %New combined track data in  d1
            sampsound2 = audioplayer(d2,sample2freq); %giving the new sound sampe with audioplayer for sampsound1 for fututre reference
            musdat2.sounStrem = d2;
            musdat2.samRate = sample2freq;             
            editDat.customdatareplot(plotaxis2,musdat2);                     
            musdat2.fname = 'MixedSound.wav'; %giving name for new audio sound which is generated just now
            editDat.data_music = musdat2;
            % Setting variables for ui
            set(handles.durationText2,'String',editDat.data_music.timedurationinstr);
            set(handles.pos2durendmin,'String',editDat.data_music.timedurationinmin);
            set(handles.pos2durendsec,'String',editDat.data_music.timedurationinsec);
            
        end
    end
end




%Opening function for File_Callback
function File_Callback(hObject, ~, ~)
%letting the function blank as it will be called when opening files and pass on


%Opening function for pos1durendmin_Callback
function pos1durendmin_Callback(hObject, eventdata, ~)
%letting the function blank as it will be called when inputing number for
%the duration and pass on

%Opening function for pos1durstartmin_Callback
function pos1durstartmin_Callback(hObject, eventdata, ~)
%letting the function blank as it will be called when inputing number for
%the duration and pass on


%Opening function for pos1durstartsec_Callback
function pos1durstartsec_Callback(hObject, eventdata, ~)
%letting the function blank as it will be called when inputing number for
%the duration and pass on


%Opening function for 
function pos1dursendsec_Callback(hObject, eventdata, ~)
%letting the function blank as it will be called when inputing number for
%the duration and pass on


%Opening function for 
function pos1durendmin_CreateFcn(hObject, eventdata, ~)
%letting the function blank as it will be called when inputing number for
%the duration and pass on


%Opening function for 
function pos1durstartsec_CreateFcn(hObject, eventdata, ~)
%letting the function blank as it will be called when inputing number for
%the duration and pass on




%Opening function for pos1durstartsec_CreateFcn
function pos1Btn_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on


%Opening function for pos2durstartmin_CreateFcn
function pos2durstartmin_CreateFcn(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on




%Opening function for pos2durstartmin_CreateFcn
function pos2Btn_Callback(hObject, eventdata, handles)
%letting the function blank as it will be called when inputing number for
%the duration and pass on


% --- Executes on button press in pushbtn10.
function pushbtn10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtn10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbtn9.
function pushbtn9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtn9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in pushbtn9.
function inputDevList_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtn9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on key press with focus on pos1Btn and none of its controls.
function pos1Btn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pos1Btn (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
