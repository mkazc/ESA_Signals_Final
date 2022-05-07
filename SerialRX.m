function [] = SerialRX(Fs, f_c, SymbolPeriod, duration, characters)
load sync_noise.mat x_sync % get the sync signal
% record microphone
recObj = audiorecorder(Fs,8,1,-1);
recordblocking(recObj, duration);
y_r = getaudiodata(recObj);

%TODO: determine when transmission is over
% maybe send that byte first??
plot_ft_rad(y_r,Fs);
figure();
plot(y_r);

% find the sync signal and trim off the start
index = find_start_of_signal(y_r,x_sync);
y_r_crop = y_r(index+length(x_sync):end);

% cropped signal
plot_ft_rad(y_r_crop,Fs);
figure()
plot(y_r_crop)

% frequency shift
t = (0:length(y_r_crop)-1)';
cos_fc = cos(2*pi*f_c/Fs*t);
y_shifted = y_r_crop.*cos_fc;

plot_ft_rad(y_shifted,Fs);
figure()
plot(y_shifted)

% apply a lowpass filter
y_filtered = lowpass(y_shifted, 1/50);

plot_ft_rad(y_filtered,Fs);
figure()
plot(y_filtered)

% average across each symbol period
sz = floor(length(y_filtered)/SymbolPeriod)-1;
bits = zeros(sz, 1);
for i=1:sz
    chunk = (i-1)*SymbolPeriod;
    start = chunk + round(SymbolPeriod*.05);
    cend = chunk + round(SymbolPeriod*.95);
    bits(i) = mean(y_filtered(start:cend));
end
bits_raw = bits;
nbits = bits < 0;
bits = bits > 0;

% make to 8 bits divisible
bits_div = mod(length(bits),8)
bits = bits(1:end-bits_div);
nbits = nbits(1:end-bits_div);


% with serial we can expect gibberish at the end, but that's OK!
s = SerialBitsToString(bits)
s(1:characters)
sr = SerialBitsToString(nbits)
sr(1:characters)
end


