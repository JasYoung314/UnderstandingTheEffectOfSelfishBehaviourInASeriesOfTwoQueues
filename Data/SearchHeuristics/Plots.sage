import csv
import os
print ""
print "Reading file names"
print ""
file_names=os.listdir("./")
file_names=[e for e in file_names if 'Random' in e]
file_names=[e for e in file_names if '.csv' in e]

print ""
print "Reading instances"
print ""

instances=list(set([s[s.index("("):s.index("csv")-1] for s in file_names]))

print ""
print "Analysing instances"
print ""
k=0
h=0

loops=[e[:e.index("-")] for e in file_names]
loops=list(set(loops))

print loops
clrs = rainbow(4)


for e in instances:
    print e
    for loop in loops:
        p = plot([])
        k+=1
        l=0
        print ""
        print "\t Analysing instance:"+loop

        file='%s-Random_V4-'%loop+e+'.csv'
        if file in file_names:
            l+=1
            print "\t\t Method: Random_V4"
            infile=open(file,'rb')
            input=csv.reader(infile)
            Steepest_V4=[[eval(row[0]),eval(row[2])] for row in input]
            infile.close()
            p+=list_plot(Steepest_V4,legend_label='Randon Descent',color= 'black', plotjoined=True, linestyle='',marker='o')

        file='%s-Random_V45-'%loop+e+'.csv'
        if file in file_names:
            l+=1
            print "\t\t Method: Random_V45"
            infile=open(file,'rb')
            input=csv.reader(infile)
            Random_V2=[[eval(row[0]),eval(row[2])] for row in input]
            infile.close()
            p+=list_plot(Random_V2,legend_label='Iterative Random Descent',color='black', plotjoined=True, linestyle='',marker='D')

        file='%s-Random_V6-'%loop+e+'.csv'
        if file in file_names:
            l+=1
            print "\t\t Method: Random_V6"
            infile=open(file,'rb')
            input=csv.reader(infile)
            Random_V3=[[eval(row[0]),eval(row[2])] for row in input]
            infile.close()
            p+=list_plot(Random_V3,legend_label='Fixed Search Range',color='black', plotjoined=True, linestyle='',marker='x')

        file='%s-Random_V65-'%loop+e+'.csv'
        if file in file_names:
            l+=1
            print "\t\t Method: Random_V65"
            infile=open(file,'rb')
            input=csv.reader(infile)
            Random_V4=[[eval(row[0]),eval(row[2])] for row in input]
            infile.close()
            p+=list_plot(Random_V4,legend_label='Variable Search Range',color='black', plotjoined=True, linestyle='',marker='+')

        if l>0:
           #p+=text(e,(p.xmax()/2,p.ymax()))
            p.axes_labels(['Iterations','Average Cost'])
            p.save('%s-'%loop+e+'.pdf')
        print ""
        print "\t\tGraph (%s) created"%(e+'.pdf')

print ""
print "Analysis finished (%s instances considered of which %s complete)"%(k,h)
print ""
