
l = 625000+(1:5e6);
L = length(l);

tmax = Tinterval*L;

fvector = ((linspace(1,L,L)-1)-L/2)*(1/tmax);

V = fftshift(fft(v(l)))/L;
I = fftshift(fft(i(l)))/L;

fcenter = f0(1);

Xlim = fcenter + [-10,10];
xline = fcenter + [-4,0,+4].';

figure(1)
set(gcf,'visible','off')
clf
% subplot(2,1,1)
% semilogy(fvector, abs(V))
% xlim(Xlim)

% subplot(2,1,2)
semilogy(fvector, abs(I))
xlim(Xlim)
ylim([1e-6, 1e2])


% get y bounds
y = ylim;

% line 1
x = xline*ones(1,2);

line(x(1,:), y, 'color', 'k', 'linestyle', '--');
line(x(2,:), y, 'color', 'k', 'linestyle', '--');
line(x(3,:), y, 'color', 'k', 'linestyle', '--');

shg