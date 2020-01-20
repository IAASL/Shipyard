function H = hpfilter(type, M, N, D0, n)
%HPFILTER(TYPE, M, N D0, n) creates the transfer function of a highpass filter, H, of the specified TYPE
%and size (M-BY-N). Valid values for TYPE, D0, and n are:
%
%   'ideal'     Ideal HIGHPASS FILTER WITH CUTOFF FREQUENCY D0. n need not be supplied. D0 must be
%               positive.
%
%   'btw'       Butterworth highpass filter of order n, and cutoff D0. The default value for n is 1.0. D0
%               must be positive.
%
%   'gaussian'  Gaussian highpass filter with cutoff (standard deviation) D0. n ned not be supplied. D0
%               must be positive.
%
%   H is of floating point class single. It is returned uncertered for consistency with filtering
%   function dftfilt. To view H as an image or mesh plot, it should be centered using Hc = fftshift(H).
%
%   the transfer function Hhp of a highpass filter is 1 - Hlp, where Hlp is the transfer function of the
%   corresponding lowpass filter. Thus, we can use function lpfilter to generate highpass filters.

if nargin == 4
    n = 1; % Default value of n.
end

% Generate highpass filter.
Hlp = lpfilter(type, M, N, D0, n);
H = 1 - Hlp;
end