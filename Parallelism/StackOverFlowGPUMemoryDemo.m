clear all
d = gpuDevice;
A = gpuArray.rand(1e4);
freeMem = NaN(1, 11);
freeMem(1) = d.FreeMemory;
for idx = 2:11
    A = A * 2;
    wait(d);
    freeMem(idx) = d.FreeMemory;
end
plot(1:11, freeMem / 1e9, 'b-', ...
     [1 11], [d.TotalMemory, d.TotalMemory]/1e9, 'r-');
legend({'Free Memory', 'Total Memory'});
xlabel('Iteration');
ylabel('Memory (GB)');