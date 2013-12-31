import os,sys,csv

def evalfail(string):
    try:
        return eval(string)
    except:
        return string

files = os.listdir('.')
files = [e for e in files if '.csv' in e]
files.sort()
Data = []

for e in files :

    infile = open(e,'rb')
    input = csv.reader(infile)
    Data.append( [[evalfail(i) for i in row] for row in input])
    infile.close()

p = plot([],axes_labels = ['$ p $','PoA'])
q = plot([],axes_labels = ['$ p $','PoA'])
r = plot([],axes_labels = ['$ p $','Cost'])

r1data = []
r2data = []
styles = ['-',2,'--',2,':']
colors = rainbow(5)
for e in Data:
    pdata = []
    qdata = []

    for i in e:
        pdata.append([i[8],(i[-3]/i[-1])])
        qdata.append([i[8],(i[-3]/i[-2])])

        if e[0][6] == 2 and int(24*e[0][7])+1 == 8:
            r1data.append([i[1],i[-1]])
            r2data.append([i[1],i[-2]])
    if not int(e[0][7]*24)+1 == 4 and not int(e[0][7]*24)+1 == 16:
        p+= line(pdata,color = 'black',linestyle = styles[Data.index(e)],legend_label = '%s days %s hours' %(e[0][6],min(int(e[0][7]*24)+1,24)))
        q+= line(qdata,color = 'black',linestyle = styles[Data.index(e)],legend_label = '%s days %s hours' %(e[0][6],min(int(e[0][7]*24)+1,24)))

r += line(r1data,color = 'red', legend_label = 'Ana')
r += line(r2data, legend_label = 'Naor')

r.save('./costcomp.pdf')
p.save('./Ana.pdf')
q.save('./Naor.pdf')
