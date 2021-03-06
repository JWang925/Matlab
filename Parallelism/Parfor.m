%No access to common variables outside of parfor loop
clear all
%%Tested in R2015b, the speed improvement when having 4 works is about 1.8x
size=50*10^6;
A=zeros(size,1);

% % 5.18 sec.
% tic
% for i = 1:size
%   A(i) = sin(i*2*pi/size);
% end
% toc
% % 
% % 2.9 sec
% A=zeros(size,1);
% tic
% parfor i = 1:size
%   A(i) = sin(i*2*pi/size);
% end
% toc

% %GPU Memory usage=822-59=763m , time cost = 0.77sec
% tic
% garray=gpuArray(1:size); 
% garray=sin(garray*2*pi/size);  
% A=gather(garray);
% toc


% Study of why the memory usage is 763m instead of ~400m
% Conclusion: matlab CUDA has a weird memory management system; wait(d)
% would release some memory when the memory usage is on the high side.

% %GPU Memory usage=440-59=381m, time = 0.32s so garray is same size of A
% tic
% garray=gpuArray(1:size);
% toc

% % GPU Memory usage=440-59=381m, time = 0.51s so gather does not change
% % memory allocation
% tic
% garray=gpuArray(1:size);
% A=gather(garray);
% toc

% %GPU Memory usage=631-59=572m, time = 0.51s, so the sin operation adds 190m
% %to memory?!
% tic
% garray=gpuArray(single(1:size)); 
% garray=sin(garray*2*pi/size);  
% A=gather(garray);
% toc

% %GPU Memory usage=440-59=381m, time = 0.45s, so the "sin" adds 190m
% %to memory?!
% tic
% garray=gpuArray(single(1:size)); 
% garray=garray+garray;  
% A=gather(garray);
% toc

% %GPU Memory usage=440-59=381m, time = 0.5s, so it is not sin()..
% tic
% garray=gpuArray(single(1:size)); 
% garray=sin(garray);  
% A=gather(garray);
% toc

% %GPU Memory usage=631-59=572m, time = 0.52s: ahh so it is the operation
% %inside of sin...
% tic
% garray=gpuArray(single(1:size)); 
% garray=sin(garray*2);  
% A=gather(garray);
% toc

% %GPU Memory usage=631-59=381m, time = 0.53s: ahh so it is garray*2..
% tic
% garray=gpuArray(single(1:size)); 
% garray=garray*2;
% garray=sin(garray);  
% A=gather(garray);
% toc

% %GPU Memory usage=631-59=381m, time = 0.53s: matlab gpuArray use
% %array.*array as example, let me try... Same result!
% tic
% garray=gpuArray(single(1:size)); 
% garray=garray.*garray;
% garray=sin(garray);  
% A=gather(garray);
% toc

% %GPU Memory usage=631-59=381m, time = 0.53s: let me try to clear some
% %memory.. ok everything on the GPU memory is cleaned; GPU memory is all
% %free.
% tic
% garray=gpuArray(single(1:size)); 
% garray=garray.*garray;
% garray=sin(garray);  
% A=gather(garray);
% clear garray;
% toc

% %GPU Memory usage=440-59=381m, time = 0.53s: so copying array changes
% %nothing..
% tic
% garray=gpuArray(single(1:size)); 
% garray2=garray;
% garray3=sin(garray);  
% A=gather(garray);
% toc

%GPU Memory usage=822-59=763m, time = 0.55s:
% tic
% for(i=0:5)
% d=gpuDevice();
% garray=gpuArray(1:size); 
% garray=garray * 2;
% wait(d);
% d.FreeMemory
% end
% toc


% Extra tests


% %GPU Memory usage=1203-59=1144m!
% tic
% garray=gpuArray(1:size);
% garray=sin(garray*2*pi/size);
% toc

% %GPU Memory usage=1203-59=1144m! Same time as last case~0.4sec
% tic
% garray=gpuArray(1:size);
% garray2=sin(garray*2*pi/size);
% toc

% %GPU Memory usage=488-59=429m; time = 0.330 
% tic
% gpuArray(1:size);
% toc

% % GPU usage = 440-59= 381m; time = 0.321
% tic
% garray=gpuArray(1:size);
% toc

% % GPU usage = 440-59= 381m; time = 0.512
% tic
% garray=gpuArray(1:size);
% A=gather(garray);
% toc

% GPU usage = 1203-59= 1144m; time = 0.684
% tic
% garray=gpuArray(1:size);
% garray2=sin(garray*2*pi/size);
% A=gather(garray2);
% toc

% % GPU usage = 822 -59= 822m; time = 0.7
% tic
% garray=gpuArray(1:size);
% garray=sin(garray*2*pi/size);
% A=gather(garray);
% toc






