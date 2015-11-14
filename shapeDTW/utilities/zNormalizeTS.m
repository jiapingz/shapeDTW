function zn_ts = zNormalizeTS(ts)
    std_ts = std(ts);
    me_ts = mean(ts);    
    zn_ts = (ts-me_ts)/std_ts;
end