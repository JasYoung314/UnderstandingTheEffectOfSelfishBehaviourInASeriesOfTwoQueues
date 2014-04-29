import csv

infile=open('Timings.csv','rb')
input=csv.reader(infile)
plot_data=[row for row in input]
plot_data=[[eval(e) for e in row] for row in plot_data[1:]]
infile.close()
plot_data.sort()

p=list_plot(plot_data,plotjoined=True,axes_labels=['$\Lambda$','Time'])

p.save("Merling_Real_Time_Plot-for_varying_Lambda.pdf")
