function rt=getPerTime(time,sDay,nDays)
    stDay = daysadd(time.TimeInfo.StartDate,sDay);
    enDay = daysadd(stDay,nDays);
    rt = getsampleusingtime(time,datenum(stDay),datenum(enDay));
end