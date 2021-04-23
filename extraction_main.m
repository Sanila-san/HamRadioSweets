## This code calculates extracted reflection and transmission coefficients 
## of unknown device connected to 2 known or unknown devices. One need to 
## measure the following networks: X+Y, X+Z, Y+Z, assuming X is DUT, Y and Z
## are other devicesused for service purposes only. Both transmission and 
## reflection coefficients should be measured. Originally, this code was created
## for calculation of calibration coefficients of the coaxial waveguide adapters 
## using 2 other compatible adapters. 
## --------------
## Created by Alex Savochkin on 20th of April, 2021
## Lab 113, Department 11, Research dept. 1, VNIIFTRI

clear all; clc; c = 299792458; % скорость света в вакууме, м/с

## Enter correct filename of each S2P-files.
## Here assumed that X - DUT we need to calibrate, Y and Z - auxiliary DUTs

unknownDeviceFilename = 'XY_A.s2p'; 
knownDeviceFilename_1 = 'XZ_B.s2p'; 
knownDeviceFilename_2 = 'YZ_C.s2p';

[F_u S11_u S21_u S12_u S22_u] = VreadS2P(unknownDeviceFilename);
[F_1 S11_1 S21_1 S12_1 S22_1] = VreadS2P(knownDeviceFilename_1);
[F_2 S11_2 S21_2 S12_2 S22_2] = VreadS2P(knownDeviceFilename_2);

unitMatrix = [1 1 0; 1 0 1; 0 1 1];
minusUnitMatrix = [1 1 0; 1 0 1; 0 1 1];

