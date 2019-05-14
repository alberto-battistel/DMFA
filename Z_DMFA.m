%% calculate dynamic Z
% DMFA = struct;

% filename = 'Redox_MultiACL07_3dec_quasiCV2_10mV';
Para.DT = Tinterval*5e6/2000; 

Para.bw = f0(1)/2;
Para.n = 8;
Para.filShape = 'RectVarf';
Para.mirroring = false;
Para.CorrectedLength = 5e6;
Para.data2cut = 625000;

l = Para.data2cut + (1:Para.CorrectedLength);
[t,v0,i0,z,fcorr,Vp] = timevariant_EIS_v7_beta(v(l), i(l), ...
    Tinterval, Para.DT, 1, f0, Para.filShape, Para.bw, Para.n, 'cal_0', Para.mirroring);

Para.t0 = t;
Para.v0 = v0;
Para.i0 = i0;
Para.z = z;
Para.f0 = f0;

%% Save
% Proposed filename

filename = [Para.filShape, '-'];     
filename = [filename, sprintf('%.1fHz-', Para.bw)];
filename = [filename, sprintf('%dn', Para.n)];
filename =  strrep(filename, '.', '_');

if Para.mirroring == true
    filename = [filename, '_mirr'];
end
filename = [filename, '.mat'];

% Ask
prompt = {'Do you want to save?','filename:'};
dlg_title = 'Input';
num_lines = [1 50];
def = {'yes',filename};
answer = inputdlg(prompt,dlg_title,num_lines,def);

% Save
if ~isempty(answer)
    if strcmp(answer{1,1},'yes') 
        save(answer{2,1}, 'Para')
        fprintf('Save\n\t%s\n', answer{2,1})
    else
        fprintf('No save\n')
    end
end

