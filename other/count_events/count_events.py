import numpy as np
import ROOT
from ROOT import TTimeStamp, gStyle

# nuphase headers
from load import nuphase_data_reader
import global_constants

gStyle.SetOptStat(0)
start = ROOT.TTimeStamp(2019,1, 1, 0,0,0,0,True,0)
stop  = ROOT.TTimeStamp(2019,12,31,0,0,0,0,True,0)
start_bin = start.GetSec()
stop_bin  = stop.GetSec()

h1 = ROOT.TH1D("h1","h1",365, start_bin, stop_bin)
h1.GetXaxis().SetTitle("Date")
h1.GetYaxis().SetTitle("Number of Events")
h1.SetTitle("")
h1.GetXaxis().SetTimeDisplay(1)
h1.GetXaxis().SetTimeFormat("%b")
h1.GetXaxis().SetTimeOffset(0., "GMT")

tot_num_events=0
tot_num_runs=0
tot_time=0

file = open("../scripts/pa_runlist.txt", "r") # list of pa runs
for i_line, line in enumerate(file):
	
	run_no = int(line.strip()) # remove the trailing EOL character, cast as int
	
	d = nuphase_data_reader.Reader(global_constants.NUPHASE_DATA,run_no)

	d.setEntry(0)
	h = d.header()
	t_start = h.getReadoutTime()
	d.setEntry(d.N()-1)
	h = d.header()
	t_stop = h.getReadoutTime()
	if(t_stop-t_start<0):
		# something is very wrong with such runs...
		continue

	if(t_start>=start_bin):

		tot_num_runs+=1

		for i in range(0,d.N()):
			d.setEntry(i)
			h = d.header()
			time = h.getReadoutTime()

			h1.Fill(time)
			tot_num_events+=1

		tot_time+=t_stop-t_start

	# if(i_line>50):
	# 	break

print("Number of events total: {}".format(tot_num_events))
print("Amount of time in seconds total: {}".format(tot_time))
# print("Number of runs is {}".format())

c = ROOT.TCanvas("canvas","canvas",1100,850)
c.cd()
h1.Draw("hist")
# h1.GetXaxis().SetNdivisions(5,2,0,False)
# h1.SetLineWidth(3)
c.Print("hist_of_events.png")
