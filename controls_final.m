%%% Control Systems Final 
% Josh Colvis, Kyle Morgan, Ben Wagner
clear;
%% Rlocus
num = [1];
den = [1 11 10 0];
rlocus (num,den);
sgrid;
%% Step Plot
figure;
G = tf(num,den);
step(G);

%% Step Response Graphs and Gain Values
% Gain values to test
K_values = 0:0.05:108;

best_K = 0;
best_rise_time = Inf;

for K = K_values
    Gc = tf(K, 1);
    sys_cl = feedback(G*Gc, 1); % closed-loop transfer function with proportional control

    % stepinfo() function creates a data structure with calculations for
    % overshoot and rise time needed later on
    step_info = stepinfo(sys_cl);

    if step_info.Overshoot <= 10 && step_info.Peak <= 4 % checking if lane overshoot and steering angle are acceptable
        if step_info.RiseTime < best_rise_time % Checking if new time is better
            best_rise_time = step_info.RiseTime;
            best_K = K;
        end
    end
end

% Printing statements for results
fprintf('Optimal K value: %.2f\n', best_K);
fprintf('Rise time: %.2f s\n', best_rise_time);

% Step response plot with best gain (K) value found
Gc_opt = tf(best_K, 1);
sys_cl_opt = feedback(G*Gc_opt, 1);
step(sys_cl_opt);
fprintf("Max steering angle: %.2f degrees\n",step_info.Peak)

%% Bode Plot
figure
bode(num,den);
[mag, phase, wout] = bode(tf(num,den), logspace(-1,1,1000));
magdb = 20*log10(mag);
for i = 1:1000
    if (ceil(magdb(1,1,i)) == -3)
        bandwidth = wout(i);
        break;
    end
end

fprintf("Bandwidth: 0-%.2f rad/s\n",bandwidth)
