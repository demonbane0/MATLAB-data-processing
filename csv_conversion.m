clear

FileName='190625_155513'; %user defined file name

fid=fopen(strcat(FileName,'.rurf'),'rb');
LoadHeader = ['h_' FileName];
eval(LoadHeader);

MaxSampleNum=4096;
TxBeamNum=Na;
element_real_all=64;
%%% Read the raw data
A2 = fread(fid, MaxSampleNum*Na*TxBeamNum*MainFrameNum, 'int16');
data = reshape(A2,MaxSampleNum,Na,TxBeamNum,MainFrameNum);
data = data(1:SampleNum,1:element_real_all,1:element_real_all,MainFrameNum);
data = reshape(data,SampleNum,element_real_all*element_real_all,MainFrameNum);
clear A2
fclose(fid);

for ff=1:MainFrameNum

    col_name_all=["Time(us)"];
    for ii=1:element_real_all
        for jj =1:element_real_all
        col_name = string(['t' num2str(ii,'%03i') 'r' num2str(jj,'%03i')]);
        col_name_all = vertcat(col_name_all,col_name);
        end
    end

    col_name_all=col_name_all';
    commaHeader = [col_name_all;repmat({','},1,numel(col_name_all))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = commaHeader(1:end-1);

    write_file_name=[FileName '_frame_' num2str(ff) '.csv'];
    %write header to file
    fid = fopen(write_file_name,'w'); 
    fprintf(fid,'%s',textHeader);
    fprintf(fid,'\n',[]);
    fclose(fid);
    %write data to end of file

    data_time=1000000/fs*(0:SampleNum-1)';
    data=[data_time squeeze(data(:,:,:,ff))];
    dlmwrite(write_file_name,data,'-append');

end

data(:,:,1);


