%******************************************************************************************
%*   Mfunction to search ratios in the tapete and for the
%*   determination of ne and Te
%*
%*   written by o.schmitz, August 2004
%******************************************************************************************
%*
%*
%*   # Usage:
%*
%*   [ne_He, Te_He]=lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, ne_ratio_exp, Te_ratio_exp, BoundVal);
%*   
%*   # Input:    'ne_axis'             :   ne axis extracted from the content of the tapete data   
%*               'Te_axis'             :   Te axis extracted from the content of the tapete data   
%*               'ne_ratio_modell'     :   ne intensity ratios from tapete loaded before with 'load_tapete' 
%*               'Te_ratio_modell'     :   Te intensity ratios from tapete loaded before with 'load_tapete' 
%*               'ne_ratio_exp'        :   ne intensity ratios from experiment (668/728)
%*               'Te_ratio_exp'        :   Te intensity ratios from experiment (728/706)
%*               'BoundVal    '        :   vector with boundary values for ne and Te determination: 
%*                                         ['shotnum' 'minTe' 'maxTe' 'minne' 'maxne']
%*                                         Example: BoundVal=[95895 20 200 1.0e18 2.0e19];
%*
%*   # Output:   'ne_He'       :   ne data from He-beam
%*               'Te_He'       :   Te data from He-beam
%*
%*****************************************************************************************


function [ne_He, Te_He]=lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, ne_ratio_exp, Te_ratio_exp, BoundVal);

% disp('---------------------------------------------------------------')
% disp('------- Start look up of ratios an determination of ne & Te')
% disp('------- Progress will be plotted after all 50 frames !')

frnum=size(Te_ratio_exp);
teval=zeros(frnum(1),frnum(2));
neval=zeros(frnum(1),frnum(2));

%*** Set step for first coarse lookup
step = 15;

ne_ratio_model_coarse = ne_ratio_model([step + 1:step:length(ne_ratio_model)-step],[step+1:step:length(ne_ratio_model)-step]);
Te_ratio_model_coarse = Te_ratio_model([step + 1:step:length(Te_ratio_model)-step],[step+1:step:length(Te_ratio_model)-step]);

for k=1:frnum(2)
    %*** Give some messages because the eval will last around 3 min
    if mod(k,50)==0
%         disp(sprintf('%s%i%s','Evaluation of # ' ,k, ' # frames finnished'))
    end
      
    for i = 1:frnum(1)
       if mod(k,50)==0
%         kdisp(sprintf('%s%i%s','Evaluation of # ' ,k, ' # frames finnished'))
    end
        
         
         
        
        
        error_coarse = abs(1-ne_ratio_exp(i,k)*ne_ratio_model_coarse)+abs(1-Te_ratio_exp(i,k)*Te_ratio_model_coarse);
    
        ne_index = find(min(min(error_coarse))==min(error_coarse,[],2));
        Te_index = find(min(min(error_coarse))==min(error_coarse,[],1));
        
        %*** Catch strange values in the error matrix
        neindex_er=size(ne_index);
        Teindex_er=size(Te_index);        
        if neindex_er(1) ~= 1 || neindex_er(2) ~= 1
            ne_index=1;
        end
    
        if Teindex_er(1) ~= 1 || Teindex_er(2) ~= 1
            Te_index=1;
        end
        
        ne_ratio_model_ = ne_ratio_model([(ne_index-1)*step+1:(ne_index+1)*step],[(Te_index-1)*step+1:(Te_index+1)*step]);
        Te_ratio_model_ = Te_ratio_model([(ne_index-1)*step+1:(ne_index+1)*step],[(Te_index-1)*step+1:(Te_index+1)*step]);
    
        error_ = abs(1-ne_ratio_exp(i,k)*ne_ratio_model_)+abs(1-Te_ratio_exp(i,k)*Te_ratio_model_);
    
        ne_index_ = find(min(min(error_))==min(error_,[],2))-step+ne_index*step;
        Te_index_ = find(min(min(error_))==min(error_,[],1))-step+Te_index*step;

        %*** Catch strange values in the error matrix
        neindex_er=size(ne_index_);
        Teindex_er=size(Te_index_);        
        if neindex_er(1) ~= 1 || neindex_er(2) ~= 1
            ne_index_=1;
        end
    
        if Teindex_er(1) ~= 1 || Teindex_er(2) ~= 1
            Te_index_=1;
        end
        
        
        %*** Write data to ne and te vector and check for limits from
        %*** atomic modell (values according to PhD thesis of M. Brix)
        % BoundVal=[95895 20 200 1.0e18 2.0e19];
         Te_He(i,k)=Te_axis(Te_index_);
         ne_He(i,k)=ne_axis(ne_index_)*1e6;
         
         if (Te_He(i,k)>BoundVal(1,3)) ||  (ne_He(i,k)>BoundVal(1,5)) 
             Te_He(i,k)=BoundVal(1,3)+BoundVal(1,3)*0.01; %take the max value and add 1% to discriminate from the right values
             ne_He(i,k)=BoundVal(1,5)+BoundVal(1,5)*0.01; %take the max value and add 1% to discriminate from the right values
             
             %Te_He(i,k)=NaN; %will not plot data points which are out of range
             %ne_He(i,k)=NaN;
         end
         
         if (Te_He(i,k)<BoundVal(1,2)) || (ne_He(i,k)<BoundVal(1,4))
%              Te_He(i,k)=BoundVal(1,2)-BoundVal(1,2)*0.01; %take the max value and substract 1% to discriminate from the right values
%              ne_He(i,k)=BoundVal(1,4)-BoundVal(1,4)*0.01; %take the max value and substract 1% to discriminate from the right values
             
             %Te_He(i,k)=NaN; %will not plot data points which are out of range
             %ne_He(i,k)=NaN;
             
         end
         
         
         
         
    end
end
 
% disp('------- End of ne & Te determination')
% disp('---------------------------------------------------------------')
