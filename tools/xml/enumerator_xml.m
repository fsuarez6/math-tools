function [enumerator] = enumerator_xml(array, xml_doc)
f = length(array);

enumerator = xml_doc.createElement('types');
enumerator.setAttribute('dim',sprintf('[%i]',f));
enumerator.setAttribute('type','Enum U16');

for i=1:f
    value = xml_doc.createElement('joint_type');
    
    if array(i) == 0
        selected = 'Prismatic';
    elseif array(i) == 1
        selected = 'Revolute';
    end
    value.setAttribute('sel',selected);
    value.appendChild(xml_doc.createTextNode(sprintf('%i',not(array(i)))));
    enumerator.appendChild(value);
end