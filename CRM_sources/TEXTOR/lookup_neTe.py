##******************************************************************************************
##*   Mfunction to search ratios in the tapete and for the
##*   determination of ne and Te
##*
##*   written by o.schmitz, August 2004
##******************************************************************************************
##*
##*
##*   # Usage:
##*
##*   [ne_He, Te_He]=lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, ne_ratio_exp, Te_ratio_exp, BoundVal);
##*
##*   # Input:    'ne_axis'             :   ne axis extracted from the content of the tapete data
##*               'Te_axis'             :   Te axis extracted from the content of the tapete data
##*               'ne_ratio_modell'     :   ne intensity ratios from tapete loaded before with 'load_tapete'
##*               'Te_ratio_modell'     :   Te intensity ratios from tapete loaded before with 'load_tapete'
##*               'ne_ratio_exp'        :   ne intensity ratios from experiment (668/728)
##*               'Te_ratio_exp'        :   Te intensity ratios from experiment (728/706)
##*               'BoundVal    '        :   vector with boundary values for ne and Te determination:
##*                                         ['shotnum' 'minTe' 'maxTe' 'minne' 'maxne']
##*                                         Example: BoundVal=[95895 20 200 1.0e18 2.0e19];
##*
##*   # Output:   'ne_He'       :   ne data from He-beam
##*               'Te_He'       :   Te data from He-beam
##*
##*****************************************************************************************

import numpy as np
import scipy as sp

#function [ne_He, Te_He]=lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, ne_ratio_exp, Te_ratio_exp, BoundVal);

def lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, ne_ratio_exp, Te_ratio_exp, BoundVal,quiet=0):

	if quiet!=0:
		print '-----------------------------------------------------------'
		print '------- Start look up of ratios an determination of ne & Te'
		print '-----------------------------------------------------------'

	#*** Set step for first coarse lookup
	step = 15
	ne_ratio_model_coarse = ne_ratio_model[step:len(ne_ratio_model)-step:step,step:len(ne_ratio_model)-step:step]
	Te_ratio_model_coarse = Te_ratio_model[step:len(Te_ratio_model)-step:step,step:len(Te_ratio_model)-step:step]

 	frnum=np.shape(Te_ratio_exp);

	if len(frnum) == 0:
		teval=np.zeros(1);
		neval=np.zeros(1);
		error_coarse = np.abs(1-ne_ratio_exp*ne_ratio_model_coarse)+np.abs(1-Te_ratio_exp*Te_ratio_model_coarse);

 		ne_index = np.array(np.where(np.min(np.min(error_coarse))==np.min(error_coarse,1)))
 		Te_index = np.array(np.where(np.min(np.min(error_coarse))==np.min(error_coarse,0)))
 		ne_index.squeeze()
 		Te_index.squeeze()

 		#*** Catch strange values in the error matrix
 		neindex_er=ne_index.shape
 		Teindex_er=Te_index.shape
 		if ((neindex_er[0] != 1) or (neindex_er[1] != 1)):
 			ne_index=1
 		if ((Teindex_er[0] != 1) or (Teindex_er[1] != 1)):
 			Te_index=1

 		ne_ratio_model_ = ne_ratio_model[(ne_index-1+1)*step+1-1:(ne_index+1+1)*step-1,(Te_index-1+1)*step+1-1:(Te_index+1+1)*step-1]
 		Te_ratio_model_ = Te_ratio_model[(ne_index-1+1)*step+1-1:(ne_index+1+1)*step-1,(Te_index-1+1)*step+1-1:(Te_index+1+1)*step-1]
 		error_ = np.abs(1-ne_ratio_exp*ne_ratio_model_)+np.abs(1-Te_ratio_exp*Te_ratio_model_);

 		hold1 = np.array(np.where(np.min(np.min(error_))==np.min(error_,axis=1)))
 		hold1 = hold1+1
 		hold1.squeeze()
 		ne_index_ = hold1-(step)+(ne_index+1)*(step)-1
 		hold2 = np.array(np.where(np.min(np.min(error_))==np.min(error_,axis=0)))
 		hold2 +=1
 		hold2.squeeze()
 		Te_index_ = hold2-(step)+(Te_index+1)*(step)-1
 		ne_index_.squeeze()
 		Te_index_.squeeze()

 		#*** Catch strange values in the error matrix
		neindex_er=ne_index_.shape
		Teindex_er=Te_index_.shape
		if ((neindex_er[0] != 1) or (neindex_er[1] != 1)):
			ne_index_=1

		if ((Teindex_er[0] != 1) or (Teindex_er[1] != 1)):
			Te_index_=1

		#*** Write data to ne and te vector and check for limits from
		#*** atomic model (values according to PhD thesis of M. Brix)
		# BoundVal=[95895 20 200 1.0e18 2.0e19];
		Te_He=Te_axis[Te_index_]
		ne_He=ne_axis[ne_index_]*1e6

		if ((Te_He>BoundVal[2]) or  (ne_He>BoundVal[4])):
			Te_He=BoundVal[2]+BoundVal[2]*0.01 #take the max value and add 1% to discriminate from the right values
			ne_He=BoundVal[4]+BoundVal[4]*0.01 #take the max value and add 1% to discriminate from the right values

			#Te_He=np.NaN #will not plot data points which are out of range
			#ne_He=np.NaN

		if ((Te_He<BoundVal[1]) or (ne_He<BoundVal[3])):
			Te_He=BoundVal[2]-BoundVal[2]*0.01; #take the max value and substract 1% to discriminate from the right values
			ne_He=BoundVal[4]-BoundVal[4]*0.01; #take the max value and substract 1% to discriminate from the right values

			#Te_He=NaN; %will not plot data points which are out of range
			#ne_He=NaN;

 	if len(frnum) == 1:
		for i in xrange(0,frnum[0]):

			teval=np.zeros(frnum[0]);
			neval=np.zeros(frnum[0]);

			error_coarse = np.abs(1-ne_ratio_exp[i]*ne_ratio_model_coarse)+np.abs(1-Te_ratio_exp[i]*Te_ratio_model_coarse);

			ne_index = error_coarse[np.min(np.min(error_coarse))==np.min(error_coarse,1)]
			Te_index = error_coarse[np.min(np.min(error_coarse))==np.min(error_coarse,0)]

			#*** Catch strange values in the error matrix
			neindex_er=ne_index.shape
			Teindex_er=Te_index.shape
			if ((neindex_er[0] != 1) or (neindex_er[1] != 1)):
				ne_index=1
			if ((Teindex_er[0] != 1) or (Teindex_er[1] != 1)):
				Te_index=1

			ne_ratio_model_ = ne_ratio_model[(ne_index-1)*step+1:(ne_index+1)*step,(Te_index-1)*step+1:(Te_index+1)*step]
			Te_ratio_model_ = Te_ratio_model[(ne_index-1)*step+1:(ne_index+1)*step,(Te_index-1)*step+1:(Te_index+1)*step]

			error_ = np.abs(1-ne_ratio_exp[i]*ne_ratio_model_)+np.abs(1-Te_ratio_exp[i]*Te_ratio_model_);

			ne_index_ = error_[np.min(np.min(error_))==np.min(error_,1)]-step+ne_index*step
			Te_index_ = error_[np.min(np.min(error_))==np.min(error_,0)]-step+Te_index*step

			#*** Catch strange values in the error matrix
			neindex_er=ne_index_.shape
			Teindex_er=Te_index_.shape
			if ((neindex_er[0] != 1) or (neindex_er[1] != 1)):
				ne_index_=1

			if ((Teindex_er[0] != 1) or (Teindex_er[1] != 1)):
				Te_index_=1

			#*** Write data to ne and te vector and check for limits from
			#*** atomic model (values according to PhD thesis of M. Brix)
			# BoundVal=[95895 20 200 1.0e18 2.0e19];
				Te_He[i]=Te_axis[Te_index_]
				ne_He[i]=ne_axis[ne_index_]*1e6

			if ((Te_He[i]>BoundVal[2]) or  (ne_He[i]>BoundVal[0,4])):
				Te_He[i]=BoundVal[2]+BoundVal[2]*0.01 #take the max value and add 1% to discriminate from the right values
				ne_He[i]=BoundVal[4]+BoundVal[4]*0.01 #take the max value and add 1% to discriminate from the right values

				#Te_He[i,k]=np.NaN #will not plot data points which are out of range
				#ne_He(i,k)=np.NaN

			if ((Te_He[i]<BoundVal[1]) or (ne_He[i]<BoundVal[3])):
				Te_He[i]=BoundVal[2]-BoundVal[2]*0.01; #take the max value and substract 1% to discriminate from the right values
				ne_He[i]=BoundVal[4]-BoundVal[4]*0.01; #take the max value and substract 1% to discriminate from the right values

				#Te_He(i,k)=NaN; %will not plot data points which are out of range
				#ne_He(i,k)=NaN;

	if len(frnum) > 1:
		teval=np.zeros(frnum[0],frnum[1]);
		neval=np.zeros(frnum[0],frnum[1]);

		for k in xrange(0,frnum[1]):
			#*** Give some messages because the eval will last around 3 min
			if (np.mod(k,50)==0):
				print '%s%i%s','Evaluation of # ' ,k, ' # frames finished'
			for i in xrange(0,frnum[0]):
				#*** Give some messages because the eval will last around 3 min
				if (np.mod(k,50)==0):
					print '%s%i%s','Evaluation of # ' ,k, ' # frames finnished'
				error_coarse = np.abs(1-ne_ratio_exp[i,k]*ne_ratio_model_coarse)+np.abs(1-Te_ratio_exp[i,k]*Te_ratio_model_coarse);

				ne_index = error_coarse[np.min(np.min(error_coarse))==np.min(error_coarse,1)]
				Te_index = error_coarse[np.min(np.min(error_coarse))==np.min(error_coarse,0)]

				#*** Catch strange values in the error matrix
				neindex_er=ne_index.shape
				Teindex_er=Te_index.shape
				if ((neindex_er[0] != 1) or (neindex_er[1] != 1)):
					ne_index=1
				if ((Teindex_er[0] != 1) or (Teindex_er[1] != 1)):
					Te_index=1

				ne_ratio_model_ = ne_ratio_model[(ne_index-1)*step+1:(ne_index+1)*step,(Te_index-1)*step+1:(Te_index+1)*step]
				Te_ratio_model_ = Te_ratio_model[(ne_index-1)*step+1:(ne_index+1)*step,(Te_index-1)*step+1:(Te_index+1)*step]

				error_ = np.abs(1-ne_ratio_exp[i,k]*ne_ratio_model_)+np.abs(1-Te_ratio_exp[i,k]*Te_ratio_model_);

				ne_index_ = error_[np.min(np.min(error_))==np.min(error_,1)]-step+ne_index*step
				Te_index_ = error_[np.min(np.min(error_))==np.min(error_,0)]-step+Te_index*step

				#*** Catch strange values in the error matrix
				neindex_er=ne_index_.shape
				Teindex_er=Te_index_.shape
				if ((neindex_er[0] != 1) or (neindex_er[1] != 1)):
					ne_index_=1

				if ((Teindex_er[0] != 1) or (Teindex_er[1] != 1)):
					Te_index_=1

				#*** Write data to ne and te vector and check for limits from
				#*** atomic model (values according to PhD thesis of M. Brix)
				# BoundVal=[95895 20 200 1.0e18 2.0e19];
					Te_He[i,k]=Te_axis[Te_index_]
					ne_He[i,k]=ne_axis[ne_index_]*1e6

				if ((Te_He[i,k]>BoundVal[2]) or  (ne_He[i,k]>BoundVal[4])):
					Te_He[i,k]=BoundVal[2]+BoundVal[2]*0.01 #take the max value and add 1% to discriminate from the right values
					ne_He[i,k]=BoundVal[4]+BoundVal[4]*0.01 #take the max value and add 1% to discriminate from the right values

					#Te_He[i,k]=np.NaN #will not plot data points which are out of range
					#ne_He(i,k)=np.NaN

				if (Te_He[i,k]<BoundVal[1]) or (ne_He[i,k]<BoundVal[3]):
					Te_He[i,k]=BoundVal[2]-BoundVal[2]*0.01; #take the max value and substract 1% to discriminate from the right values
					ne_He[i,k]=BoundVal[4]-BoundVal[4]*0.01; #take the max value and substract 1% to discriminate from the right values

					#Te_He(i,k)=NaN; %will not plot data points which are out of range
					#ne_He(i,k)=NaN;

 	if quiet!=0:
 		print '------- End of ne & Te determination ------------------'
 		print '-------------------------------------------------------'

  	return ne_He.squeeze(),Te_He.squeeze()
