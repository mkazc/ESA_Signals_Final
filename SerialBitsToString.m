%This script takes as input a vector of 1s and 0s (numerical)
%and returns a string based on the ASCII representation of characters.

%The input vector binary needs to have length that is a multiple of 8

function res = SerialBitsToString(binary)
res = char(bin2dec(reshape(char(binary'+'0'), 8,[]).'))';
end
        
    