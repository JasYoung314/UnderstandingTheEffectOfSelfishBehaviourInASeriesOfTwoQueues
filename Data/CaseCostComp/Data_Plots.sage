import csv
import os
file_names=os.listdir("./")
Blah = [e for e in file_names if 'Naor' in e]
file_names=[e for e in file_names if 'Random' in e]
file_names=[e for e in file_names if '.csv' in e]
PoA_List=[]

for e in file_names:
    name = e.split(',')
    infile=open(e,'rb')
    input=csv.reader(infile)
    data=[[eval(j) for j in row] for row in input]
    infile.close()
    PoA_List.append([eval(name[1]),data[-1][-1]])

infile = open(Blah[0],'rb')
input = csv.reader(infile)
data = [[eval(j) for j in row] for row in input]
infile.close()
Anadata = [[e[1],e[-1]] for e in data ]
Naordata = [[e[1],e[-2]] for e in data ]

PoA_List.sort()
p = line(PoA_List,color = 'black',axes_labels=['$\\Lambda$','Average Cost'],legend_label='Heuristic 1',linestyle = '-')
p += line(Anadata,color = 'black',legend_label='Heuristic 2',linestyle = '--')

p.ymin(0)
p.xmin(0)
p.set_legend_options(loc = (0.05,0.9))
p.save("PoA_v_Demand.pdf")

file_names = os.listdir("./")
file_names=[e for e in file_names if 'Ana' in e]
file_names=[e for e in file_names if '.csv' in e]

infile = open(file_names[-1],'rb')
input=csv.reader(infile)
data = [[eval(row[0]),eval(row[9])] for row in input]
p+=list_plot(data,legend_label='Analytical Result',plotjoined=True,color='black',ymin = 0)

p.save("PoA_v_Demand_comparison.pdf")
