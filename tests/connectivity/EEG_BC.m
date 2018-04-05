%% Segment the EEG epochs and compute the DTF and PDC for all the channels
% The resulting matrixes are epochs x ch x ch x frequencybins
% Author: Gustavo Silveira
% Last revision: 05/2017

function [PDC, DTF] = EEG_BC(EEGSignal,ForE)

fs = 600; %sampling frequency
load(EEGSignal); %load the signal
EEGSignal = IMvol1; % Alexsandro
%EEGSignal = Sinal'; %Ernesto

Acel = EEGSignal(26,:); %Acelerometer (Alexsandro)
%Acel = EEGSignal(20,:); %Acelerometer (Ernesto)
[flex,ext] = findTrigger(Acel,fs); %find the samples with trigger from the acelerometer
if ForE == 'f'
    vecTriger1 = flex;
else
    vecTriger1 = ext;
end

timeBefore = 0; %beginning of the epoch (seconds)
timeAfter = 3; %end of the epoch (seconds)
EEG_epochs = zeros(length(vecTriger1),20,(timeAfter - timeBefore)*fs); %prealocating for speed
% Segmentation of the EEG in epochs based on the triger
for ii = 1:length(vecTriger1)
    EEG_epochs(ii,1:20,:) = EEGSignal(1:20,vecTriger1(ii)-(timeBefore*fs):vecTriger1(ii)+(timeAfter*fs)-1);
end
PDC = zeros(length(vecTriger1),20,20,100); %prealocating for speed
DTF = zeros(length(vecTriger1),20,20,100); %prealocating for speed
%Estimate the model coefficients and the PDC and DTF for each epoch
for jj = 1:length(vecTriger1)
    aux = EEG_epochs(jj,:,:);
    y = squeeze(aux)';
    [~, A, ~, sbc, ~, ~] = arfit(y, 1, 20, 'sbc'); % ---> ARFIT toolbox
    [~,p_opt] = min(sbc);
    %[auxPDC, auxDTF] = PDC_DTF_matrix(A,p_opt,fs,100,100);
    [auxPDC, auxDTF] = PDC_DTF(A,p_opt,fs,100,100);
    PDC(jj,:,:,:) = auxPDC;
    DTF(jj,:,:,:) = auxDTF;
end