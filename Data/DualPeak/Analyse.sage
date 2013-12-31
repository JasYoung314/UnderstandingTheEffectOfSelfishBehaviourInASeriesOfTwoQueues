import os,sys,csv

def evalfail(string):
    try:
        return eval(string)
    except:
        return string

files = os.listdir('.')
Data = []
for e in files :
    if '.csv' in e:
        infile = open(e,'rb')
        input = csv.reader(infile)
        Data.append( [[evalfail(i) for i in row] for row in input])
       #Data.append( [row for row in e])
        infile.close()
p = plot([],axes_labels = ['$ \\lambda $','PoA'])
q = plot([],axes_labels = ['$ \\lambda $','PoA'])
r = plot([],axes_labels = ['$ \\lambda $','Cost'])

r1data = []
r2data = []
r3data = []
colors = rainbow(5)
for e in Data:
    pdata = []
    qdata = []

    for i in e:
        pdata.append([i[1],(i[-4]/i[-1])])
        qdata.append([i[1],(i[-4]/i[-2])])
        r1data.append([i[1],i[-1]])
        r2data.append([i[1],i[-2]])
        r3data.append([i[1],i[-3]])


    p+= line(pdata,color = 'black')
    q+= line(qdata,color = 'black')

r += line(r1data,color = 'black', legend_label = 'Heuristic 2',linestyle = '--')
r += line(r2data,color = 'black', legend_label = 'Heuristic 3',linestyle = ':')
r += line(r3data,color = 'black', legend_label = 'Heuristic 1',linestyle = '-')

r.save('./costcomp.pdf')
p.save('./Ana.pdf')
q.save('./Naor.pdf')
