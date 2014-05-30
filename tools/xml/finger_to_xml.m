function [finger_field] = finger_to_xml(k, p, T0, type, side, finger_name, xml_doc)

finger_field = xml_doc.createElement(finger_name);
finger_field.setAttribute('mems', '3');
finger_field.appendChild(matrix_to_xml(k, 'k', xml_doc));
finger_field.appendChild(matrix_to_xml(p, 'p', xml_doc));
finger_field.appendChild(matrix_to_xml(T0, 'T0', xml_doc));
finger_field.appendChild(enumerator_xml(type, xml_doc));
enumerator = xml_doc.createElement('side');
if side == 0
    selected = 'Left';
elseif side == 1
    selected = 'Right';
end
enumerator.setAttribute('sel',selected);
enumerator.setAttribute('type','Enum U16');
enumerator.appendChild(xml_doc.createTextNode(sprintf('%i',side)));
finger_field.appendChild(enumerator);