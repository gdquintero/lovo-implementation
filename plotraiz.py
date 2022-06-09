import matplotlib.pyplot as plt
import numpy as np

# Definimos el polinomio de grado 3
def poly(x,t,tn):
    return x[0] + x[1] * (t - tn) + x[2] * (t - tn)**2 + x[3] * (t - tn)**3

# Funcion para leer vectores desde ficheros txt
def read_vector(file,x):
    with open(file) as f:
        lines = f.readlines()
        xdata = [line.split()[0] for line in lines]

    n = len(xdata)

    for i in range(n):
        x[i] = float(xdata[i])

    return x

class Model:
    def __init__(self,status,name,file,color):
        self.status = status
        self.name = name
        self.file = file
        self.color = color
        
lovo    = Model(True,"LOVO","output/xstarlovo.txt","red")

x = np.zeros(4)
read_vector(lovo.file,x)

# Numero de dias considerados
with open('output/days.txt') as f:
    days = int(f.readline())
    outliers = int(f.readline())
    predictedDays = int(f.readline())

h = 100
data = np.zeros(days)
data2 = np.zeros(predictedDays)

# Variables temporales
ti = np.linspace(1,days,days)
t = np.linspace(1,days+predictedDays,h)
ti2 = np.linspace(days+1,days+predictedDays,predictedDays)

scalx = np.zeros(int((days+predictedDays)/5),dtype=int)
j = 0

for i in range(5,days + predictedDays + 1,5):
    scalx[j] = i
    j += 1

plt.rcParams['text.usetex'] = True

# Leemos los datos de cada dia
read_vector('output/data.txt',data)
read_vector('output/data2.txt',data2)

limits = [ 0, days + predictedDays + 1, \
min(min(data),min(data2))-1,max(max(data),max(data2))+1]

plt.plot(ti,data,'o',markeredgecolor="black",markerfacecolor="black")
plt.plot(ti2,data2,'ko',mfc='none')
plt.plot(t,poly(x,t,ti[days-1]),label=lovo.name,color=lovo.color)
plt.axis(limits)
plt.legend()
plt.xlabel(r'Data between March 1 and April 29, 2021')
plt.ylabel(r'Deaths per million people')
plt.xticks(scalx)
# plt.savefig('plot.eps')
# plt.savefig('plot.png')
plt.show()