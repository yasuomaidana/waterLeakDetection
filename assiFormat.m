%%Asign format to the time series to plot in a fancy way
function times=assiFormat(times,formato,valor)
    times.DataInfo.Units=valor;
    times.TimeInfo.Units='minutes';
    times.TimeInfo.StartDate=datetime('now');
    times.TimeInfo.Format=formato;
end