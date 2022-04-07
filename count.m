function varargout = count(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @count_OpeningFcn, ...
                   'gui_OutputFcn',  @count_OutputFcn, ...
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




function count_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
axes(handles.axes1);
imshow('blank.jpg');
axis off;
set(handles.text2,'string','0');


guidata(hObject, handles);




function varargout = count_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function start_Callback(hObject, eventdata, handles)

vid = videoinput('winvideo' , 1, 'YUY2_640X480');



function count_Callback(hObject, eventdata, handles)


global vid     


triggerconfig( vid ,'manual');                                      
set(vid, 'FramesPerTrigger',1);                                    
set(vid, 'TriggerRepeat',Inf);                                       
set(vid,'ReturnedColorSpace','rgb');                                 
vid.Timeout = 10;
start(vid);  

while (1)  
facedetector = vision.CascadeObjectDetector;                                                                              
trigger(vid);                                                               
image = getdata(vid);                                                       
bbox = step(facedetector, image);                                           
insert_object = insertObjectAnnotation(image,'rectangle',bbox,'Face');      
imshow(insert_object);
axis off;                                                                  
no_rows = size(bbox,1);                                                     
X = sprintf('%d', no_rows);
set(handles.text2,'string',X);                                              
end




function stop_Callback(hObject, eventdata, handles)

global vid
stop(vid),clear vid 
