from __future__ import division
from subprocess import call
from glob import glob
from csv import reader, writer
from math import factorial, e
import matplotlib.pyplot as plt
parameterset = []

datafiles = set(glob("./*.csv"))


def P0(lmbda,mu,c,M):
    sum=0
    for n in range(0,min(c,M+1)):
        sum+=(1/factorial(n))*((lmbda/mu)**n)
    for n in range(c,M+1):
        sum+=(1/((factorial(c))*((c)**(n-c))))*((lmbda/mu)**n)
    sum = 1/sum
    return sum

def PN(lmbda,mu,c,M,n):
    Pnought = P0(lmbda, mu, c, M)
    if n<c:
        PN=(1/factorial(n))*((lmbda/mu)**n)*P0
    else:
        PN=(1/((factorial(c))*((c)**(n-c))))*((lmbda/mu)**n)*Pnought
    return PN

N = 50000
warmupprop = .2
mu = 1
c = 2
n1 = 4

Lambdalist = [.05, .25, .5, .75, 1, 1.25, 1.5, 1.75, 2]
plist = [0,.125, .25, .365, .5, .625, .75, .875, 1]

for Lambda in Lambdalist:
    for p in plist:
        expectedRate = Lambda * (1 - p * (1 - PN(Lambda, mu, c, n1, n1)))
        T =  min(40000, N /(expectedRate * (1 - warmupprop)))

        print 50 * "-"
        print 'Running for Lambda=%s, p=%s.' % (Lambda, p)
        print 'Expected arrival rate: %s so using T=%s' %(expectedRate, T)
        print 50 * "-"

        warmup = warmupprop * T
        parameterset.append(""" %s
[%s,1]
[%s,2]
[10,1]
[4,4]
[%s,1]
%s
%s""" % (Lambda, mu, c, p, T, warmup))

print 50 * "-"
print 'Obtaining simulation data'
print 50 * "-"

for parameters in parameterset:
    f = open('parameters', 'w')
    f.write(parameters)
    f.close()
    call(['python', 'sim.py', 'file', 'parameters', '-w'])

print 50 * "-"
print 'Analysing simulation data'
print 50 * "-"

# Only consider new files:
datafiles = set(glob("./*csv")) - datafiles
datafiles = list(datafiles)

def getinterexittimes(f):
    data = [row for row in reader(open(f,'r'))]
    data = sorted([eval(row[4]) for row in data[1:] if row[4] != 'DNF'])
    return [x-data[i-1] for i, x in enumerate(data)][1:]

datadict = {}

for f in datafiles:
    parameters = f.split(',')
    Lambda = parameters[0][parameters[0].index('(')+1:]
    p = parameters[-2][parameters[-2].index('[')+1:]
    fle = open("Lambda%s-p%s.csv" % (Lambda, p), 'w')
    csvwrter = writer(fle)
    interexittimes = getinterexittimes(f)
    if Lambda in datadict:
        datadict[Lambda][p] = interexittimes
    else:
        datadict[Lambda] = {p: interexittimes}
    for element in interexittimes:
        csvwrter.writerow([element])
    fle.close()

# Plot histograms
for Lambda in datadict:
    for p in datadict[Lambda]:
        try:
            expectedRate = eval(Lambda) * (1 - eval(p) * (1 - PN(eval(Lambda), mu, c, n1, n1)))
            maxinterexittime = int(max(datadict[Lambda][p])) + 1
            x = [t / 100 for t in range(100 * maxinterexittime)]
            y = [expectedRate * e ** (-expectedRate * t) for t in x]
            plt.figure()
            plt.hist(datadict[Lambda][p], normed=True, bins=20, label='Simulation (N=%s)' % len(datadict[Lambda][p]))
            plt.plot(x,y, color='red', label ='pdf with $\\lambda=%.4f$' % expectedRate)
            plt.legend()
            rho = eval(Lambda) / (c * mu)
            plt.title("$\\rho=%s, p=%s, n_1=%s$" % (rho, p, n1))
            plt.savefig("rho%s-p%s-n1%s.svg" % (rho, p, n1))
        except:
            print "Could not plot for Lambda=%s and p=%s" % (Lambda, p)
