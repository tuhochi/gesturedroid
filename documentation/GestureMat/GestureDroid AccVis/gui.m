function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 20-Mar-2011 13:17:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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



% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;
set(handles.bgClassHardware,'SelectionChangeFcn',@hardwareClassSelect_buttongroup_SelectionChangeFcn);
set(handles.bgHardware,'SelectionChangeFcn',@hardwareSelect_buttongroup_SelectionChangeFcn);
set(gcf,'windowbuttonmotionfcn',@axesMouse);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global folderStruct filenameClassAccList filenameOrdnerClassAcc...
       subFolderStructClassAcc selectedHardware selectedClassHardware...
       filenameAccList filenameOrdnerAcc subFolderStructAcc featureSet...
       drawedDataPropCA drawedDataPropA drawedDataPropFCM drawedDataPropFM...
       lineProperty

%Initialisierung
selectedHardware={'Phone','/android/'};
selectedClassHardware={'Phone','/android/'};
filenameClassAccList=[];
filenameAccList=[];
filenameOrdnerClassAcc=[];
filenameOrdnerAcc=[];
subFolderStructClassAcc=[];
subFolderStructAcc=[];
folderStruct=[];
featureSet=[];
drawedDataPropCA=[];
drawedDataPropA=[];
drawedDataPropFCM=[];
drawedDataPropFM=[];
lineProperty=[];

%Files auslesen
listingFolder=dir('data/');
listingFolder=listingFolder(3:end);
folderStruct{1}='-';
j=1;
for i=1:size(listingFolder,1)
    if realfile(listingFolder(i).name)
        folderStruct{j+1}=listingFolder(i).name;
        j=j+1;
    end
end

%Farben erstellen
t=10;
colorProp= 0.3:(1-0.3)/(t-1):1;
colorProp=sort(colorProp,'descend');

typ = struct('line',{'-','.','--',':'});% die verschiedenen Linien Typen
lineProperty = struct('r',{},'g',{},'b',{}, 'line',{},'channels',{});
for i=1:t;
    lineProperty(i).r={[colorProp(i) 0 0]};
    lineProperty(i).g={[0 colorProp(i) 0]};
    lineProperty(i).b={[0 0 colorProp(i)]};
    lineProperty(i).line= {typ(mod(i-1,size(typ,2))+1).line};
    lineProperty(i).channels= {3};  
end

%PopupMenue laden
set(handles.pmClassAccFolder, 'String', folderStruct)
set(handles.pmAccFolder, 'String', folderStruct)
set(handles.pmVideo, 'String', folderStruct)
set(handles.buttonVideo,'Enable','off');
set(handles.pmFeature2,'Enable','off');
set(handles.pmFeature3,'Enable','off');





% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lbClassAccrecently.
function lbClassAccrecently_Callback(hObject, eventdata, handles)
% hObject    handle to lbClassAccrecently (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbClassAccrecently contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbClassAccrecently


% --- Executes during object creation, after setting all properties.
function lbClassAccrecently_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbClassAccrecently (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonAddClassAcc.
function buttonAddClassAcc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAddClassAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenameClassAccList filenameOrdnerClassAcc recentlyFolderClassAcc...
       subFolderStructClassAcc drawedDataPropCA lineProperty
index_selected = get(handles.lbClassAccFolder,'Value');
file_list = get(handles.lbClassAccFolder,'String');
% Item selected in list box
filename = file_list{index_selected};
filenameClassAccList{size(filenameClassAccList,2)+1}=filename;
%FileName aus OrdnerListe entfernen
subFolderStructClassAcc(index_selected)=[];

%Zugehöriger Ordner
filenameOrdnerClassAcc{size(filenameOrdnerClassAcc,2)+1}={recentlyFolderClassAcc{1} recentlyFolderClassAcc{2}};

%Liste laden
set(handles.lbClassAccrecently, 'String', filenameClassAccList)
set(handles.lbClassAccFolder, 'String', subFolderStructClassAcc)
%-------------------
% ZEICHNEN
%-------------------
drawedDataPropCA=drawing(handles,'classAcc',filenameClassAccList,filenameOrdnerClassAcc,lineProperty);



% --- Executes on button press in buttonRemoveClassAcc.
function buttonRemoveClassAcc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRemoveClassAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenameClassAccList filenameOrdnerClassAcc recentlyFolderClassAcc...
       subFolderStructClassAcc drawedDataPropCA lineProperty
index_selected = get(handles.lbClassAccrecently,'Value');
file_list = get(handles.lbClassAccrecently,'String');
% Item selected in list box
filename = file_list{index_selected};
subFolderStructClassAcc{size(subFolderStructClassAcc,2)+1}=filename;
%FileName aus RecentlyListe entfernen
filenameClassAccList(index_selected)=[];

%Zugehöriger Ordner
filenameOrdnerClassAcc(index_selected)=[];
%Liste laden
set(handles.lbClassAccrecently,'Value',1)
set(handles.lbClassAccrecently, 'String', filenameClassAccList)
set(handles.lbClassAccFolder, 'String', subFolderStructClassAcc)
%-------------------
% ZEICHNEN
%-------------------
cla (handles.axesClassAcc,'reset');
drawedDataPropCA=drawing(handles,'classAcc',filenameClassAccList,filenameOrdnerClassAcc,lineProperty);


% --- Executes on selection change in lbClassAccFolder.
function lbClassAccFolder_Callback(hObject, eventdata, handles)
% hObject    handle to lbClassAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbClassAccFolder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbClassAccFolder


% --- Executes during object creation, after setting all properties.
function lbClassAccFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbClassAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lbAccrecently.
function lbAccrecently_Callback(hObject, eventdata, handles)
% hObject    handle to lbAccrecently (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbAccrecently contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbAccrecently


% --- Executes during object creation, after setting all properties.
function lbAccrecently_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbAccrecently (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonAddAcc.
function buttonAddAcc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAddAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenameAccList filenameOrdnerAcc recentlyFolderAcc...
       subFolderStructAcc drawedDataPropA lineProperty
index_selected = get(handles.lbAccFolder,'Value');
file_list = get(handles.lbAccFolder,'String');
% Item selected in list box
filename = file_list{index_selected};
filenameAccList{size(filenameAccList,2)+1}=filename;
%FileName aus OrdnerListe entfernen
subFolderStructAcc(index_selected)=[];

%Zugehöriger Ordner
filenameOrdnerAcc{size(filenameOrdnerAcc,2)+1}={recentlyFolderAcc{1} recentlyFolderAcc{2}};

%Liste laden
set(handles.lbAccrecently, 'String', filenameAccList)
set(handles.lbAccFolder, 'String', subFolderStructAcc)
%-------------------
% ZEICHNEN
%-------------------
drawedDataPropA=drawing(handles,'acc',filenameAccList,filenameOrdnerAcc,lineProperty);




% --- Executes on button press in buttonRemoveAcc.
function buttonRemoveAcc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRemoveAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenameAccList filenameOrdnerAcc recentlyFolderAcc...
       subFolderStructAcc drawedDataPropA lineProperty
index_selected = get(handles.lbAccrecently,'Value');
file_list = get(handles.lbAccrecently,'String');
% Item selected in list box
filename = file_list{index_selected};
subFolderStructAcc{size(subFolderStructAcc,2)+1}=filename;
%FileName aus RecentlyListe entfernen
filenameAccList(index_selected)=[];

%Zugehöriger Ordner
filenameOrdnerAcc(index_selected)=[];

%Liste laden
set(handles.lbAccrecently,'Value',1)
set(handles.lbAccrecently, 'String', filenameAccList)
set(handles.lbAccFolder, 'String', subFolderStructAcc)
%-------------------
% ZEICHNEN
%-------------------
cla (handles.axesAcc,'reset');
drawedDataPropA=drawing(handles,'acc',filenameAccList,filenameOrdnerAcc,lineProperty);




% --- Executes on selection change in lbAccFolder.
function lbAccFolder_Callback(hObject, eventdata, handles)
% hObject    handle to lbAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbAccFolder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbAccFolder


% --- Executes during object creation, after setting all properties.
function lbAccFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonClassAccClear.
function buttonClassAccClear_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClassAccClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenameClassAccList filenameOrdnerClassAcc recentlyFolderClassAcc...
       subFolderStructClassAcc
filenameClassAccList=[];
filenameOrdnerClassAcc=[];
subFolderStructClassAcc=[];
recentlyFolderClassAcc=[];
cla (handles.axesClassAcc,'reset');
set(handles.pmClassAccFolder,'Value',1);
set(handles.lbClassAccFolder, 'String', {});
set(handles.lbClassAccrecently, 'String', {});


% --- Executes on selection change in pmClassAccFolder.
function pmClassAccFolder_Callback(hObject, eventdata, handles)
% hObject    handle to pmClassAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns pmClassAccFolder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmClassAccFolder
global folderStruct subFolderStructClassAcc recentlyFolderClassAcc selectedClassHardware
       
selectedFolderNr=get(handles.pmClassAccFolder,'Value');
recentlyFolderClassAcc={folderStruct{selectedFolderNr}, selectedClassHardware{2}};

if strcmp(recentlyFolderClassAcc,'-')
    subFolderStructClassAcc{1}='';
else
    %Files auslesen
    listingFolder=dir(['data/' recentlyFolderClassAcc{1} selectedClassHardware{2}]);
    listingFolder=listingFolder(3:end);
    for i=1:size(listingFolder,1)
        subFolderStructClassAcc{i}=listingFolder(i).name;
    end
end
%Liste laden
set(handles.lbClassAccFolder, 'String', subFolderStructClassAcc)



% --- Executes during object creation, after setting all properties.
function pmClassAccFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmClassAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonAccClear.
function buttonAccClear_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAccClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenameAccList filenameOrdnerAcc recentlyFolderAcc...
       subFolderStructAcc
filenameAccList=[];
filenameOrdnerAcc=[];
subFolderStructAcc=[];
recentlyFolderAcc=[];
cla (handles.axesAcc,'reset');
set(handles.pmAccFolder,'Value',1);
set(handles.lbAccFolder, 'String', {});
set(handles.lbAccrecently, 'String', {});


% --- Executes on selection change in pmAccFolder.
function pmAccFolder_Callback(hObject, eventdata, handles)
% hObject    handle to pmAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns pmAccFolder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmAccFolder
global folderStruct subFolderStructAcc recentlyFolderAcc selectedHardware

selectedFolderNr=get(handles.pmAccFolder,'Value');
recentlyFolderAcc={folderStruct{selectedFolderNr}, selectedHardware{2}};
if strcmp(recentlyFolderAcc,'-')
    subFolderStructAcc{1}='';
else
    %Files auslesen
    listingFolder=dir(['data/' recentlyFolderAcc{1} selectedHardware{2}]);
    listingFolder=listingFolder(3:end);
    for i=1:size(listingFolder,1)
        subFolderStructAcc{i}=listingFolder(i).name;
    end
end
%PopupMenue laden
set(handles.lbAccFolder, 'String', subFolderStructAcc)


% --- Executes during object creation, after setting all properties.
function pmAccFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmAccFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonShowFeatures.
function buttonShowFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to buttonShowFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filenameAccList filenameClassAccList filenameOrdnerAcc...
       filenameOrdnerClassAcc featureSet drawedDataPropFCM drawedDataPropFM...
       lineProperty
%-------------------
% ZEICHNEN
%-------------------
drawedDataPropFCM=drawing(handles,'featureClassMode',filenameClassAccList,filenameOrdnerClassAcc,lineProperty,featureSet);
drawedDataPropFM=drawing(handles,'featureMode',filenameAccList,filenameOrdnerAcc,lineProperty,featureSet);

% --- Executes on button press in buttonVideo.
function buttonVideo_Callback(hObject, eventdata, handles)
% hObject    handle to buttonVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recentlyVideoFolder 
videoData=['data/' recentlyVideoFolder 'video.MP4'];



% --- Executes on button press in buttonClearFeatures.
function buttonClearFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClearFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global featureSet

set(handles.pmFeature1,'Value',1);
set(handles.pmFeature2,'Value',1);
set(handles.pmFeature3,'Value',1);
set(handles.pmFeature2,'Enable','off');
set(handles.pmFeature3,'Enable','off');
cla (handles.axesClassFeature,'reset');
cla (handles.axesFeature,'reset');
featureSet=[];


% --- Executes on button press in rbClassPhone.
function rbClassPhone_Callback(hObject, eventdata, handles)
% hObject    handle to rbClassPhone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbClassPhone


% --- Executes on button press in rbClassWii.
function rbClassWii_Callback(hObject, eventdata, handles)
% hObject    handle to rbClassWii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbClassWii

function hardwareClassSelect_buttongroup_SelectionChangeFcn(hObject, eventdata)
 
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

global selectedClassHardware filenameClassAccList filenameOrdnerClassAcc...
       subFolderStructClassAcc recentlyFolderClassAcc
switch get(eventdata.NewValue,'Tag');   % Get Tag of selected object
    case 'rbClassPhone'
        selectedClassHardware={'Phone','/android/'};
 
    case 'rbClassWii'
        selectedClassHardware={'Wii','/wii/'};
 
    otherwise
end
%updates the handles structure
guidata(hObject, handles);
filenameClassAccList=[];
filenameOrdnerClassAcc=[];
subFolderStructClassAcc=[];
recentlyFolderClassAcc=[];
cla (handles.axesClassAcc,'reset');
set(handles.pmClassAccFolder,'Value',1);
set(handles.lbClassAccFolder, 'String', {});
set(handles.lbClassAccrecently, 'String', {});

function hardwareSelect_buttongroup_SelectionChangeFcn(hObject, eventdata)
 
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

global selectedHardware
switch get(eventdata.NewValue,'Tag');   % Get Tag of selected object
    case 'rbPhone'
        selectedHardware={'Phone','/android/'};
 
    case 'rbWii'
        selectedHardware={'Wii','/wii/'};
 
    otherwise
end
%updates the handles structure
guidata(hObject, handles);
set(handles.pmAccFolder,'Value',1);
set(handles.lbAccFolder, 'String', {});


% --- Executes on selection change in pmVideo.
function pmVideo_Callback(hObject, eventdata, handles)
% hObject    handle to pmVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pmVideo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmVideo
global folderStruct recentlyVideoFolder 
       
selectedFolderNr=get(handles.pmVideo,'Value');
recentlyVideoFolder=folderStruct{selectedFolderNr};

if strcmp(recentlyVideoFolder,'-')
    set(handles.buttonVideo,'Enable','off');
else
    set(handles.buttonVideo,'Enable','on');
end




% --- Executes during object creation, after setting all properties.
function pmVideo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkBetrag.
function checkBetrag_Callback(hObject, eventdata, handles)
% hObject    handle to checkBetrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkBetrag
% global betragAcc
% if get(hObject,'Value')==1
%     betragAcc=1;
% else
%     betragAcc=0;
% end
% cla (handles.axesClassFeature,'reset');
% cla (handles.axesFeature,'reset');

% --- Executes on button press in checkNormalisieren.
function checkNormalisieren_Callback(hObject, eventdata, handles)
% hObject    handle to checkNormalisieren (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkNormalisieren
% global normalizationAcc
% if get(hObject,'Value')==1
%     normalizationAcc=1;
% else
%     normalizationAcc=0;
% end
% cla (handles.axesClassFeature,'reset');
% cla (handles.axesFeature,'reset');

% --- Executes on button press in checkSkalieren.
function checkSkalieren_Callback(hObject, eventdata, handles)
% hObject    handle to checkSkalieren (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkSkalieren
% global scaleAcc
% if get(hObject,'Value')==1
%     scaleAcc=1;
% else
%     scaleAcc=0;
% end
% cla (handles.axesClassFeature,'reset');
% cla (handles.axesFeature,'reset');

function axesMouse(hObject, eventdata)
%disp('HAHA!!')


% --- Executes on selection change in pmFeature1.
function pmFeature1_Callback(hObject, eventdata, handles)
% hObject    handle to pmFeature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns pmFeature1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmFeature1
global featureSet
selectedFeatureNr=get(handles.pmFeature1,'Value');
switch selectedFeatureNr;
    case 1
        % -
        featureSet{size(featureSet,2)+1}='-';
        set(handles.pmFeature2,'Enable','off');
        set(handles.pmFeature3,'Enable','off');
        featureSet{2}=[];
        featureSet{3}=[];
    case 2
        % Skalierung
        featureSet{size(featureSet,2)+1}='skalieren';
        set(handles.pmFeature2,'Enable','on');
    case 3
        % Normalisieren
        featureSet{size(featureSet,2)+1}='normieren';
        set(handles.pmFeature2,'Enable','on');
    case 4
        % Betrag
        featureSet{size(featureSet,2)+1}='betrag';
        set(handles.pmFeature2,'Enable','on');
end


% --- Executes during object creation, after setting all properties.
function pmFeature1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmFeature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmFeature2.
function pmFeature2_Callback(hObject, eventdata, handles)
% hObject    handle to pmFeature2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns pmFeature2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmFeature2
global featureSet
selectedFeatureNr=get(handles.pmFeature2,'Value');
switch selectedFeatureNr;
    case 1
        % -
        featureSet{size(featureSet,2)+1}='-';
        set(handles.pmFeature3,'Enable','off');
        featureSet{3}=[];
    case 2
        % Skalierung
        featureSet{size(featureSet,2)+1}='skalieren';
        set(handles.pmFeature3,'Enable','on');
    case 3
        % Normalisieren
        featureSet{size(featureSet,2)+1}='normieren';
        set(handles.pmFeature3,'Enable','on');
    case 4
        % Betrag
        featureSet{size(featureSet,2)+1}='betrag';
        set(handles.pmFeature3,'Enable','on');
end


% --- Executes during object creation, after setting all properties.
function pmFeature2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmFeature2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmFeature3.
function pmFeature3_Callback(hObject, eventdata, handles)
% hObject    handle to pmFeature3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns pmFeature3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmFeature3
global featureSet
selectedFeatureNr=get(handles.pmFeature3,'Value');
switch selectedFeatureNr;
    case 1
        % -
        featureSet{size(featureSet,2)+1}='-';
    case 2
        % Skalierung
        featureSet{size(featureSet,2)+1}='skalieren';
    case 3
        % Normalisieren
        featureSet{size(featureSet,2)+1}='normieren';
    case 4
        % Betrag
        featureSet{size(featureSet,2)+1}='betrag';
end



% --- Executes during object creation, after setting all properties.
function pmFeature3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmFeature3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on mouse press over axes background.
function axesClassAcc_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesClassAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global drawedDataPropCA
drawLegend(drawedDataPropCA,handles,'classAcc');

% --- Executes on mouse press over axes background.
function axesAcc_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global drawedDataPropA
drawLegend(drawedDataPropA,handles,'acc');

% --- Executes on mouse press over axes background.
function axesClassFeature_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesClassFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global drawedDataPropFCM
drawLegend(drawedDataPropFCM,handles,'featureClassMode');

% --- Executes on mouse press over axes background.
function axesFeature_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global drawedDataPropFM
drawLegend(drawedDataPropFM,handles,'featureMode');
