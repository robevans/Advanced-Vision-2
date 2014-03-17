function [ Planes, Assignments ] = plane_kmeans( points, planes_k, iterations, error_threshold )
%PLANE_KMEANS Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4
    error_threshold = 20000;
end

d_size = length(points);

P = rand(4, planes_k);

iterations_start = iterations;

Assignments = ones(length(points), 1);
Distances = zeros(length(points), 1);
%points = [points, ones(length(points), 1)];

while iterations > 0
    restart = false;
    
    dist = abs(points * P(1:3, :) + repmat(P(4, :), d_size, 1));
    [Distances, Assignments] = min(dist, [], 2);
    
    for i=1:planes_k,
        a = sum(Assignments == i) / d_size;
        fprintf('Percentage of points in plane %d : %.1f%%\n', i, a*100);
        if (a == 1.0 || a == 0.0) && planes_k > 1,
            P = rand(4, planes_k);
            restart = true;
            iterations = iterations_start;
            disp('Initial plane setup was bad - restarting');
        end
    end
    
    if restart
        continue;
    end
    
    for i=1:planes_k,
        plane_points = points(Assignments == i, :);
        if isempty(plane_points),
            continue
        end
        %plane_normal = P(:, i);
        %[plane, fit] = fitplane(plane_points);
        XYZ = plane_points;
        cm = mean(XYZ, 1);

        % subtract off the column means
        XYZ0 = bsxfun(@minus, XYZ, cm);
        [U, S, V] = svd(XYZ0, 0);
        n = V(:,3);
        n(4) = -cm * (n/norm(n));
        P(:, i) = n;
        %P(:, i) = null( plane_points, 'r');    
    end
    
    iterations = iterations - 1;
    
    if sum(Distances) > error_threshold && iterations == 0,
    P = rand(4, planes_k);
    iterations = iterations_start;
    fprintf('Error too large - restarting %f\n', sum(Distances));
    end
end

Planes = P;

fprintf('Total plane fitting error %f\n', sum(Distances));
fprintf('Total plane average fitting error %f\n', mean(Distances));

end

