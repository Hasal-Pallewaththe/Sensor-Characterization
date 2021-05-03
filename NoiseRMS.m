figure(1);
hold;


#x_val =0:0.1:10000;
#x_cutoff = 6634;

function y=f(x_val)
x_cutoff = 6634;
n=2.0513e-15;
y= n.*((1./(1.+(x_val./x_cutoff).*(x_val./x_cutoff))));
#y= (-146.87 +10.*log10((1./(1.+(x_val./x_cutoff).*(x_val./x_cutoff)))));
#[q, ier, nfun, err] = quad("y", 0, 10000);
endfunction

a = quad("f",0,6634);
#y=(1./(1.+(x_val./x_cutoff).*(x_val./x_cutoff)));


x1 = 0:0.1:6634;
y1=(a)*x1.^(0);
plot(x1,y1, "linewidth",2);
title ("Noise RMS - Cutoff Frequency 6.634kHz");
xlabel ("Frequency (Hz)");
ylabel ("Noise RMS");
set(gca, 'linewidth', 0.5, "fontsize", 25);
grid on;
grid minor;

#second plot...............
x_cutoff = 6634;
y2= (-146.87 +10.*log10((1./(1.+(x1./x_cutoff).*(x1./x_cutoff)))));
plot(x1,y2, "linewidth",2);