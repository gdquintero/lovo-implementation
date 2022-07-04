import matplotlib.pyplot as plt
import numpy as np

scenario = np.loadtxt('output/gnuplot/scenarios.txt')
orderValue = np.loadtxt('output/gnuplot/ordervalues.txt')

# plt.plot(data[:,0],data[:,1])
# plt.plot(data[:,0],data[:,2])
# plt.plot(data[:,0],data[:,3])
# plt.plot(data[:,0],data[:,4])
# plt.plot(data[:,0],data[:,5])
# plt.show()

fig, axs = plt.subplots(3, 2)

for i in range(6):
    for j in range(1,6):
        axs[i//2,i%2].plot(scenario[:,0],scenario[:,j])
    if i != 0:
        axs[i//2,i%2].plot(orderValue[:,0],orderValue[:,i],color='black',linewidth=2)

plt.show()