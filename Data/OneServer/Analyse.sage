import os,sys,csv

def evalfail(string):
    try:
        return eval(string)
    except:
        return string

files = os.listdir('.')
files = [e for e in files if '.csv' in e]
print files
Data = []
for e in files :
    if '.csv' in e:
        infile = open(e,'rb')
        input = csv.reader(infile)
        Data.append( [[evalfail(i) for i in row] for row in input])
        infile.close()

for e in Data:
    r = plot([],axes_labels = ['$ \\lambda $','Average Cost'])

    r1data = []
    r2data = []
    r3data = []
    colors = rainbow(5)

    for i in e:
        r1data.append([i[1],i[-1]])
        r2data.append([i[1],i[-2]])
        r3data.append([i[1],i[-3]])

    r += line(r3data,color = 'black', legend_label = 'Heuristic 1',linestyle = '-')
    r += line(r1data,color = 'black',   legend_label = 'Heuristic 2',linestyle = '--')
    r += line(r2data,color = 'black',  legend_label = 'Heuristic 3',linestyle = ':')

    r.save('./Exit%s.pdf' %e[0][8])
