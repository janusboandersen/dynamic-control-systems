%% 
%
clc; clear all; close all;

%% PHYSICAL CONSTANTS
% 
m = 0.063;          % mass of drone in kg

% Inertias
Ixx = 5.828570000000000e-05;
Iyy = 7.169140000000000e-05;
Izz = 1.000000000000000e-04;

L = 6.00e-02;   % meter
%%
%
s = tf('s');    

G = (1/m)*(1/s^2);  % G(s), quadrotor-plant

Kp = 0.05;          % Proportional gain
Kd = 0.1;           % Derivative gain

PD = Kp + Kd*s;     % PD(s)-controller

Gcl = PD*G/(1+PD*G)   % G_cl(s) closed-loop system with control

setlatexstuff('latex');
figure;
step(Gcl); grid on; hold on;
yline(1.0, 'r--'); hold off;
title(['Stepresponse of quadrotor' newline ...
       '$K_p = $' num2str(Kp) ', $K_d = $' num2str(Kd)  ] ...
    , 'FontSize', 16, 'Interpreter', 'latex');
xlabel('Time, $t$', 'FontSize', 16, 'Interpreter', 'latex');
ylabel('Vertical position (meters)', 'FontSize', 16, 'Interpreter', 'latex');
legend({'Quadrotor vertical pos., $z(t)$', '$z_{ref}$'}, 'FontSize', 16, 'Interpreter', 'latex', 'location', 'southeast');

%%
%
stepinfo(G_cl)

%%
% drive the system with an offset sinusoid
t = 0:1/100:20;         % time vector
z_ref = 1+0.2*sin(2*t);	% control 
z_ref(end-200:end) = 0; % time offset
z_ref(1:200) = 0;       % landing
%lsim(Z, z_ref, t);

figure; 
lsim(Gcl, z_ref, t)
grid on; hold on;
plot(t, z_ref, 'r--'); hold off;
title(['Response of quadrotor driven by sinusoid' newline ...
       '$K_p = $' num2str(Kp) ', $K_d = $' num2str(Kd)  ] ...
    , 'FontSize', 16, 'Interpreter', 'latex');
xlabel('Time, $t$', 'FontSize', 16, 'Interpreter', 'latex');
ylabel('Vertical position (meters)', 'FontSize', 16, 'Interpreter', 'latex');
legend({'Quadrotor vertical pos.', '$z_{ref}(t)$'}, 'FontSize', 16, 'Interpreter', 'latex', 'location', 'south');
ylim([0 1.4])

%%
% Open the 1D linear simulink model
%% Tuned parameters for the nonlinear 1D model
%
Kp_tuned = 0.81;
Kd_tuned = 0.49;
PD_tuned = Kp_tuned + Kd_tuned*s;     % PD(s)-controller
G_cl_tuned = PD_tuned*G/(1+PD_tuned*G)   % G_cl,tuned(s) closed-loop system

%%
% Extract numerator and denom

char_eq = 1 + PD_tuned*G
pole(char_eq)

loop_gain_poly = [m Kd_tuned Kp_tuned]  %
roots(loop_gain_poly)
%%
% See a step

%% setlatexstuff
%
function [] = setlatexstuff(intpr)
% Sæt indstillinger til LaTeX layout på figurer: 'Latex' eller 'none'
% Janus Bo Andersen, 2019
    set(groot, 'defaultAxesTickLabelInterpreter',intpr);
    set(groot, 'defaultLegendInterpreter',intpr);
    set(groot, 'defaultTextInterpreter',intpr);
    set(groot, 'defaultGraphplotInterpreter',intpr); 

end