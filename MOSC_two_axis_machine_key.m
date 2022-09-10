
%
% clear all;

k(1)=1; %1.5983
k(2)=1; %1.5954
k(3)=1; %16.2363
k(4)=1; %0.4870

t_sim = 6.36;

% Motor 
Un = 280; %V
wn = 1640*pi/30; %rad/s
Pn = 1.52e3; %W
Tn = 8.85; %Nm

In = 7.2; %A
Ra = 6.41; %Ohm
La = 23e-3; %H
PSI_M = Tn/In;
PSI_E = (Un-Ra*In)/wn;
J = (0.013*2); %kgm2
Ts = 0.001;%4e-4;
Tdelay = 2*Ts;

% System/process and measurement noise
rng('shuffle');
rand_seed_1 = round(rand*(2^32-1));
rand_seed_2 = round(rand*(2^32-1));
rand_seed_3 = round(rand*(2^32-1));
rand_seed_4 = round(rand*(2^32-1));

dia_max = 1e4;
domega_max = 2e3;
du_max = 1e6;
system_noise_level = 1e-2;
measurement_noise_level = 1e-2;

%2-sigma
w_i_a = (dia_max*system_noise_level/2)^2;
w_omega_m = (domega_max*system_noise_level/2)^2;
w_u_a = (du_max*system_noise_level/2)^2;
v_i_a = (In*measurement_noise_level/2)^2; % measurement

% Measurement offsets
w_offset = 0; % in percent of the nominal value
i_offset = 0.01; % in percent of the nominal value

% Identification errors in percent
k_conv_id_error = 0.01;
k_meas_i_id_error = 0.01;
k_meas_w_id_error = 0;
Ra_id_error = 0.01;
La_id_error = 0.01;
Tdealy_id_error = 0.01;
J_id_error = 0.01;

%
k_conv = 350;
k_meas_i = 10;

% Modulus optimum method (Kessler's method)
k_plant = 1/(Ra*(1+Ra_id_error)) * k_conv*(1+k_conv_id_error) * k_meas_i*(1+k_meas_i_id_error);
Tr = (La*(1+La_id_error))/(Ra*(1+Ra_id_error));
Kr = 1/2/k_plant/(Tdelay*(1+Tdealy_id_error));
Kp=Kr*Tr;
Ki=Kr;

% Symmetric(al) optimum method (Naslin's polynomial method, Kessler's method)
tau_MO_sum_of_small = Tdelay*(1+Tdealy_id_error);
k_meas_w = 5;
c_viscosity = Tn/wn*0.1;
k_plant_SO = (1/c_viscosity) * k_meas_w*(1+k_meas_w_id_error);
tau_SO_dominant = J*(1+J_id_error)/c_viscosity;
tau_SO_sum_of_small = 2 * tau_MO_sum_of_small;
alpha_speed = 7; % 4 produces critically damped system; 2 is the first hand choice; alpha = 4*zeta^2

T_reg_omega_SO = alpha_speed^2 * tau_SO_sum_of_small;
K_reg_omega_SO = tau_SO_dominant/alpha_speed^3/k_plant_SO/tau_SO_sum_of_small/tau_SO_sum_of_small;
kp_om = K_reg_omega_SO * T_reg_omega_SO;
ki_om = K_reg_omega_SO;

% Position controller
wr = 2*pi; % 1 Hz
no_of_turns = 3;
kp_pos = 13; % guessing and checking

% Heart (see http://mathworld.wolfram.com/HeartCurve.html)
t_heart = 0:0.02:t_sim;
frequency_heart = 1;
axis_A = (16*(power(sin(t_heart*2*pi*frequency_heart),3)))*0.125;
axis_A_init =X(1);
axis_B = ((13*cos(t_heart*2*pi*frequency_heart))-(5*cos(2*t_heart*2*pi*frequency_heart))-(2*cos(3*t_heart*2*pi*frequency_heart))-(cos(4*t_heart*2*pi*frequency_heart)))*0.125;
axis_B_init = Y(1); 

% axis_B(1);
% MOSC for axis A
% Note that (sin(x))^3 = (3*sin(x)-sin(3*x))/4
w1a = 1*2*pi*frequency_heart;
w2a = 3*2*pi*frequency_heart;
zeta1a = 0.01;
zeta2a = 0.01;
k1a = 2;
k2a = 2;

% MOSC for axis B
w1b = 1*2*pi*frequency_heart;
w2b = 2*2*pi*frequency_heart;
w3b = 3*2*pi*frequency_heart;
w4b = 4*2*pi*frequency_heart;


zeta1b = 0.01;
zeta2b = 0.01;
zeta3b = 0.01;
zeta4b = 0.01;

k1b = 2;
k2b = 2;
k3b = 2;
k4b = 2;

c = 0;
nVar= 4;