measurementsMatrixS21 = [S21_u'; S21_1'; S21_2'];
measurementsMatrixS12 = [S12_u'; S12_1'; S12_2'];

measurementsMatrixS21db = [10*log10(abs(S21_u))'; 10*log10(abs(S21_1))'; 10*log10(abs(S21_2))'];
measurementsMatrixS12db = [10*log10(abs(S12_u))'; 10*log10(abs(S12_1))'; 10*log10(abs(S12_2))'];

measurementsMatrixS11 = [(S11_u)'; (S11_1)'; (S11_2)'];
measurementsMatrixS22 = [(S22_u)'; (S22_1)'; (S22_2)'];

S21_partial = unitMatrix^(-1) * measurementsMatrixS21;
S12_partial = unitMatrix^(-1) * measurementsMatrixS12;

S21_partialdb = unitMatrix^(-1) * measurementsMatrixS21db;
S12_partialdb = unitMatrix^(-1) * measurementsMatrixS12db;

S11_partial = minusUnitMatrix^(-1) * measurementsMatrixS11;
S22_partial = minusUnitMatrix^(-1) * measurementsMatrixS22;

##This is test piece of code for data filtration, it actually doesn't work
##
##clip = F_u > 13.6e9 & F_u < 19.35e9;
##
##S11_clip = S11_partial([clip, clip, clip]');
##S22_clip = S22_partial(clip');
##S21_clip = S21_partialdb(clip');
##S12_clip = S12_partialdb(clip');

##F_clip = F_u(clip)

logdate = datestr(now(), 30);
filenameTSdut = cstrcat('Calibration_data_DUT_', unknownDeviceFilename, logdate, ".txt");
filenameTSaux1 = cstrcat('Calibration_data_AuxDevice-1_', knownDeviceFilename_1, logdate, ".txt");
filenameTSaux2 = cstrcat('Calibration_data_AuxDevice-2_', knownDeviceFilename_1, logdate, ".txt");

dlmwrite(filenameTSdut, [F_u abs(S11_partial(1,:))' abs(S21_partialdb(1,:))' abs(S12_partialdb(1,:))' abs(S11_partial(1,:))'], '\t');
dlmwrite(filenameTSaux1, [F_u abs(S11_partial(2,:))' abs(S21_partialdb(2,:))' abs(S12_partialdb(2,:))' abs(S11_partial(2,:))'], '\t');
dlmwrite(filenameTSaux2, [F_u abs(S11_partial(3,:))' abs(S21_partialdb(3,:))' abs(S12_partialdb(3,:))' abs(S11_partial(3,:))'], '\t');


## This part is for visual verification purposes
## It helps to figure out if calculations are correct

## ---NOTE---
## Select section of code and press F9 in Octave to plot figure without
## recalculation of the data. This feature can be used for determining 
## the useful frequency range of the data.

##Plot TRANSMISSION coefficient in dB
figure('name', 'Transmission coefficient')
plot(F_u./1e6, S21_partialdb(1,:), "LineWidth", 3)
title('Transmission coefficients over frequency');
grid on; hold on;
plot(F_u./1e6, S21_partialdb(2,:), "LineWidth", 3)
hold on;
plot(F_u./1e6, S21_partialdb(3,:), "LineWidth", 3)
hold on;
plot(F_u./1e6, 10*log10(abs(S21_u)), "LineWidth", 2, "Color", "red", "--")
hold on;
plot(F_u./1e6, 10*log10(abs(S21_1)), "LineWidth", 2, "Color", "green", "-.")
hold on;
plot(F_u./1e6, 10*log10(abs(S21_2)), "LineWidth", 2, "Color", "blue", ":")
legend('DUT', 'Adapter-1', 'Adapter-2', 'DUT + Adapter-1', 'DUT + Adapter-2', 'Adapter-1 + Adapter-2');
xlabel('Frequenxy, MHz');
ylabel('S21, dB');

##Plot REFLECTION coefficient in LinMag
figure('name', 'Reflection coefficient')
plot(F_u./1e6, 10*log10(abs(S11_partial(1,:))), "LineWidth", 3)
title('Reflection coefficients over frequency');
grid on; hold on;
plot(F_u./1e6, 10*log10(abs(S11_partial(2,:))), "LineWidth", 3)
hold on;
plot(F_u./1e6, 10*log10(abs(S11_partial(3,:))), "LineWidth", 3)
hold on;
plot(F_u./1e6, 10*log10(abs(S11_u)), "LineWidth", 1, "Color", "red")
hold on;
plot(F_u./1e6, 10*log10(abs(S11_1)), "LineWidth", 1, "Color", "green")
hold on;
plot(F_u./1e6, 10*log10(abs(S11_2)), "LineWidth", 1, "Color", "blue")
legend('DUT', 'Adapter-1', 'Adapter-2', 'DUT + Adapter-1', 'DUT + Adapter-2', 'Adapter-1 + Adapter-2');
xlabel('Frequenxy, MHz');
ylabel('S11, dB');


##Plot REAL PART of the REFLECTION coefficient 
figure('name', 'Reflection coefficient')
plot(F_u./1e6, real(S11_partial(1,:)), "LineWidth", 3)
title('Reflection coefficients over frequency');
grid on; hold on;
plot(F_u./1e6, real(S11_partial(2,:)), "LineWidth", 3)
hold on;
plot(F_u./1e6, real(S11_partial(3,:)), "LineWidth", 3)
hold on;
plot(F_u./1e6, real(S11_u), "LineWidth", 1, "Color", "red")
hold on;
plot(F_u./1e6, real(S11_1), "LineWidth", 1, "Color", "green")
hold on;
plot(F_u./1e6, real(S11_2), "LineWidth", 1, "Color", "blue")
legend('DUT', 'Adapter-1', 'Adapter-2', 'DUT + Adapter-1', 'DUT + Adapter-2', 'Adapter-1 + Adapter-2');
xlabel('Frequenxy, MHz');
ylabel('S11, Real part');

##Imaginary part
##Plot IMAGINARY PART of the REFLECTION coefficient
figure('name', 'Reflection coefficient')
plot(F_u./1e6, imag(S11_partial(1,:)), "LineWidth", 3)
title('Reflection coefficients over frequency');
grid on; hold on;
plot(F_u./1e6, imag(S11_partial(2,:)), "LineWidth", 3)
hold on;
plot(F_u./1e6, imag(S11_partial(3,:)), "LineWidth", 3)
hold on;
plot(F_u./1e6, imag(S11_u), "LineWidth", 1, "Color", "red")
hold on;
plot(F_u./1e6, imag(S11_1), "LineWidth", 1, "Color", "green")
hold on;
plot(F_u./1e6, imag(S11_2), "LineWidth", 1, "Color", "blue")
legend('DUT', 'Adapter-1', 'Adapter-2', 'DUT + Adapter-1', 'DUT + Adapter-2', 'Adapter-1 + Adapter-2');
xlabel('Frequenxy, MHz');
ylabel('S11, Imaginary part');
