% TEST -- test of some features of the wavekit toolbox

function test(v)

if nargin == 0, v = 0; end

N = 256;
[h,g]=wavecoef('coi',30);
x = (0:1/(N-1):1)';
f = sin(sqrt(1 ./ abs(x-.5)));
w = fwt1(f,h,g);
check(norm(f-ifwt1(w,h,g),inf),v,'fwt1')

wp = bestbase(wpa1(f,h,g));
check(norm(f-wps1(wp,h,g)),v,'wpa1')

N = 32;
[h,g]=wavecoef('dau',10);
x = (0:1/(N-1):1)';
f = sin(sqrt(1 ./ abs(x-.5)));
w = fwt1ns(f,h,g);
[b,a]=nsexampl(9,N,h,g,1);
p1 = ifwt1ns(nsmult(b,w),h,g);
p2 = a*f;
check(norm(p1-p2,inf),v,'fwt1ns')

w = wavbase2(wpa2(a,h,g));
check(norm(b-sum(w.wp .* double(w.sel),3),inf),v,'wpa2')

w = bestbas2(w);
check(norm(a-wps2(w,h,g)),v,'bestbas2')




function check(y,v,s)

if abs(y) > 1e-10,
    disp(['The error is too large, something has gone wrong?!', ' (', s, ')'])
end
if v,
    disp(y)
end
