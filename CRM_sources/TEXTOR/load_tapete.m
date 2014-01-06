%******************************************************************************************
%*   Mfunction to load the tapete for lookup of line ratios and
%*   determination of ne and Te
%*
%*   written by o.schmitz, July 2004
%******************************************************************************************
%*
%*
%*   # Usage:
%*
%*   [ne_axis, Te_axis, ne_ratio_model, Te_ratio_model]=load_tapete(tapete_name);
%*   
%*   # Input:    'tapete_name' :   is the filename of the tapete you would like to use
%*                                 - ./pcals/all_n_62_a.te_ne (Default and best proofed)
%*                                 - ./pcals/all_n_64_a.te_ne
%*                                 - ./pcals/gg_deheer_a.te_ne
%*   # Output:   'ne_axis'     :   Range of ne values in this tapete
%*               'Te_axis'     :   Range of Te values in this tapete
%*               'ne_ratio_model    :   Ratio array for the ne sensitive line ratios
%*               'Te_ratio_model    :   Ratio array for the Te sensitive line ratios
%*
%*****************************************************************************************

function [ne_axis, Te_axis, ne_ratio_model, Te_ratio_model]=load_tapete(tapete_name)

%*** Load the tapete 
%*** Exist this data as mat file (loading is much, much faster)
fid=fopen('tapete_all_n_62_a.mat');
if fid == (-1)

%*** Load tapete as dummy to test for number of lines
%*** Matlab can not load it directly with 'load'!
disp('----------------------------------------------------------')
disp('------- Start loading of tapete. Please wait a moment')
disp(sprintf('%s%s%s','--- Tapete used is: # ',tapete_name,' #'))
test_lnum=load(tapete_name);
stest=size(test_lnum);
lnum_tapete=stest(1);

%*** Now load all lines with fgetl
tap_data=zeros(lnum_tapete,1);
fid=fopen(tapete_name);
i=1;
for i=1:lnum_tapete
    tline = fgetl(fid);
    tap_data(i)=str2num(tline);
    i=i+1;
end
fclose(fid);

%*** reshape the dataset
%*** Each axis is 301 points!
res_tap=reshape(tap_data,301,604);

%*** Create two axes for ne and te values
Te_axis=res_tap(:,1);
ne_axis=res_tap(:,2);
Te_ratio_model=res_tap(:,3:303);
ne_ratio_model=res_tap(:,304:604);
disp('------- Finnished loading of the tapete.')

else
    disp('----------------------------------------------------------')
    disp('------- Start loading of tapete from .mat.')
    load('tapete_all_n_62_a.mat');
    fclose(fid);
    disp('------- Finnished loading of the tapete.')
    disp('----------------------------------------------------------')
end

