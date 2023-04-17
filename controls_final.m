%% Rlocus
num = [1];
den = [1 11 10 0];
rlocus (num,den);
sgrid;
%%
figure;
G = tf(num,den);
step(G);

%%
% Define the plant transfer function
num = [1];
den = [1 11 10 0];
G = tf(num, den);

% Define the range of K values to test
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

    % Check if the overshoot and maximum steering input constraints are satisfied
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
fprintf('Rise time: %.2f\n', best_rise_time);

% Plot the step response of the closed-loop system with the optimal K value
Gc_opt = tf(best_K, 1);
sys_cl_opt = feedback(G*Gc_opt, 1);
step(sys_cl_opt);


