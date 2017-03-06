%No access to common variables outside of parfor loop
size=100*10^6;
tic
for i = 1:size
  A(i) = sin(i*2*pi/size);
end
toc

tic
parfor i = 1:size
  A(i) = sin(i*2*pi/size);
end
toc