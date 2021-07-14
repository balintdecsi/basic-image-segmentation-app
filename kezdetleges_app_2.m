function varargout = kezdetleges_app_2(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kezdetleges_app_2_OpeningFcn, ...
                   'gui_OutputFcn',  @kezdetleges_app_2_OutputFcn, ...
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

function kezdetleges_app_2_OpeningFcn(hObject, eventdata, handles, varargin)

%Kepek importalasa:
handles.I = {};
handles.I(1) = {imread('African Green Monkey Kidney_cos1line.jpg')};
handles.I(2) = {imread('African Green Monkey Kidney_cos7line_2.jpg')};
handles.I(3) = {imread('Endothelial.jpg')};
[I, map] = imread('mp_tripple.png');
handles.I(4) = {ind2rgb(I,map)};

% Kek csatorna kivalasztasa mindegyik kepre(a tovabbiakban is mindegyik
% kepre vegrehajtodnak a metodusok:
handles.Ib = {};
for k = 1:4
    handles.Ib(k) = {handles.I{k}(:,:,3)};
end

% Kepek kuszobolese:
handles.Ibbw = {};
for k = 1:4
    handles.Ibbw(k) = {imbinarize(handles.Ib{k}, graythresh(handles.Ib{k}))};
end

% bwmorph fuggveny vegrehajtasa az osszefuggo teruletek "szemcsetlenitesere":
handles.Ibbwmorph = {};
for k = 1:4
    handles.Ibbwmorph(k) = {bwmorph(handles.Ibbw{k}, 'majority', inf)};
end

% Osszefuggo elemek teruletenek strukturaba gyujtese:
handles.S = {};
for k = 1:4
    handles.S(k) = {regionprops(handles.Ibbwmorph{k}, 'Area')};
end

% Kezdoertek hozzarendelese:
handles.current_data = 1;
imshow(handles.I{1});

handles.output = hObject;

% Valtoztatasok mentese:
guidata(hObject, handles);

function varargout = kezdetleges_app_2_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% 'Blue channel' nyomogomb:
function pushbutton1_Callback(hObject, eventdata, handles)

% A legordulo menu aktualis erteketol fuggoen valamelyik kep kek
% csatornajanak megjelenitese:
imshow(handles.Ib{handles.current_data});

% 'Binarize' nyomogomb:
function pushbutton2_Callback(hObject, eventdata, handles)

% A legordulo menu aktualis erteketol fuggoen valamelyik kep kek
% csatornajanak kuszobolt megfelelojenek megjelenitese:
imshow(handles.Ibbw{handles.current_data});

% 'Morph. Op.' nyomogomb:
function pushbutton3_Callback(hObject, eventdata, handles)

% Eddigiekhez hasonlo modon:
imshow(handles.Ibbwmorph{handles.current_data});

% 'Compare' nyomogomb:
function pushbutton4_Callback(hObject, eventdata, handles)

% bwmorph vegrehajtas elotti es utani kepek osszehasonlitasa:
i = handles.current_data;
imshowpair(handles.Ibbw{i}, handles.Ibbwmorph{i}, 'montage');

% 'STAT' nyomogomb:
function pushbutton5_Callback(hObject, eventdata, handles)

% Osszefuggo elemek teruleteinek(kezdetleges_app_2_OpeningFcn-ben mar
% strukturaba gyujtve) kiirasa a szoveges feluletre:
str = get(handles.popupmenu2, 'String');
val = get(handles.popupmenu2, 'Value');
% disp(handles.edit2.String);
% handles.edit2.String = ['Nuclei areas in image ''', ...
%     str{val}, ''': ' ... 
%     num2str([handles.S{handles.current_data}.Area])];
set(handles.edit2, 'String', ['Nuclei areas in image ''', ...
    str{val}, ''': ' ... 
    num2str([handles.S{handles.current_data}.Area])]);

% guidata(hObject, handles);

% Axes:
function axes1_CreateFcn(hObject, eventdata, handles)

% Legordulo menu:
function popupmenu2_Callback(hObject, eventdata, handles)

% Kivalasztott menupont meghatarozasa:
str = get(hObject, 'String');
val = get(hObject, 'Value');

% A kivalasztott ertektol fuggoen valamelyik kep megjelenitese es a
% handles.current_data valtozo ennek megfelelo atallitasa(a nyomogombok
% hasznalatahoz):
switch str{val}
case 'Monkey kidney_1'
   handles.current_data = 1;
   imshow(handles.I{1});
case 'Monkey kidney_2'
   handles.current_data = 2;
   imshow(handles.I{2});
case 'Endothelial cells'
   handles.current_data = 3;
   imshow(handles.I{3});
case 'Random animal cells'
   handles.current_data = 4;
   imshow(handles.I{4});
end

guidata(hObject,handles);

function popupmenu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
