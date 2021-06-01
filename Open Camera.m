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