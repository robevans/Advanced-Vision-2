% gets all points (c,r) on a line that crosses the image (of size size_img(2))
% for sin(t)*r + cos(t)*c = d
function [cr,cc] = plotline3(t,d, size_img)

  sn = sin(t);
  cs = cos(t);
  tr = zeros(size_img(1),1);
  tc = zeros(size_img(1),1);
  count = 0;
  if abs(cs) < 0.1
    for c = 1 : size_img(1)+1            % generate by columns
      r = (d - cs*c) / sn;
      if r > 0 & r < size_img(2)+1
        count = count +1;
        tr(count) = r;
        tc(count) = c;
      end
    end
  else
    for r = 1 : size_img(2)+1            % generate by rows
      c = (d - sn*r) / cs;
      if c > 0 & c < size_img(1)+1
        count = count +1;
        tr(count) = r;
        tc(count) = c;
      end
    end
  end
  cr = tr(1:count);
  cc = tc(1:count);


