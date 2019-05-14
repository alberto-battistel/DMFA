function y = SincVarf(fr,fc,bw,n)
    X = (fr-fc)/bw + 1e-12;
    y = (sin(pi*X)./(pi*X)).*exp(-((X/(sqrt(2)*n)).^2));
%   n should be lower or equal to Ns/(20*bw), were Ns are the number of samples taken per second.
%   One has to consider the reduction of samples. The lower is n, the more
%   windowed is the function in the time domain. The window is Gaussian.
%   With n equal to 4, the shape is sufficiently round, that low influence
%   from noise should be present.
end