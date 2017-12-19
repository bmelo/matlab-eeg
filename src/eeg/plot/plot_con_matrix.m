function plot_con_matrix( signal, labels )
%PLOT_CON_MATRIX Summary of this function goes here
%   Detailed explanation goes here

%% Plot
s1 = 0;
signal = abs(signal);

x_min = 2;
x_max = 30;
y_max = 1;
Fmax = 50;
Nf = 40;

nChs = size(signal, 1);
nChs = 10;
for i = 1 : nChs
    for j = 1 : nChs
        s1 = s1 + 1;
        h = subplot(nChs,nChs,s1); 
        set(h,'FontSize',20,'FontWeight','bold');
        
        signal_tmp = squeeze(signal(i,j,:,:));        
%         if(i==j)
%             PDC_tmp = zeros(1,size(PDC,3));
%         end
        area(linspace(0,Fmax,Nf),signal_tmp,'FaceColor',[0 0 0])
        axis([x_min x_max 0 y_max])
        if(i<nChs && j>1)
            set(h,'YTick',zeros(1,0),'XTick',zeros(1,0));
        elseif(i<nChs && j==1)
            set(h,'YTick',[0 y_max],'XTick',zeros(1,0));
        elseif(i==nChs && j>1)
            set(h,'YTick',zeros(1,0),'XTick',[x_min x_max]);
        elseif(i==nChs && j==1)
            set(h,'YTick',[0 y_max],'XTick',[x_min x_max]);
        end
        if(i==nChs && j==ceil(nChs/2))
            xlabel('Frequency (Hz)','Fontsize',20,'FontWeight','bold')
        end
        
        title(sprintf('CH%d',j));
        ylabel(sprintf('CH%d',i));
    end
end


end

