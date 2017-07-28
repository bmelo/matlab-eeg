function [out] = spectral_density( signal, srate, window, overlap, limits )
% SPECTRAL_DENSITY

warning('OFF', 'eeglab:toolbox:absent');
[Pxx, ~] = pwelch(signal, window, overlap, [], srate);
warning('ON', 'eeglab:toolbox:absent');

out = mean( Pxx(limits(1):limits(2)) );

end

%% ANOTHER APPROACH
function byEEGLAB(signal, srate)

N = length(signal);
xdft = fft(signal);
xdft = xdft(1:N/2+1);
psdx = (1/(srate*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:srate/length(signal):srate/2;

plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency')

end