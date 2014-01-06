"""
Classes to accompany the paper entitled Understanding the effect of selfish behaviour in series of queues.
"""

class State():
    """
    A state.
    """
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return str(self.value)


class StateSpace():
    """
    State space.
    """
    def __init__(self, tau):
        self.states = []
        self.indextostatedict = {}
        counter = 0
        for i in range(tau[0] + 1):
            for j in range(tau[1] + 1):
                self.states.append(State([i, j]))
                self.indextostatedict[counter] = self.states[-1]
                counter += 1
    def __str__(self):
        return str([str(s) for s in self.states])
    def __len__(self):
        return len(self.states)


class Instance():
    """
    An instance of a given problem.
    """
    def __init__(self, Lambda, mu, c, beta, p, tau=False):
        self.Lambda = Lambda
        self.mu = mu
        self.c = c
        self.beta = beta
        self.p = p
        self.tau = tau
        if self.tau:
            self.n1 = tau[0]
            self.n2 = tau[1]
        else:
            self.n1 = floor(self.beta[0] * self.mu[0] * self.c[0] - 1)
            self.n2 = floor(self.beta[1] * self.mu[1] * self.c[1] - 1)
            self.tau = [self.n1, self.n2]
        self.statespace = StateSpace(self.tau)
        self.Q = False
        self.P = False

        # Obtain matrix
    def obtainQ(self):
        self.Q = []
        for s1 in self.statespace.indextostatedict:
            row = []
            for s2 in self.statespace.indextostatedict:
                row.append(self.statetorate(self.statespace.indextostatedict[s1], self.statespace.indextostatedict[s2]))
            self.Q.append(row)
        for i in range(len(self.Q)):
            self.Q[i][i] = - sum(self.Q[i])
        self.Q = matrix(self.Q, sparse=True)


    def obtainP(self):
        if not self.Q:
            self.obtainQ()
        self.P = self.QtoP(self.Q)

    def obtainpi(self, epsilon=.001):
        if not self.P:
            self.obtainP()
        self.pi = self.P[0]
        while max([max(self.pi-row) for row in self.P[1:]]) > epsilon:
            self.P *= self.P
            self.pi = self.P[0]
        return self.pi


    def QtoP(self, Q):
        Dt = 1 / max([abs(q) for q in Q.diagonal()])
        return Q * Dt + identity_matrix(len(Q.rows()))

    def statetorate(self, state1, state2):
        i1 = state1.value[0]
        j1 = state1.value[1]
        i2 = state2.value[0]
        j2 = state2.value[1]
        delta = [i2 - i1, j2- j1]
        if delta == [1,0] and i1 < self.n1:  # Arrival and below threshold at first station
            return self.Lambda
        if delta == [0, 1] and i1 == self.n1 and j1 < self.n2:  # Arrival and at threshold at first station
            return self.Lambda
        if delta == [-1, 1] and j1 < self.n2:  # Service at first station and below threshold at second
            return (1-self.p) * self.mu[0] * min(i1, self.c[0])
        if delta == [-1, 0]:  # Service at first station but no increase at second
            if j1 < self.n2:  # Below threshold at second station
                return self.p * self.mu[0] * min(i1, self.c[0])
            if j1 == self.n2:  # At threshold at second station
                return self.mu[0] * min(i1, self.c[0])
        if delta == [0, -1]:  # Service at second station
            return self.mu[1] * min(j1, self.c[1])
        return 0

if __name__ == '__main__':
    import csv

    try:
        f = open('timeingoutput.csv', 'r')
        csv.rdr = csv.reader(f)
        timeingdata = [[eval(k) for k in row] for row in csv.rdr]
        f.close()
    except:
        timeingdata = []

    maxsize = 500
    for c in range(2, maxsize):
        f = open('timeingoutput.csv', 'a')
        csvwtr = csv.writer(f)

        p = Instance(5, [c,1], [1,1], [1,1], .2)
        dim = floor(p.beta[0] * p.mu[0] * p.c[0]) * floor(p.beta[1] * p.mu[1] * p.c[1])
        print 'Running for dim=%s' % dim
        t = timeit('p.obtainpi()', seconds=True)
        print '\t', t

        timeingdata.append([dim,t])
        csvwtr.writerow(timeingdata[-1])
        f.close()

        p = list_plot(timeingdata, axes_labels=['$|S|$', 'time (seconds)'], xmin=0, ymin=0)
        p.save('timeingplot.pdf')
