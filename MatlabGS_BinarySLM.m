%% Algorithm to generate Pattern for projection onto Spatial Light Modulators

% Resolution of the SLM
ResX=1380
ResY=2048

%------------- We start with all black image and generate a target field intensity

% Generating all black image
E_target=zeros(ResX,ResY);

% E_target(300-100,396+60)=255;
% E_target(300-100,396+40)=255;


%% Generate the image of the required pattern
% We wish to generate a circle, with center (a,b) and radius r

a=ResX/2;
b=ResY/2;

r=1000.0;
delta=500;

% to generate a circle:
% for i=1:1:4*a
%     for j=1:1:4*b
%         if(  ((a-i)^2 +(b-j)^2>r) &&  ( (a-i)^2 +(b-j)^2<(r+delta) )   )
%             E_target(uint16(i),uint16(j))=255;
%             sprintf('%d %d',i,j)
%             
%         end
%     end
% end

% To generate a single spot
E_target(a+100,b)=255;

imshow(E_target)
title('target Pattern')
%  target pattern


%% 
%--------------- We generate a 256 bit phase distribution
E_target=fftshift(E_target);

Phase=rand(ResX,ResY)*(2*pi);
Phase_image=exp(-1i*Phase);
for j=1:1:10
    
    holo=ifftshift(ifft2(E_target.*Phase_image));
    
    Phase_holo=exp(-1i*angle(holo));
    
    E_focus=fft2(Phase_holo);
    Phase_image=exp(-1i*angle(E_focus));
end

Phase=angle(holo);

% For a general 256 bit SLM
Phase=uint8(mod(Phase+2*pi,2*pi)/(2*pi)*255);

%% 
% ----------- We convert the generated phase distribution to binary
%for the forthdd SLM which is binary
PhaseMat= angle(holo)>0;
Phase= uint8(PhaseMat*255);

% addSave=''
imshow(ifftshift(Phase))
imwrite(ifftshift(Phase),'GS_generated.bmp')
%This is the final generated image
