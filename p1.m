function varargout = p1(varargin)
% P1 MATLAB code for p1.fig
%      P1, by itself, creates a new P1 or raises the existing
%      singleton*.
%
%      H = P1 returns the handle to a new P1 or the handle to
%      the existing singleton*.
%
%      P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in P1.M with the given input arguments.
%
%      P1('Property','Value',...) creates a new P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help p1

% Last Modified by GUIDE v2.5 25-May-2021 21:22:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @p1_OpeningFcn, ...
                   'gui_OutputFcn',  @p1_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before p1 is made visible.
function p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to p1 (see VARARGIN)

% Choose default command line output for p1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
close all;
clear all
warning off
load convnet;
c=webcam('USB 2.0 Webcam Device');
x=0;
y=0;
height=200;
width=200;
bboxes=[x y height width];
while true
    e=c.snapshot;
    IFaces=insertObjectAnnotation(e,'rectangle',bboxes,'Processing Area');
    es=imcrop(e,bboxes);
    es=imresize(es,[227 227]);
    label=classify(convnet,es);
    imshow(IFaces);
    title(char(label));
    drawnow;
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
clear all
close all
warning off
c=webcam('USB 2.0 Webcam Device');
x=0;
y=0;
height=200;
width=200;
bboxes=[x y height width];
temp=0;
while temp<=400
    e=c.snapshot;
    IFaces = insertObjectAnnotation(e,'rectangle',bboxes,'Processing Area');
    imshow(IFaces);
    filename=strcat(num2str(temp),'.bmp');
    es=imcrop(e,bboxes);
    es=imresize(es,[227 227]);
    imwrite(es,filename);
    temp=temp+1;
    drawnow;
end
clear c;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
clear all
close all
warning off
allImages=imageDatastore('Database','IncludeSubfolders',true,'LabelSource','foldernames');
layers=[imageInputLayer([227 227 3]),
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(10,'Stride',10)
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer()];
options = trainingOptions('sgdm', ... 
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.2, ...
    'LearnRateDropPeriod',5, ...
    'MaxEpochs',30,...
    'ValidationData',allImages, ...
    'ValidationFrequency',30, ...
    'MiniBatchSize',100,...
    'InitialLearnRate',0.0001,...
    'Plots','training-progress');
convnet=trainNetwork(allImages,layers,options);
save convnet;

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate axes1



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
imshow('D:\Rekrutasi\TUBES\UJI COBA\Logo Biospin.png')
% Hint: place code in OpeningFcn to populate axes3
