% tx and rx need to agree on a sync signal and a symbol period
SymbolPeriod = 100;
Fs = 8192;
load sync.mat;


Microphone = audioDeviceReader(Fs, 8192); %(samplerate, samplesperframe)
% it's not possible to ensure frames line up with symbol period, so need
% some robustness around merging frames
% the frame should be big enough to capture the sync pulse (at least 3x
% size)
SpecAnalyzer = dsp.SpectrumAnalyzer;
tic;
fprintf("F_s = %d, Frame Size: %d\n", Microphone.SampleRate, Microphone.SamplesPerFrame)
% 0: looking for start
% 1: getting data
state = 0;
offset = 0;
while (1)
    [audio, overflow] = step(Microphone);
    % generall in the first second or so samples are lost, good to start
    % running before transmission starts
    if (overflow ~= 0)
        warning("WARNING: Lost %d audio samples.", overflow)
    end
    
    if (state == 0)
        % attempt to find the start
        index = find_start_of_signal(audio,x_sync);
        if (index)
            disp(index)
        end
        % record offset
        
        % update state
    elseif (state == 1)
        % decode data
        
        % put decoded data into result buffer
        
        % put leftovers in buffer
    end
    % show on spectrum analyzer just because we can
    step(SpecAnalyzer,audio);
    
    % if some special end sequence is transmitted it should end
end