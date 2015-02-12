% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);


% Generate XML with the GripsSlave parameters
clc;
kinematic_parameters;
q = zeros(1, 6);
xml_doc = com.mathworks.xml.XMLUtils.createDocument('GXML_Root');
xml_root = xml_doc.getDocumentElement;
xml_root.setAttribute('name','GripsSlave');
% Add the kinematic parameters
kin_parameters = xml_doc.createElement('kinematic_parameters');
kin_parameters.setAttribute('mems', '3');
p =  eval_sym(p, q, d, a);
T0 = eval_sym(T0, q, d, a);
kin_parameters.appendChild(matrix_to_xml(k, 'k', xml_doc));
kin_parameters.appendChild(matrix_to_xml(p, 'p', xml_doc));
kin_parameters.appendChild(matrix_to_xml(T0, 'T0', xml_doc));
kin_parameters.appendChild(enumerator_xml(type, xml_doc));
% Add joint limits
limits = xml_doc.createElement('joint_limits');
limits.setAttribute('mems', '3');
has_limits = true(1,6);
has_limits(6) = false;
limits.appendChild(matrix_to_xml(has_limits, 'has_limits', xml_doc));
pos_limits = [
-pi/2 pi/2;
-pi/2 pi/6;
2.617993878 5.672320069;
-1.1 0.581;
-1.01 0.675;
-2*pi 2*pi];
vel_limits = [
80*pi/180;
65*pi/180;
50*pi/180;
100*pi/180;
115*pi/180;
200*pi/180];
limits.appendChild(matrix_to_xml(pos_limits(:,1), 'min_position', xml_doc));
limits.appendChild(matrix_to_xml(pos_limits(:,2), 'max_position', xml_doc));
limits.appendChild(matrix_to_xml(vel_limits, 'velocity', xml_doc));
kin_parameters.appendChild(limits);
xml_root.appendChild(kin_parameters);
% Hardware Interface
hw_interface = xml_doc.createElement('hw_interface');
hw_interface.setAttribute('mems', '3');
names = xml_doc.createElement('names');
names.setAttribute('mems', '4');
base = {'SA','SE','EL','WP','WY','WR','GRIP'};
AO = base;
AI = cell(1,12);
c = 1;
for i = 1:7
    AI{i} = [base{i} '_POS'];
    AI{i+7} = [base{i} '_FORCE'];
    AO{i} = [base{i} '_CMD'];
end
AI([7,13])=[];
DO = {'HYD'};
DI = {};
names.appendChild(cell_to_xml(AI, 'AI', xml_doc));
names.appendChild(cell_to_xml(AO, 'AO', xml_doc));
names.appendChild(cell_to_xml(DI, 'DI', xml_doc));
names.appendChild(cell_to_xml(DO, 'DO', xml_doc));
hw_interface.appendChild(names);
% Interpolation coefficientes
coeff = [
0 -0.2963766654;                % SA_POS
-0.5339964818 0.2970773195;     % SE_POS
2.4055932068 -0.3436355516;     % EL_POS
0.3226073641 -0.2841595824;     % WP_POS
-0.1023368224  0.2835425468;    % WY_POS
0 -0.3141592654;                % WR_POS
0 1;                            % SA_FORCE
0 1;                            % SE_FORCE
0 1;                            % EL_FORCE
0 1;                            % WP_FORCE
0 1;                            % WY_FORCE
0 1];                           % GRIP_FORCE
hw_interface.appendChild(matrix_to_xml(coeff, 'interpolation_coeff', xml_doc));
xml_root.appendChild(hw_interface);
% Add joint mapping
joint_mapping = xml_doc.createElement('joint_mapping');
joint_mapping.setAttribute('mems', '4');
joint_mapping.appendChild(cell_to_xml(base, 'name', xml_doc));
position = AI(1:6);
position{end+1} = 'NONE';
joint_mapping.appendChild(cell_to_xml(position, 'position', xml_doc));
joint_mapping.appendChild(cell_to_xml({}, 'velocity', xml_doc));
effort = AI(7:11);
effort{end+1} = 'NONE';
effort{end+1} = AI(12);
joint_mapping.appendChild(cell_to_xml(effort, 'effort', xml_doc));
joint_mapping.appendChild(cell_to_xml(AO, 'command', xml_doc));
xml_root.appendChild(joint_mapping);
% Write everything
file_path = '/home/fsuarez6/VirtualBox VMs/share_folder/GripsSlaveConfiguration.xml';
tmp_file = 'input.xml';
xmlwrite(tmp_file, xml_doc);
% Hack to fix empty elements
fin = fopen(tmp_file);
fout = fopen(file_path, 'w+');
while ~feof(fin)
   s = fgetl(fin);
   s = strrep(s, '<item/>', '<item></item>');
   fprintf(fout,'%s\n',s);
end
fclose(fin);
fclose(fout);
delete(tmp_file);
