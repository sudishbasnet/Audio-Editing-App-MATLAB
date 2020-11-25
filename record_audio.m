% opening function for varargout
function varargout = record_audio(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @record_audio_OpeningFcn, ...
                   'gui_OutputFcn',  @record_audio_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
    movegui('center')
end

% opening function for record_audio_OpeningFcn
function record_audio_OpeningFcn(hObject, eventdata, handles, varargin)
%Buttons to be disabled
set(handles.denoiseBtn,'enable','off');
set(handles.BtnSave,'enable','off');
set(handles.replayBtn,'enable','off');
set(handles.playbackBtn,'enable','off');
set(handles.filterBtn,'enable','off');


%assigning values to handles objects
handles.highBound = 3800
handles.output = hObject;
handles.Fs = 8192;
handles.lowBound = 300
handles.state = 0;


global bit;
bit = 16;
global objectofRec;
objectofRec = audiorecorder(handles.Fs,bit,1);
set(objectofRec,'TimerPeriod',0.05,'TimerFcn',{@timerforaudio,handles});


%labeling labels for the axis
xlabel(handles.axesFrequencyFilter,'Freq(Hz)');
xlabel(handles.axesFrequency,'Freq(Hz)');
ylabel(handles.axesFrequency,'|Y(f)|')
xlabel(handles.axeTimeDomain,'T');
ylabel(handles.axesFrequencyFilter,'|Y(f)|')
ylabel(handles.axeTimeDomain, 'Amp');


% Updating the structure of handelers
guidata(hObject, handles);



% opening function for timerforaudio
function timerforaudio(hObject,event,handles)
if(isempty(hObject))
    return;
end
sam = getaudiodata(hObject);
plot(handles.axeTimeDomain, sam);

fil = 2^nextpow2(length(sam));
filtRecord = fft(sam,fil);
plot(handles.axesFrequency,abs(filtRecord(1:fil)));



% opening function for varargout
function varargout = record_audio_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% opening function for RecordBtn_Callback
function RecordBtn_Callback(hObject, eventdata, handles)
global objectofRec;
global status;

if handles.state == 0 
    set(hObject,'String','Pause');
    record(objectofRec);
    status = 0;
    handles.state =1 ;
    %buttons to be disabled
    set(handles.playbackBtn,'enable','off');
    set(handles.BtnSave,'enable','off');
    set(handles.replayBtn,'enable','off');
    set(handles.filterBtn,'enable','off');

else

    set(hObject,'String','Record');
    stop(objectofRec);
    handles.state = 0;
    status = 1;
    
    %buttons to be enabled
    set(handles.replayBtn,'enable','on');
    ylabel(handles.axeTimeDomain, 'Amp');
    set(handles.playbackBtn,'enable','on');
    set(handles.BtnSave,'enable','on');
    set(handles.denoiseBtn,'enable','on');
    xlabel(handles.axesFrequency,'Freq(Hz)');
    ylabel(handles.axesFrequency,'|Y(f)|')
    set(handles.filterBtn,'enable','on');
    xlabel(handles.axeTimeDomain,'T');

end

guidata(hObject,handles)


% opening function for stoprecord_Callback
function btn_stoprecord_Callback(hObject, eventdata, handles)
global flagRec;
flagRec = 0;



% opening function for replayBtn_Callback
function replayBtn_Callback(hObject, eventdata, handles)
global objectofRec;
global bit;
sam = getaudiodata(objectofRec);
[n m] = size(sam)

soundsc(sam, handles.Fs, bit);



% opening function for filterBtn_Callback
function filterBtn_Callback(hObject, eventdata, handles)
global objectofRec;
sam = getaudiodata(objectofRec);

lfreq = 2*(handles.lowBound)/handles.Fs
hfreq = 2*(handles.highBound)/ handles.Fs
a = 10
wn = fir1(a,[lfreq hfreq]);
global filterOut
filterOut = filter(wn,1,sam);


nft = 2^nextpow2(length(filterOut));
filtRecord = fft(filterOut,nft);

xlabel(handles.axesFrequencyFilter,'Freq(Hz)');
plot(handles.axesFrequencyFilter, abs(filtRecord(1:nft)));
ylabel(handles.axesFrequencyFilter,'|Y(f)|')


% opening function for playbackBtn_Callback
function playbackBtn_Callback(hObject, eventdata, handles)
global filterOut
global bit
%introducing try catch to prevent errors
try
    soundsc(filterOut, handles.Fs, bit);
catch exception
    msgbox('index array out of bound','Warning');
end




% opening function for denoiseBtn_Callback
function denoiseBtn_Callback(hObject, eventdata, handles)
global objectofRec;
global bit;
sam = getaudiodata(objectofRec);
Val = 10;
lamd = (Val-1)/Val;
lam = (1-lamd)*lamd.^(0:100);
filterSound = conv(sam,lam,'valid');
soundsc(filterSound, handles.Fs, bit);


%plotting the values to the axes in the GUI
xlim(handles.axeTimeDomain,[1 1000]);
plot(handles.axeTimeDomain, sam);
xlim(handles.axesFrequency,[1 1000]);
plot(handles.axesFrequency, filterSound);






% opening function for BtnSave_Callback
function BtnSave_Callback(hObject, eventdata, handles)
global objectofRec;
global bit;
    sam = getaudiodata(objectofRec);
    fname = uigetdir('','Choose folder to save'); %opening of folder to be selected for further purpose
    if fname
        filname = inputdlg('Input name for file:',... %opening of message box for inouting the file name
                     'select filename', [1 50]);
        if length(filname) == 1 %validating if name is checked
            dir = strcat(fname,'\',filname,'.wav'); %formulating the dir
            if exist(dir{1}, 'file') == 2 %validate if a file with same name exists in which case throw another dialog box with override warning
                conf = questdlg('Do you want the override the existing file?','Same name file is present','Yes','Exit','Exit');
                 if strcmp(conf,'Yes') %saving file with user selection 
                    audiowrite(dir{1},data1,sampleRate);
                 end
            else
                q = questdlg('Select Saving mode ','EXIT',...
            'Normal','Denoise','Denoise');
                switch q
                    %case for knowing either user selectes normal or
                    %denoise with switch case
                    case 'Denoise'
                        val = 10;
                        lamd = (val-1)/val;
                        val1 = (1-lamd)*lamd.^(0:100);
                        filterSound = conv(sam,val1,'valid');
                        audiowrite(dir{1},filterSound, handles.Fs); %saving the data to specefied file in the folder
                    case 'Normal'
                        audiowrite(dir{1},sam, handles.Fs); 
                end 
            end
        end
    end


% opening function for BtnSave_CreateFcn
function BtnSave_CreateFcn(hObject, eventdata, handles)
dir = imread('img/save.png');
set(hObject,'CData',dir);


% opening function for figure1_CloseRequestFcn
function figure1_CloseRequestFcn(hObject, eventdata, handles)
q = questdlg('Do you want to close?','EXIT',...
            'Yes','No','No');
switch q
    case 'Yes'
        delete(hObject);
        return;
    case 'No'
        quit cancel;
end 
