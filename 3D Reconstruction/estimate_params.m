function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.
[~, ~, V] = svd(P);
c = V(:, end);

c = c(1:3)./c(4);

p = [0, 0, 1;
     0, 1, 0;
     1, 0, 0];

P_dash = p * P(:, 1:3);

[Q_dash, R_dash] = qr(P_dash');
Q = p * Q_dash';
R = p * R_dash' * p;

K = R;
R = Q;

T = diag(sign(diag(K)));

K = K * T;
R = T * R;

if (round(det(R), 2) == -1)
    R = -R;
end

t = -R * c;