clc
clear

# change here - sampl_freq and total_time
sample_freq = 1000      # sample_freq is 1000 Hz
total_time = 10         # total time is 10 seconds

total_sample_size = (total_time*sample_freq);

#! you may have to install these packages before by using "pkg install -forge" command ....... !!!!
#{
pkg install -forge signal
pkg install -forge io

#}
pkg load io
pkg load signal
output_precision(15);

B = xlsread ('Output_voltage.xlsx');
# B_col2 is the y-axis variable
B_col2 = B(:,2);

#*..............additional properties.....................................
#{
xlim ([48823.37693, 48823.37704]);
ylim ([-0.20, 0.20]);
xlim("manual");
ylim("manual");
#}
...........................................................................



# x is the x-axis variable
x1 = linspace(0,10,total_sample_size);
x = transpose(x1);

#* .................... plotting figure 1......................................

# plot(B_col1, B_col2,"linewidth",2)
B_col2_scalled = B_col2 ./ 1;
plot(x, B_col2_scalled);
# axis ([0 10 -0.2 0.25])

#{

plot(B_col1, B_col2, "linewidth",2)
plot(x, B_col2, "linewidth",1, 'rx-')
axis ([0 10 -0.2 0.25])
plot(x, B_col2, "linewidth",1, 'k-')

#}

#* ...................................................................


#*...........................axis disply properties.........................
title ("Thermopile Output Voltage");
xlabel ("Time (s)");
ylabel ("Voltage(V)");
set(gca, 'linewidth', 0.5, "fontsize", 25);
ylim ([0, 0.01]);
grid on;
grid minor;

#*........................................................................


#*............... apply high pass filter -  figure 02........................................

sf2 = sample_freq/2;
# fc = cutoff freq
fc = 10;
[b,a]=butter (2, fc/sf2, "high")
filtered = filter(b, a, B_col2_scalled);

figure(2);
plot(x, filtered, "linewidth",1)
ylim ([-1, 2.5]);
xlim ([0.2, 10]);
title ("Output Voltage(filtered) - noise voltage");
xlabel ("Time (s)");
ylabel ("Voltage(V)");
set(gca, 'linewidth', 0.5, "fontsize", 25);
set(gca, 'xtick', [0.2: 1: 10]);
grid on;
grid minor;

#* ...........................................................................

#*....................mean or dc offset .......................

#mean_y = mean(B_col2_scalled)
#stdDiv_y = std (B_col2_scalled)
#variance_y = var(B_col2_scalled)
#........................................................................

#mean_ya = mean(filtered)



# ...............................spectral analysis...........................

# selecting the range of x and y axis for removing filter effect .............
removed_size = 0.2*sample_freq;
removed_sizep1 = removed_size+1;
x_set = x(removed_sizep1:total_sample_size);
filtered_set = filtered(removed_sizep1:total_sample_size);
#new total sample size = total_sample_size-200, for removing the filter edge effect
total_sample_sizeSet = total_sample_size-removed_size;

figure(3); # figure 3 filtered - edge effect removed
plot(x_set, filtered_set, "linewidth",0.5)
ylim ([-0.1, 0.1]);
xlim ([0.2, 2]);
title ("Thermopile Output Voltage(filtered) - noise voltage");
xlabel ("Time (s)");
ylabel ("Voltage (V)");
set(gca, 'linewidth', 0.5, "fontsize", 25);
set(gca, 'xtick', [0.2: 0.2: 2]);
grid on;
grid minor;


# figure 4 is the PSD
figure(4);
[spectra,spec_freq] = pwelch(filtered_set,hamming(total_sample_sizeSet),0.75,total_sample_sizeSet,sample_freq); 
plot(spec_freq,spectra, "linewidth",1);
grid on;
grid minor;
title ("Power Spectral Density (PSD)");
xlabel ("Frequency (Hz)");
ylabel ("PSD (dB / Hz)");
set(gca, 'linewidth', 0.5, "fontsize", 25);



#....................figure 5.... histogram............................................
figure(5);
historam_bins = 50;
Histogram_y = hist(filtered_set, historam_bins);
max_n=max(filtered_set);
min_n=min(filtered_set);
hcol_size = (max_n-min_n)/historam_bins;
#his_x = linspace(0,10,total_sample_size);
his_xT = linspace(min_n,max_n,historam_bins);
his_x = transpose(his_xT);
plot(his_x,Histogram_y, "linewidth",2);
title ("Measurement Data Distribution");
xlabel ("Value (V)");
ylabel ("Number of Occurences");
set(gca, 'linewidth', 0.5, "fontsize", 25);


#.................necessary data values
alpha = 0.9;
n=length (filtered_set);
Sn =std(filtered_set);
mean_n = mean(filtered_set)
stdDiv_n = std(filtered_set)
variance_n = var(filtered_set)
conf_interval = erfinv(alpha)*sqrt(2)*Sn/sqrt(n)

#....................................................histogram other version..........
figure(6)
hist(filtered_set, historam_bins);
title ("Histogram Distribution");
xlabel ("Value (V)");
ylabel ("Number of Occurences");
set(gca, 'linewidth', 0.5, "fontsize", 25);



#..................................psd other version.....................
figure(7)
pwelch(filtered_set,hamming(total_sample_sizeSet),0.75,total_sample_sizeSet,sample_freq); 
title ("Power Spectral Density (PSD)");
xlabel ("Frequency (Hz)");
ylabel ("PSD (dB / Hz)");
set(gca, 'linewidth', 0.5, "fontsize", 25);
grid on;
grid minor;



#....................sigma,3 sigma..................
figure(8)
plot(x_set, filtered_set, "linewidth",0.5)
ylim ([-0.00007, 0.00007]);
xlim ([0.2, 2]);
title ("Noise voltage "); #Thermopile Output Voltage(filtered)
xlabel ("Time (s)");
ylabel ("Voltage (V)");
set(gca,'linewidth', 0.5, "fontsize", 25);
set(gca, 'xtick', [0.2: 0.2: 2]);

grid on;
grid minor;
#second plot
y_sigma = stdDiv_n*(x_set).^(0);
y_nsigma = (-1)*stdDiv_n*(x_set).^(0);

y_2sigma = (2)*stdDiv_n*(x_set).^(0);
y_2nsigma = (-2)*stdDiv_n*(x_set).^(0);

y_3sigma = (3)*stdDiv_n*(x_set).^(0);
y_3nsigma = (-3)*stdDiv_n*(x_set).^(0);

hold
plot(x_set,y_sigma,"linewidth",1, 'k--')
plot(x_set,y_nsigma,"linewidth",1, 'k--')

plot(x_set,y_2sigma,"linewidth",1, 'r--')
plot(x_set,y_2nsigma,"linewidth",1, 'r--')

plot(x_set,y_3sigma,"linewidth",1, 'm--')
plot(x_set,y_3nsigma,"linewidth",1, 'm--')

