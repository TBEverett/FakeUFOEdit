clc
close all 
clear

% leemos el video y extraemos cada uno de los frames
nombre_video = "Video2.mp4";
video = VideoReader(nombre_video);

% parametros relevantes del video
duracion_en_segundos = video.Duration; 
cantidad_de_frames = video.NumFrames; 
filas = video.Height;
columnas = video.Width;
frame_rate = video.FrameRate;

% vamos a leer la cantidad total de segundos redondeado
frames_en_x_seg = frame_rate*round(duracion_en_segundos);
frames = [];
currAxes = axes;
for n = 1:frames_en_x_seg
    disp(['leyendo frame #', num2str(n)])
    vidFrame = readFrame(video);
    frames(:,:,:,n) = imresize(vidFrame,0.9,"bicubic"); % 25% del tamaño original
    %image(vidFrame,"Parent",currAxes)
    %daspect([1,1,1])
    %currAxes.Visible = "off";
    %pause(1/video.FrameRate)
end
clear video

%%
% convierto los frames guardados a uint8
frames_uint8 = uint8(frames);
figure,
currAxes = axes;
for n = 1:frames_en_x_seg
    image(frames_uint8(:,:,:,n),"Parent",currAxes)
    daspect([1,1,1])
    currAxes.Visible = "off";
    pause(1/frame_rate)
end

%%
% paso a la imagen a escala de grises
frames_uint8_GRAY = squeeze(0.299 * frames_uint8(:,:,1,:) + 0.587 * frames_uint8(:,:,3,:) + 0.114 * frames_uint8(:,:,3,:));
figure,
currAxes = axes;
for n = 1:frames_en_x_seg
    image(frames_uint8_GRAY(:,:,n),"Parent",currAxes)
    colormap gray
    daspect([1,1,1])
    currAxes.Visible = "off";
    pause(1/frame_rate)
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 

img = imread("ufojpg.jpg");
img = rgb2gray(img);
mask = 1 - imbinarize(img);
img = imresize(img,[100 100]);
mask = imresize(mask, [100 100]);
img = im2double(img);
img_dims = size(img);

frame = frames_uint8_GRAY(:,:,1);
frame = im2double(frame);
frame_dims = size(frame);

frame_edit = frame(500:599,500:599).*mask + img;
frame(500:599,500:599) = frame_edit;

imshow(frame)


%% 
frame_dims = size(frame);
for n = 1:180
    frame = frames_uint8_GRAY(:,:,n);
    frame = im2double(frame);
   
    frame_edit = frame(500:599,500:599).*mask + img;
    frame(500:599,500:599) = frame_edit;

    final(:,:,n) = frame;
end

imshow(final(:,:,5));

%%
% guardar video generado RGB
v = split(nombre_video,'.');
video_out = VideoWriter([v{1},'_25.mp4'],'MPEG-4');
open(video_out);

for k = 1:size(frames_uint8,4) 
    writeVideo(video_out,frames_uint8(:,:,:,k));
end

close(video_out);

%%
% guardar video generado RGB
v = split(nombre_video,'.');
video_out = VideoWriter([v{1},'_25_GRAY.mp4'],'MPEG-4');
open(video_out);

final_final = final ./ max(final,[],'all');

for k = 1:180
    frames_uint8_GRAY(:,:,k);
    writeVideo(video_out,final_final(:,:,k));
end

close(video_out);