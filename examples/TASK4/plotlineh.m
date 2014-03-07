% gets the point on a line across the window for sin(t)*r + cos(t)*c = d
% here we use the 0.25 scaled image
function [cr,cc] = plotlineh(t,d)

  sn = sin(t);
  cs = cos(t);
  tr = zeros(864,1);
  tc = zeros(864,1);
  count = 0;
  if abs(cs) < 0.1
    for c = 1 : 864
      r = (d - cs*c) / sn;
      if r > 0 & r < 577
        count = count + 1;
        tr(count) = r;
        tc(count) = c;
      end
    end
  else
    for r = 1 : 576
      c = (d - sn*r) / cs;
      if c > 0 & c < 865
        count = count + 1;
        tr(count) = r;
        tc(count) = c;
      end
    end
  end
  cr = tr(1:count);
  cc = tc(1:count);


