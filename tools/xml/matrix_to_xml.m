function [array_field] = matrix_to_xml(real_matrix, name, xml_doc)
[f, c] = size(real_matrix);

array_field = xml_doc.createElement(name);
if f > 1 && c > 1
	array_field.setAttribute('dim',sprintf('[%i,%i]',f,c));
else
	array_field.setAttribute('dim',sprintf('[%i]',length(real_matrix)));
end

switch class(real_matrix)
    case 'double'
        type_str = 'SGL';
        format_str = '%f';
    
    case 'logical'
        type_str = 'Bool';
        format_str = '%s';
end
array_field.setAttribute('type',type_str);

for i=1:f
    for j=1:c
        value = xml_doc.createElement('item');
        if strcmp(type_str, 'Bool')
            if real_matrix(i,j)
                text = 'TRUE';
            else
                text = 'FALSE';
            end
            value.appendChild(xml_doc.createTextNode(sprintf(format_str,text)));
        else
            value.appendChild(xml_doc.createTextNode(sprintf(format_str,real_matrix(i,j))));
        end
        array_field.appendChild(value);
    end
end