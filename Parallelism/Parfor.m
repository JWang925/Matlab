%No access to common variables outside of parfor loop

%%Tested in R2015b, the speed improvement when having 4 works is 2.89sec
%%compared to 5.18 sec.
size=50*10^6;
A=zeros(size,1);
tic
for i = 1:size
  A(i) = sin(i*2*pi/size);
end
toc

A=zeros(size,1);
tic
parfor i = 1:size
  A(i) = sin(i*2*pi/size);
end
toc

%GPU Memory usage=1.3G , time cost = 0.77sec
tic
input=gpuArray(1:size);
A_gpu=sin(input*2*pi/size); 
A=gather(A_gpu);
toc