ResX=1380
ResY=2048

E_target=zeros(ResX,ResY);

% E_target(300-100,396+60)=255;
% E_target(300-100,396+40)=255;


%% Generate the image of the required pattern
% We wish to generate a circle, with center (a,b) and radius r

a=ResX/2;
b=ResY/2;

r=1000.0;
delta=500;
for i=1:1:4*a
    for j=1:1:4*b
        if(  ((a-i)^2 +(b-j)^2>r) &&  ( (a-i)^2 +(b-j)^2<(r+delta) )   )
            E_target(uint16(i),uint16(j))=255;
            sprintf('%d %d',i,j)
            
        end
    end
end
imshow(E_target)
% We show the target pattern


%%
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

%% for the forthdd SLM which is binary
PhaseMat= angle(holo)>0;
Phase= uint8(PhaseMat*255);

% addSave=''
imshow(ifftshift(Phase))
imwrite(ifftshift(Phase),'harsh1pGSA.bmp')
figure()
imshow(ifftshift(E_target))
