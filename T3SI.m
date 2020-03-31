function y=T3SI(I,J)
%input:
%     I:the reference image 
%     J:texture filtered image

figure
imshow(J)
x=ginput; %to select texture patches, press 'Enter' to stop
x1=ginput;%to select detail patches, press 'Enter' to stop
ps=calculate_EPI_ssim(I,J,x,x1);
p1=(1-ps(:,1))*0.35+0.001;
p2=ps(:,2)*0.35+0.001;
CE2=-p1.*log2(p1)-p2.*log2(p2);
ET=exp(CE2);
% out=[ps,ET];
y=ET;

function out=calculate_EPI_ssim(J,I,x,x1)
% calculate local PSNR and SSIM on patches
figure
imshow(I)
r=12;%Default window radius r=12
im_ttI=[];im_ttJ=[];
for i=1:length(x(:,1))
    rect=[x(i,1)-r,x(i,2)-r,2*r,2*r];
    im_ttI=[im_ttI,imcrop(I,rect)];
    im_ttJ=[im_ttJ,imcrop(J,rect)];
   rectangle('Position',rect,'linewidth',0.8,'EdgeColor','r')
end

im_dtI=[];im_dtJ=[];
for i=1:length(x1(:,1))
    rect=[x1(i,1)-r,x1(i,2)-r,2*r,2*r];
    im_dtI=[im_dtI,imcrop(I,rect)];
    im_dtJ=[im_dtJ,imcrop(J,rect)];
    rectangle('Position',rect,'linewidth',0.8,'EdgeColor','y')
end
patch_EPI= EPI(im_ttI,im_ttJ);
patch_ssim= ssim(im_dtI,im_dtJ);
out=[patch_EPI,patch_ssim];

function out=EPI(s1,s2)

 w=fspecial('laplacian',0);
 s1=double(imfilter(s1,w));%高通
 s2=double(imfilter(s2,w));%高通
 s1(s1<mean(s1(:)))=0;
 s2(s2<mean(s2(:)))=0;
[~,~,channel]=size(s1);
    if channel==1
       out=calEPI(s1,s2);
    else
        out=calEPI(rgb2gray(s1),rgb2gray(s2));
    end

function y=calEPI(Rs1,Rs2)

T=sum(sum(abs((Rs1-mean(Rs1(:))).*(Rs2-mean(Rs2(:))))));
T1=sum(sum((Rs1-mean(Rs1(:))).^2));
T2=sum(sum((Rs2-mean(Rs2(:))).^2));
y=T./(sqrt(T1.*T2)+0.001);
