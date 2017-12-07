clear
clc
close all

%% Simulacao de estimadores da conectividade cerebral
% Autor: Gustavo Silveira, 2017
% Algoritmo tomado como base: Amir Omidvarnia, 2013

%% Modelo MVAR invariante no tempo
Fs = 100; % Frequencia de amostragem
Fmax = Fs/2; % Frequencia de corte, deve ser menor que Fs/2
Nf = 40; % Numero de bins de frequencia para calcular a PDC

y = zeros(20000,2); %Sinal
L = size(y,1); % Numero de amostras
CH = size(y,2); % Numero de canais

%Gerando ruidos brancos de m�dia zero
% w1 = randn(2000,1);
% w2 = randn(2000,1);
%w3 = randn(2000,1);
%y(:,1) = w1;
%y(:,2) = w2;
%y(:,3) = w3;

%1 influencia 2
% for n=1:L
%     y(n,1) = 0.5*w1(n)+10*sin(2*pi*10*n);
%     y(n,2) = 0.5*w2(n)-10*sin(2*pi*10*n);
% end
fs=100;
ts=1/fs;
k=10;
T = ts*(0:1:19999);
w1 = randn(length(T),1);
w2 = randn(length(T),1);
s1 = sin(2*pi*10*T)';
s2 = sin(2*pi*10*T)';
y(:,1)= w1+s1*k*2;
y(:,2)= w2+s2*k;


% 1 influencia 2, 2 influencia 3
% for n = 4 : L
%     y(n,1) = y(n,1) + 0.5*y(n-1,1);
%     y(n,2) = y(n,2) + 0.7*y(n-2,1);
%     y(n,3) = y(n,3) -0.8*y(n-3,2);
% end

% 2 influencia 1 que influencia 3
% for n = 4 : L
%     y(n,1) = y(n,1) + 0.9*y(n-1,2);
%     y(n,2) = y(n,2) + 0.9*y(n-2,2);
%     y(n,3) = y(n,3) - 0.8*y(n-3,1);
% end

% % 1 influencia 2 que influencia 3 que influencia 1
% for n = 4 : L
%     y(n,1) = y(n,1) + 0.6*y(n-2,3);
%     y(n,2) = y(n,2) - 0.8*y(n-1,1);
%     y(n,3) = y(n,3) + 0.7*y(n-3,2);
% end

% 1 influencia 2 e 3
% for n = 4 : L
%     y(n,1) = y(n,1) + 0.4*y(n-1,1);
%     y(n,2) = y(n,2) + 0.9*y(n-3,1);
%     y(n,3) = y(n,3) + 0.9*y(n-2,1);
% end

%% Time-invariant MVAR parameter estimation
[w, A, C, sbc, fpe, th] = arfit(y, 1, 20, 'sbc'); % ---> ARFIT toolbox
[tmp,p_opt] = min(sbc); % Optimum order for the MVAR model

%% Connectivity measures (PDC, DTF etc)
[PDC,DTF] = PDC_DTF_matrix(A,p_opt,Fs,Fmax,Nf);

%% Plot
figure('Name','Partial Directed Coherence (PDC)','NumberTitle','off');% ---> PDC
s1 = 0;
clear mask
PDC = abs(PDC);

x_min = 2;
x_max = 30;
y_max = 1;

for i = 1 : CH
    for j = 1 : CH
        s1 = s1 + 1;
        h = subplot(CH,CH,s1); 
        set(h,'FontSize',20,'FontWeight','bold');
        
        PDC_tmp = squeeze(PDC(i,j,:,:));        
%         if(i==j)
%             PDC_tmp = zeros(1,size(PDC,3));
%         end
        area(linspace(0,Fmax,Nf),PDC_tmp,'FaceColor',[0 0 0])
        axis([x_min x_max 0 y_max])
        if(i<CH && j>1)
            set(h,'YTick',zeros(1,0),'XTick',zeros(1,0));
        elseif(i<CH && j==1)
            set(h,'YTick',[0 y_max],'XTick',zeros(1,0));
        elseif(i==CH && j>1)
            set(h,'YTick',zeros(1,0),'XTick',[x_min x_max]);
        elseif(i==CH && j==1)
            set(h,'YTick',[0 y_max],'XTick',[x_min x_max]);
        end
        if(i==CH && j==ceil(CH/2))
            xlabel('Frequency (Hz)','Fontsize',20,'FontWeight','bold')
        end
        if(i==1 && j==1)
            title('CH1')
            ylabel('CH1')
        elseif(i==1 && j==2)
            title('CH2')
        elseif(i==1 && j==3)
            title('CH3')
        elseif(i==2 && j==1)
            ylabel('CH2')
        elseif(i==3 && j==1)
            ylabel('CH3')
        end
    end
end

%%%%
figure('Name','Directed Transfer Function (DTF)','NumberTitle','off'); % ---> DTF
s1 = 0;
clear mask
DTF = abs(DTF);

for i = 1 : CH
    for j = 1 : CH
        s1 = s1 + 1;
        h = subplot(CH,CH,s1); 
        set(h,'FontSize',20,'FontWeight','bold');
        
        DTF_tmp = squeeze(DTF(i,j,:,:));        
%         if(i==j)
%             DTF_tmp = zeros(1,size(DTF,3));
%         end
        area(linspace(0,Fmax,Nf),DTF_tmp,'FaceColor',[0 0 0])
        axis([x_min x_max 0 y_max])
        if(i<CH && j>1)
            set(h,'YTick',zeros(1,0),'XTick',zeros(1,0));
        elseif(i<CH && j==1)
            set(h,'YTick',[0 y_max],'XTick',zeros(1,0));
        elseif(i==CH && j>1)
            set(h,'YTick',zeros(1,0),'XTick',[x_min x_max]);
        elseif(i==CH && j==1)
            set(h,'YTick',[0 y_max],'XTick',[x_min x_max]);
        end
        if(i==CH && j==ceil(CH/2))
            xlabel('Frequency (Hz)','Fontsize',20,'FontWeight','bold')
        end
        if(i==1 && j==1)
            title('CH1')
            ylabel('CH1')
        elseif(i==1 && j==2)
            title('CH2')
        elseif(i==1 && j==3)
            title('CH3')
        elseif(i==2 && j==1)
            ylabel('CH2')
        elseif(i==3 && j==1)
            ylabel('CH3')
        end
    end
end