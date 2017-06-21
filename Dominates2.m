function b=Dominates2(x,y,option)

    if isstruct(x);x=x.Cost;end
    if isstruct(y);y=y.Cost;end
    if nargin<3;option='min';end
    if strcmp(option,'min');b=all(x<=y) && any(x<y);return;end
    if strcmp(option,'max');b=all(y<=x) && any(y<x);return;end
    x_max=x(option);
    y_max=y(option);
    x_min=x;
    x_min(option)=[];
    y_min=y;
    y_min(option)=[];
    b=(all(x_min<=y_min) && all(y_max<=x_max)) &&  (any(x_min<y_min)|| any(y_max<x_max));
    
end