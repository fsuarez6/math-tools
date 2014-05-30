function [cell_field] = cell_to_xml(str_cell, name, xml_doc)
n = length(str_cell);
cell_field = xml_doc.createElement(name);
cell_field.setAttribute('dim',sprintf('[%i]',n));
cell_field.setAttribute('type','String');

for i=1:n
    value = xml_doc.createElement('item');
    value.appendChild(xml_doc.createTextNode(str_cell{i}));
    cell_field.appendChild(value);
end

if n == 0
    value = xml_doc.createElement('item');
    cell_field.appendChild(value);
end