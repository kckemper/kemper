% [xdata, ydata] = spring_anim([0 0], [1 1], 0.25)
function [xdata, ydata] = spring_anim(s, e, r)
    v = e - s;
    length = sqrt(sum(v.^2));

    theta = atan2(v(2), v(1));
    R = [[cos(theta), -sin(theta)]; [sin(theta), cos(theta)]];

    data = [[0; 0], [0.25; 0], [0.3333; r], [0.4167; -r], [0.5833; r], [0.6667; -r], [0.75; 0], [1; 0]];

    data(1, :) = length * data(1, :);
    data = R * data;
    data = data + repmat(s', 1, 8);

    xdata = data(1, :);
    ydata = data(2, :);
end