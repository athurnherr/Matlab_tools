%======================================================================
%                    V E C _ C O H E R E N C E . M 
%                    doc: Wed Aug  8 09:01:59 2012
%                    dlm: Wed Aug  8 10:19:53 2012
%                    (c) 2012 A.M. Thurnherr
%                    uE-Info: 58 27 NIL 0 0 72 10 2 4 NIL ofnI
%======================================================================

% calculate coherence between two 2-D vector time-series or profiles
%	- time or space is coded in 1st vector dimension
%	- code based on [ladcp_cohere.m] by X. Liang
%	- XL had hard-coded nsegs=4

function coh = vec_coherence(v1,v2,nsegs,conf)

valid = find(isfinite(v1(:,2)));
v1 = v1(find(isfinite(v1(:,2))),:);
v2 = v2(find(isfinite(v2(:,2))),:);

rez1 = median(diff(v1(:,1)));
rez2 = median(diff(v2(:,1)));

if (rez1 ~= rez2)
	error('incompatible vector resolutions');
end

first = max(min(v1(:,1)),min(v2(:,1)));
last  = min(max(v1(:,1)),max(v2(:,1)));

cv1 = v1(find(v1(:,1)>=first&v1(:,1)<=last),2) + sqrt(-1)*v1(find(v1(:,1)>=first&v1(:,1)<=last),3);
cv2 = v2(find(v2(:,1)>=first&v2(:,1)<=last),2) + sqrt(-1)*v2(find(v2(:,1)>=first&v2(:,1)<=last),3);

if (length(cv1) ~= length(cv2))
	error('incompatible vectors');
end
    
NFFT = floor(length(cv1)/nsegs) ;						% segment data
freq = -1/(2*rez1):1/((NFFT-1)*rez1):1/(2*rez1);		% spectral frequencies
coh.conf = conf;
coh.clim = sqrt(1-(1-conf)^(1/(nsegs-1)));				% Confidence limit (Data analysis methods in physical oceanography, p488)

s1 = fftshift(fft(cv1,NFFT));							% power spectra
s2 = fftshift(fft(cv2,NFFT));

s12 = conj(s1).*s2;  %Inner-cross spectrum				% cross spectra
s21 = fliplr(s1).*s2; %outer-cross spectrum
s11 = abs(s1).^2;
s22 = abs(s2).^2;
    
for i = 1:NFFT/nsegs									% frequency-average spectra
	as12(i) = mean(s12((i-1)*nsegs+1:i*nsegs));
	as21(i) = mean(s21((i-1)*nsegs+1:i*nsegs));
	as11(i) = mean(s11((i-1)*nsegs+1:i*nsegs));
	as22(i) = mean(s22((i-1)*nsegs+1:i*nsegs));
	coh.freq(i) = mean(freq((i-1)*nsegs+1:i*nsegs));
end
    
coh.period = 1 ./ coh.freq;
coh.mag   = sqrt(abs(as12).^2./(as11.*as22));
coh.phase = atan2(-imag(as12),real(as12))*(180/pi);
    
figure
subplot(211)
plot(coh.freq,coh.mag)
hold on
line([coh.freq(1) coh.freq(end)],[coh.clim coh.clim],'color','r')
xlim([coh.freq(1) coh.freq(end)])
xlabel('Frequency/Wavenumber [cycles/unit]')
ylabel('Inner Rotary Coherence')
grid on
text(coh.freq(fix(0.8*length(coh.freq))), coh.clim+0.05, sprintf('%d%%',100*coh.conf));
    
subplot(212)
plot(coh.freq,coh.phase)
xlim([coh.freq(1) coh.freq(end)])
ylim([-180 180])
xlabel('Frequency/Wavenumber [cycles/unit]')
ylabel('Phase angle [deg]')
grid on
    
