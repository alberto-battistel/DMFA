function [t,v0,i0,z,fcorr,Vp] = timevariant_EIS_v7(A,B,Dt,DT,CA_range,f,filter,bw,n,cal)

% This function extracts the dynamic impedance spectra from a
% multi-frequency input. It uses a mirroring of the data in order to
% analyze aperiodic signals. Typically, due to the mirroring of the data,
% the results obtained up to a distance equal to 1.5/bw from the time
% boundaries should be discarded.
% A and B are two vertical arrays of the same length representing the data
% (typically voltage and current). A should be the perturbation.
% Dt is the time step between points in the arrays A and B.
% DT is the time step in the output data. In this way it is possible to
% extract a smaller amount of data, which is often more significative than
% extracting the whole impedance data set. It is better when DT is a
% multiple of Dt.
% CA_range is the current range of the potentiostat, in A/V. It converts
% the array B in current.
% f is a vertical array of the frequencies contained in the multi-frequency
% perturbation.
% filter is the name of the function used as filter. The filters "RectVarf"
% and "SincVarf" are the suggested ones.
% bw is the bandwidth of the filter. To be chosen based on the perturbed
% frequencies.
% n is a parameter decribing the shape of the filter.
% cal is the calibration file. The standard value "cal_0" does not affect
% the impedance.

% Calculate the voltage and current vectors
load(cal);
vaux = zeros(2*length(A),1,'single');
iaux = zeros(2*length(B),1,'single');
vaux(1:length(A),1) = A;
vaux(length(A)+1:2*length(A),1) = flip(A);
iaux(1:length(B),1) = B*CA_range;
iaux(length(B)+1:2*length(B),1) = flip(B)*CA_range;
Cal(end+1,1) = 1./CA_range;

% Calculate the number of points

Nt = length(A);
Ni = round(DT/Dt);
Np = ceil(Nt/Ni);

% Check for mistakes in the choice of the parameters

if Nt ~= length(B)
    disp('wrong data set')
    return
end
if Ni < 1
    disp('time sampling too short')
    return
end
if mod(Nt,2) ~= 0
    disp('wrong number of samples')
    return
end
if mod(Np,2) ~= 0
    disp('wrong time sampling')
    return
end

% Create the time domain and the matrix of impedances

t = single(DT)*(0:1:Np-1);
zm = zeros(length(f),Np,'single');
z = zeros(length(f),Np,'single');

% Generate the frequency axis and points

fraux = (1/Dt)*linspace(-0.5,0.5-0.5/Nt,Nt*2)';
fraux1 = (1/DT)*linspace(-0.5,0.5-0.5/Np,Np*2)';
fpt0 = ceil(Nt/2)+1;

% Create the filter function

fil = str2func(filter);

% analyze the data sets A and B for the 0 frequency response

Vaux = fftshift(fft(vaux))/(2*Nt);
Iaux = fftshift(fft(iaux))/(2*Nt);
range = 2*fpt0-Np-1:2*fpt0+Np-2;
v0l = (ifft(ifftshift(Vaux(range).*fil(fraux(range),0,bw,n)),'symmetric').')*2*Np;
i0l = (ifft(ifftshift(Iaux(range).*fil(fraux(range),0,bw,n)),'symmetric').')*2*Np;
v0 = v0l(1,1:Np);
i0 = i0l(1,1:Np);

% find the correct frequencies of the perturbation by using the data set A
    
v = vaux - (ifft(ifftshift(Vaux.*fil(fraux,0,bw,n)),'symmetric'))*2*Nt;
v(length(A)+1:2*length(A),:) = [];
V = fftshift(fft(v))/Nt;
i = iaux - (ifft(ifftshift(Iaux.*fil(fraux,0,bw,n)),'symmetric'))*2*Nt;
i(length(B)+1:2*length(B),:) = [];
I = fftshift(fft(i))/Nt;

fpt = round(f*Nt*Dt);
df(1,1) = min(f(1),f(2)-f(1));
for k = 2:length(f)-1
    df(k,1) = min(f(k)-f(k-1),f(k+1)-f(k));
end
df(length(f),1) = f(end)-f(end-1);
dfpt = floor(df*Nt*Dt/2);
fcorr = zeros(length(f),1,'single');
fptc = zeros(length(f),1);

% separate the frequency responses and calculate the impedance

for kk = 1:length(f)
    rangef = fpt0+fpt(kk,1)-dfpt(kk,1):fpt0+fpt(kk,1)+dfpt(kk,1)-1;
    [~,fptc(kk,1)] = max(abs(V(rangef)));
    fptc(kk,1) = fpt(kk,1)-dfpt(kk,1)-1+fptc(kk,1);
    fcorr(kk,1) = fptc(kk,1)/(Nt*Dt);
    range = fpt0+fptc(kk,1)-Np/2:fpt0+fptc(kk,1)+Np/2-1;
    v1 = (ifft(ifftshift(V(range))))*Np;
    v1(Np+1:2*Np,1) = flip(v1(1:Np,1));
    v1 = (ifft(ifftshift(fftshift(fft(v1)).*fil(fraux1,0,bw,n))));
    i1 = (ifft(ifftshift(I(range))))*Np;
    i1(Np+1:2*Np,1) = flip(i1(1:Np,1));
    i1 = (ifft(ifftshift(fftshift(fft(i1)).*fil(fraux1,0,bw,n))));
    zm(kk,:) = (v1(1:Np,1)./i1(1:Np,1)).';
    Vp(kk,1) = V(fpt0+fptc(kk,1));
end

if isempty(zm)
    z = [];
else
    for mm = 1:size(zm,2)
        z(:,mm) = PotCorr(zm(:,mm),Cal,f);
    end
end

end