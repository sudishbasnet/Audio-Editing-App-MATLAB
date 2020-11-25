%opening the function for varargout
function varargout = generate_tone(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generate_tone_OpeningFcn, ...
                   'gui_OutputFcn',  @generate_tone_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
    %moving the gui to center
    movegui('center')
end



%opening the function for generate_tone_OpeningFcn
function generate_tone_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

 % setting the sample rate at 8192
 handles.fre= 8192;
 % with the help of audio recorder creating the recorder
 handles.recorder = audiorecorder(handles.fre,8,1);
 set(handles.recorder,'TimerPeriod',1,'TimerFcn',{@audioTimer,hObject});

guidata(hObject, handles);



%opening the function for
function varargout = generate_tone_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%opening the function for
function CBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=261.626;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);



%opening the function for
function DBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=293.665;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);



%opening the function for
function EBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=329.628;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    axy=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);


%opening the function for
function FBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim;
Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=349.228;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);



%opening the function for
function GBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim;
Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=391.995;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);

%opening the function for
function sineChoose_Callback(hObject, eventdata, handles)



%opening the function for
function squareChoose_Callback(hObject, eventdata, handles)



%opening the function for
function sawtoothChoose_Callback(hObject, eventdata, handles)



%opening the function for
function vlmnSlider_Callback(hObject, eventdata, handles)
global Amp
Amp=num2str(get(handles.vlmnSlider,'Value'));
set(handles.dispVol,'String',str2num(Amp));




%opening the function for
function vlmnSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%opening the function for
function ABtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim fre;

A=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=440.000;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);


%opening the function for
function BBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim fre;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=493.883;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);


%opening the function for
function high_CBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim fre;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=523.251;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);



%opening the function for
function C_sharpBtn_Callback(hObject, eventdata, handles)
%opening the function for
global yax Amp freq tim fre;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=277.183;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);



%opening the function for
function D_sharpBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim fre;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=311.127;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);


%opening the function for
function F_sharpBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim fre;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=369.994;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);



%opening the function for
function G_sharpBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim fre;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=415.305;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
    
sound(yax,fre);



%opening the function for
function A_sharpBtn_Callback(hObject, eventdata, handles)
global yax Amp freq tim fre;

Amp=get(handles.vlmnSlider,'Value');
fre=44100;
tim=0:(1/fre):1-(1/fre);
freq=466.164;

hrd=get(handles.makeaselection,'SelectedObject');
estring=get(hrd,'String');
if strcmpi(estring,'Sine');
    yax=Amp*sin(2.*pi.*freq.*tim);
elseif strcmpi(estring,'Square');
    yax=Amp*square(2.*pi.*freq.*tim);
else strcmpi(estring,'Sawtooth');
    yax=Amp*sawtooth(2.*pi.*freq.*tim);
end

axes(handles.freqAxes);

plot(tim,yax,'-r');
axis([0,0.012,-5,5]);
xlabel('T');
ylabel('Amp');
grid on;
  
sound(yax,fre);


%opening the function for
function saveBTN_Callback(hObject, eventdata, handles)
global yax fre;
fre=44100;
fname = uiputfile({'*.wav';'*.oga';'*.mp4';'*.ogg';'*.au';'*.flac';'*.m4a'},'Save as');
if(fname == 0)
    disp('Selection canceled for this');
else
audiowrite(fname,yax,fre);
end


%opening the function for
function saveBTN_CreateFcn(hObject, eventdata, handles)
dir = imread('img/save.png');
set(hObject,'CData',dir);





%opening the function for figure1_CloseRequestFcn
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
