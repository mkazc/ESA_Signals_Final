function [H] = dtft(h, k, Omega) 
H = h*exp(-j*k'*Omega);
 
%H = DTFT values computed at Omega frequencies
%h = finite duration sequence over k (row vector)
%k = sample position row vector
%Omega = frequency row vector

end

