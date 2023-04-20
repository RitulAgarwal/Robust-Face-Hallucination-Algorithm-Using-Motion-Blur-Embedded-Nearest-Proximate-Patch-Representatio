% Generate random input data matrix V
V = rand(3, 5);

% Set parameters
k = 2;
max_iter = 5;

% Call my_nnmf function
[W, H, obj] = my_nnmf(V, k, max_iter);

% Display the results
disp("W:");
disp(W);
disp("H:");
disp(H);
disp("Objective function values:");
disp(obj);