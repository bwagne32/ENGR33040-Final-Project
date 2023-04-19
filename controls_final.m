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
% Gain values
K_values = 0:0.1:100;

% Initialize variables to store the best K and corresponding rise time
best_K = 0;
best_rise_time = Inf;

% Iterate over the K values and compute the step response characteristics
for K = K_values
    % Define the closed-loop transfer function with proportional control
    Gc = tf(K, 1);
    sys_cl = feedback(G*Gc, 1);

    % Compute the step response characteristics
    step_info = stepinfo(sys_cl);

    % Checking overshoot and maximum steering input
    if step_info.Overshoot <= 10 && step_info.Peak <= 4
        % If the constraints are satisfied, check if the rise time is the smallest so far
        if step_info.RiseTime < best_rise_time
            best_rise_time = step_info.RiseTime;
            best_K = K;
        end
    end
end

% Print the optimal K value and the corresponding rise time
fprintf('Optimal K value: %.2f\n', best_K);
fprintf('Rise time: %.2f s\n', best_rise_time);

% Plot the step response of the closed-loop system with the optimal K value
Gc_opt = tf(best_K, 1);
sys_cl_opt = feedback(G*Gc_opt, 1);
step(sys_cl_opt);
fprintf("Max steering angle: %.2f degrees\n",step_info.Peak)

%% Bode Plot
figure
bode(num,den);
fprintf("Bandwidth: %f\nCutoff: ",bandwidth(Gc))




