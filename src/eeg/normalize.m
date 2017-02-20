function normalize()

g = get(gcf,'userdata');
if g.normed
	disp('Denormalizing...'); 
else
    disp('Normalizing...');
end;
hmenu = findobj(gcf, 'Tag', 'Normalize_menu');
btn = findobj(gcf, 'Tag', 'Norm');
ax1 = findobj('tag','eegaxis','parent',gcf);
data = get(ax1,'UserData');
if isempty(g.datastd)
	g.datastd = std(data(:,1:min(1000,g.frames),[],2));
end;
if g.normed
	for i = 1:size(data,1)
		data(i,:,:) = data(i,:,:)*g.datastd(i);
		if ~isempty(g.data2)
			g.data2(i,:,:) = g.data2(i,:,:)*g.datastd(i);
		end;
	end;
	set(gcbo,'string', 'Norm');
	set( findobj('tag','ESpacing','parent',gcbf),'string',num2str(g.oldspacing) );
else
	for i = 1:size(data,1)
	data(i,:,:) = data(i,:,:)/g.datastd(i);
	if ~isempty(g.data2)
		g.data2(i,:,:) = g.data2(i,:,:)/g.datastd(i);
	end;
end;
set(btn,'string', 'Denorm');
g.oldspacing = g.spacing;
set(findobj('tag','ESpacing','parent',gcbf),'string','5');
end;
g.normed = 1 - g.normed;
eegplot('draws',0);
set(hmenu, 'Label', fastif(g.normed,'Denormalize channels','Normalize channels'));
set(gcf,'userdata',g);
set(ax1,'UserData',data);
clear ax1 g data;
eegplot('drawp',0);
disp('Done.');

end

