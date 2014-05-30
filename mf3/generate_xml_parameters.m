% Generate XML with the MF3 parameters
addpath(strcat(pwd, '/fk'));
addpath(strcat(pwd, '/xml'));
kinematic_parameters;
q = zeros(1, 7);
xml_doc = com.mathworks.xml.XMLUtils.createDocument('GXML_Root');
xml_root = xml_doc.getDocumentElement;
xml_root.setAttribute('name','MF3');
% Add the kinematic parameters
kin_parameters = xml_doc.createElement('kinematic_parameters');
kin_parameters.setAttribute('mems', '3');
p =  eval_sym(p_t, q, d, a);
T0 = eval_sym(T0_t, q, d, a);
finger_field = finger_to_xml(k_t, p, T0, type, 0, 'Thumb', xml_doc);
kin_parameters.appendChild(finger_field);
p =  eval_sym(p_m, q, d, a);
T0 = eval_sym(T0_m, q, d, a);
finger_field = finger_to_xml(k_m, p, T0, type, 1, 'Middle', xml_doc);
kin_parameters.appendChild(finger_field);
p =  eval_sym(p_i, q, d, a);
T0 = eval_sym(T0_i, q, d, a);
finger_field = finger_to_xml(k_i, p, T0, type, 1, 'Index', xml_doc);
kin_parameters.appendChild(finger_field);
xml_root.appendChild(kin_parameters);
% Add dynamic parameters
dyn_parameters = xml_doc.createElement('dynamic_parameters');
dyn_parameters.setAttribute('mems', '3');
finger_field = xml_doc.createElement('Thumb');
finger_field.setAttribute('mems', '1');
finger_field.appendChild(matrix_to_xml([-104 -20 -14 -14 1 1 1], 'gear_ratios', xml_doc));
dyn_parameters.appendChild(finger_field);
xml_root.appendChild(kin_parameters);
finger_field = xml_doc.createElement('Middle');
finger_field.setAttribute('mems', '1');
finger_field.appendChild(matrix_to_xml([-104 -20 -14 -14 1 1 1], 'gear_ratios', xml_doc));
dyn_parameters.appendChild(finger_field);
finger_field = xml_doc.createElement('Index');
finger_field.setAttribute('mems', '1');
finger_field.appendChild(matrix_to_xml([-104 -14 -14 -14 1 1 1], 'gear_ratios', xml_doc));
dyn_parameters.appendChild(finger_field);
xml_root.appendChild(dyn_parameters);
% Add motor parameters
motor_parameters = xml_doc.createElement('motor_parameters');
motor_parameters.setAttribute('mems', '2');
motor_parameters.appendChild(matrix_to_xml(initial_angles, 'initial_angles', xml_doc));
motor_parameters.appendChild(matrix_to_xml([1 1 1 1 -1 -1 -1 -1 1 -1], 'directions', xml_doc));
xml_root.appendChild(motor_parameters);
% Add finger offsets
finger_offsets = xml_doc.createElement('finger_offsets');
finger_offsets.setAttribute('mems', '3');
finger_offsets.appendChild(matrix_to_xml(offset_t, 'Thumb', xml_doc));
finger_offsets.appendChild(matrix_to_xml(offset_m, 'Middle', xml_doc));
finger_offsets.appendChild(matrix_to_xml(offset_i, 'Index', xml_doc));
xml_root.appendChild(finger_offsets);
% Write everything
xmlwrite('mf3_parameters.xml', xml_doc);