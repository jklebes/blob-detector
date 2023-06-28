

folder_in = pathConverter('A:\analysis\expk0720_ACTN_tracking\tmp_transform_data_myosinORnuclei');
info_file =  [folder_in filesep '_info.txt'];
folder_out= pwd;
eR=expReader(folder_in);

format=eR.format();
timePoints=eR.timePoints();
numImages = length(timePoints);
tables=cell(numImages,1);
diameter=16;
threeD=true;

if threeD

    Width=findMatchingNumber(info_file,{'Width: ' '%d'},1);
    Height=findMatchingNumber(info_file,{'Height: ' '%d'},1);
    Depth=findMatchingNumber(info_file,{'Depth: ' '%d'},1);

    %delete(gcp('nocreate'));
    %parpool(4);
    for i=timePoints
        img_vol=zeros(Width,Height,Depth,'uint8');
        rawInputImageHandle=fopen([folder_in filesep format{1} num2str(i, format{2}) format{3}]);
        for iInputImage=1:Depth
            img_vol(:,:,iInputImage)=...
                fread(rawInputImageHandle,[Width Height],'uint8');
        end
        fclose(rawInputImageHandle);
        tic;

        [x,y,z] =size(img_vol);
        blobs_all = table('Size',[0,4],'VariableTypes',{'double','double','double','double'},'VariableNames',{'x','y','z','Intensity'});
        for xstart = 1:430:x-1
            for ystart = 1:430:y-1
                subimage = img_vol(xstart:min(xstart+450,x), ystart:min(ystart+450,y),:);
                blobs=blobdetect3D(subimage,diameter, GPU=true, BorderWidth=10);
                blobs{:,1}=blobs{:,1}+xstart-1;
                blobs{:,2}=blobs{:,2}+ystart-1;
                blobs_all=union(blobs_all, blobs);
            end
        end
        toc
        disp(['found ' num2str(size(blobs_all,1)) ' nuclei in volume ' num2str(i)])
        tables{i}=blobs_all;
        img_out= annotate_image(img_vol, blobs_all, diameter, 165);
        save([folder_out filesep 'blobdetect_results3D'], 'tables' );
    end %chunk

else
    %2D loop
    parfor i=timePoints
        img=imread(rawInputImageHandle, [Width Height],'uint8');
        tic;
        diameter=16;
        blobs=blobdetect(img,diameter, GPU=true);
        disp(['found ' num2str(size(blobs,1)) ' nuclei in image' num2str(i)])
        tables{i}=blobs;
        img_out= annotate_image(img, blobs, diameter);
        save([folder_out filesep 'blobdetect_results'], 'tables' );
    end %chunk
end