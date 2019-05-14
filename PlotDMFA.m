
fig = 1;
obj = Para;

%%
Fig = figure(fig);
clf
subplot(3,1,1)
plot(obj.v0, obj.i0)
xlabel('V / V')
ylabel('j / A m^{-2}')


%% Plot Re and Im vs time 

color = jet(length(obj.f0));

subplot(3,1,2)  % Re vs time
hold on
for k = 1:length(obj.f0) 
    plot(obj.t0, real(obj.z(k,:)),'color', color(k,:))
end
hold off

xlabel('t / s')
ylabel('Re(Z) / \Omega m^2')
set(gca,'Yscale', 'log')

subplot(3,1,3)  % -Im vs time
hold on
for k = 1:length(obj.f0) 
    plot(obj.t0, -imag(obj.z(k,:)),'color', color(k,:))
end
hold off
xlabel('t / s')
ylabel('-Im(Z) / \Omega m^2')
set(gca,'Yscale', 'log')

Fullscreen
pause(0.5)
%% Save
% Proposed filename
if isempty(who('filename'))
    filename = '?';
else
    filename =  strrep(filename, '.mat', '.fig');
end


% Ask
prompt = {'Do you want to save?','filename:'};
dlg_title = 'Input';
num_lines = [1 50];
def = {'yes',filename};
answer = inputdlg(prompt,dlg_title,num_lines,def);

% Save
if ~isempty(answer)
    if strcmp(answer{1,1},'yes') 
        saveas(Fig, answer{2,1}, 'fig')
        fprintf('Save\n\t%s\n', answer{2,1})
    else
        fprintf('No save\n')
    end
end
