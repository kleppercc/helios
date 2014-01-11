%******************************************************************************************
%*   Mfunction to lookup of line ratios and
%*   determine ne and Te
%*
%*   written by o.schmitz, July 2004
%******************************************************************************************
%*
%*
%*   # Usage:
%*
%*   [ne_axis, te_axis, ne_ratios, te_ratios]=load_tapete(tapete_name);
%*   
%*   # Input:    'tapete_name' :   is the filename of the tapete you would like to use
%*                                 - ./pcals/all_n_62_a.te_ne (Default and best proofed)
%*                                 - ./pcals/all_n_64_a.te_ne
%*                                 - ./pcals/gg_deheer_a.te_ne
%*   # Output:   'ne_axis'     :   Range of ne values in this tapete
%*               'te_axis'     :   Range of Te values in this tapete
%*               'ne_ratios    :   Ratio array for the ne sensitive line ratios
%*               'te_ratios    :   Ratio array for the Te sensitive line ratios
%*
%*****************************************************************************************

%function [ne_axis, te_axis, ne_ratios, te_ratios]=load_tapete(tapete_name)






