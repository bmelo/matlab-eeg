function [varargout] = spectral_density( y, srate, limits, label )

if nargin < 4, label = ''; end

if ( ~exist('limits', 'var') || isempty(limits) )
    limits = [8 10; 10 13; 13 20; 20 26; 26 30; 30 45];
end

% demeaning
y = y - mean(y);

%%pxx = pwelch( y, 4 );
warning('OFF', 'eeglab:toolbox:absent');
[Pxx, f] = pwelch(y, srate, [], [], srate);
warning('ON', 'eeglab:toolbox:absent');

%Ajustando valores
Pxx = 10*log10(Pxx);
if( min(Pxx) < 0 ) %Deslocando valores para que todos fiquem acima de zero
    Pxx = Pxx + abs( min(Pxx) );
end
[faixas, labels] = faixasEspectro( Pxx, f, limits );
%[Pxx, f] = limitEspectro(Pxx, f, limits);

if( nargout > 0 )
    varargout = {faixas, labels};
    %varargout = {Pxx, f};
else %plot
    figure;
    plot(f, Pxx);
    title(['Power spectral density - ' label]);
    xlabel('Frequency (Hz)');
end

%{

N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;

plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency')
%}

end

function [Pxx, f] = limitEspectro( Pxx, f, limits )

bottom = limits(1, 1);
top = limits(end, 2);
idxs = ( f > bottom & f <= top );
Pxx = Pxx(idxs);
f = f(idxs);

end

function [faixas, labels] = faixasEspectro( Pxx, f, limits )

for k=1:size(limits,1)
    bottom = limits(k, 1);
    top = limits(k, 2);
    idxs = ( f > bottom & f <= top );
    faixas(k) = mean( Pxx(idxs) );
    labels{k} = sprintf('%d-%d', bottom, top);
end

end