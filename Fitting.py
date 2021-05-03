import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

filename = '1hz_shutter.xlsx'
df = pd.read_excel(filename)

time = df['Time']
voltage = df['Voltage']


def plot_original(k):
    if(k):
        fig = df.plot(x ='Time', y='Voltage', kind = 'line', title= '1khz')
        fig = plt.gcf()
        fig.set_size_inches(18.5, 10.5)
        fig.savefig('Plots/1khz.png', dpi=100)
        plt.show()


def func(x, a, b, c):
    return a * np.exp(-b * x) + c


def fit_and_plot(i, start_time, ending_time, n, plot=True):
    start_t = start_time
    end_t = ending_time

    xdata =  np.linspace(0, end_t - start_t, end_t - start_t)  # time[:50]
    x_data = xdata[:, np.newaxis]
    # print(x_data)

    ydata = voltage[start_t:end_t]
    y_data = ydata[:, np.newaxis]
    # print(y_data)

    plt.figure(i)
    plt.plot(x_data, y_data, 'b-', label='data')
    plt.legend(fontsize=20)
    # plt.show()

    popt, pcov = curve_fit(func, x_data.ravel(), y_data.ravel())


    print(popt)

    plt.plot(x_data, func(x_data, *popt), 'r-',label='fit: a=%5.5f, b=%5.5f, c=%5.5f' % tuple(popt))
    plt.ylabel('voltage (v)', fontsize=24)
    plt.xlabel('time (ms)', fontsize=24)
    plt.title('Data set {}'.format(n),fontsize=24)
    plt.legend(fontsize=20)
    """
    plt.text(0, 4.15, 'a = {}'.format(popt[0]), fontsize=24)
    plt.text(0, 4.05, 'b = {}'.format(popt[1]), fontsize=24)
    plt.text(0, 3.95, 'c = {}'.format(popt[2]), fontsize=24)
    """
    if(plot):
        fig = plt.gcf()
        fig.set_size_inches(18.5, 12.5)
        fig.savefig('dataset{}.png'.format(n))
        #plt.show()
    return popt

if __name__ == "__main__":

    plot_original(False)
    popt_ret = [0, 0, 0]
    for i in range(10):
        ds_num = i
        start = ds_num*1000
        end = start+100
        popt_ret += fit_and_plot(i, start, end, ds_num+1)

    print("average values", popt_ret/10)