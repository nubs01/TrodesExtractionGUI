function out = RN_readTimeStamp(ts)
% ts is time in seconds
SS = fix(mod(ts,60));
MM = fix(ts/60);
HH = 0;
while MM>=60
    HH = HH+1;
    MM = MM-60;
end

out = sprintf('%02d:%02d:%02d',HH,MM,SS);