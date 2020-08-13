import matplotlib.pyplot as plt
import numpy as np
from numpy import genfromtxt
from scipy.interpolate import interp1d

# import the filter responses
filter_vals = np.genfromtxt("filter.csv",delimiter=',',skip_header=0,names=['freq','amp'])
foam_vals = np.genfromtxt("FOAM.csv",delimiter=',',skip_header=0,names=['freq','amp'])
preamp_vals = np.genfromtxt("preamp.csv",delimiter=',',skip_header=0,names=['freq','amp'])
gaintwofilt_vals = np.genfromtxt("ARA_Electronics_TotalGain_TwoFilters.txt",delimiter=',',skip_header=3,names=['freq','amp','phase'])

# define a common set of frequency bins to study
common_freq = np.arange(start=0, stop=1000, step=1)

# make interpolation functions
f_filter = interp1d(filter_vals['freq'], filter_vals['amp'], fill_value='extrapolate')
f_foam = interp1d(foam_vals['freq'], foam_vals['amp'], fill_value='extrapolate')
f_preamp = interp1d(preamp_vals['freq'], preamp_vals['amp'], fill_value='extrapolate')
f_gaintwofilt = interp1d(gaintwofilt_vals['freq'], 20*np.log10(gaintwofilt_vals['amp']), fill_value='extrapolate')


# make some plots to convince ourselves the interpolation is workin
debug=false
if(debug)
	fig = plt.figure(figsize=(20,4))
	sizer=32

	ax0 = fig.add_subplot(1,4,1)
	ax1 = fig.add_subplot(1,4,2)
	ax2 = fig.add_subplot(1,4,3)
	ax3 = fig.add_subplot(1,4,4)

	ax0.plot(filter_vals['freq'], filter_vals['amp'],'-', label='Filter')
	ax0.plot(common_freq, f_filter(common_freq),'--', label='Interp Filter')


	ax1.plot(foam_vals['freq'], foam_vals['amp'],'-', label='FOAM')
	ax1.plot(common_freq, f_foam(common_freq),'-', label='Interp FOAM')


	ax2.plot(preamp_vals['freq'], preamp_vals['amp'], label='Preamp')
	ax2.plot(common_freq, f_preamp(common_freq),'-', label='Interp Preamp')


	ax3.plot(gaintwofilt_vals['freq'], 20*np.log10(gaintwofilt_vals['amp']), label='TotalGain_TwoFilters')
	ax3.plot(common_freq, f_gaintwofilt(common_freq), label='Interp TotalGain_TwoFilters')

	for ax in fig.axes:
		ax.set_xlabel("Freq")
		ax.set_ylabel("Gain")
		ax.set_ylim(-10,80)
		ax.legend() 


	fig.savefig("gains.png",dpi=300)


# finally make plot comparing summed of filter + preamp + foam
# to that of the totalgain_twofilter
the_sum = f_filter(common_freq) + f_foam(common_freq) + f_preamp(common_freq)
the_whole = f_gaintwofilt(common_freq)
diff = the_sum - the_whole

fig2 = plt.figure(figsize=(11.5,8.5))
frame1=fig2.add_axes((.1,.3,.8,.6))
frame2=fig2.add_axes((.1,.1,.8,.2))  
frame1.plot(common_freq,the_sum,'-',label = 'Filter + FOAM + Preamp ("sum")', linewidth=3)
frame1.plot(common_freq,the_whole,'--',label = 'TotalGain_TwoFilters ("whole")', linewidth=3)
frame1.legend(loc='lower center', fontsize=15)
frame1.set_ylabel('Gain (dB)', size=15)
frame1.set_ylim([-10,80])
frame2.set_ylim([-1,1])
# frame2.set_yticks([0.3,0.4,0.5,0.6,0.7,0.8])
frame2.plot(common_freq,diff,'ko')
frame2.set_ylabel('sum - whole ', size=15, labelpad=12) #give it a title
frame2.set_xlabel('Freq [MHz]', size=15)
frame1.tick_params(axis='both', which='major', labelsize=15)
frame2.tick_params(axis='both', which='major', labelsize=15)
fig2.savefig('sum_vs_total.png',edgecolor='none',bbox_inches="tight") #save the figure



