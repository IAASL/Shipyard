function H = lpfilter(type, M, N, D0, n)
%LPFILTER Computes frequency domain lowpass filters.
%   h = LPFILTER(TYPE, M, N, D0, n) creates the transfer function of a lowpass filter, H, of the
%   specified TYPE and size (M-by-N). To view the filter as an image or mesh plot, it should be cnetered
%   using H = fftshilt(H).
%
%   Valid values for TYPE, D0, and n are:
% 
%   'ideal'    Ideal lowpass filter with cutoff frequency D0. n need not be supplied. D0 must be
%              positive.
%
%   'btw'      butterworth lowpass filter of order n, and cutoff D0. The default value for n is 1.0. D0
%              must be positive.
%
%   'gaussian' Gaussian lowpass filter with cutoff (standard deviation) D0. n need not be supplied. D0
%              must be positive.
%
%   H is of floating point class single. It is returned uncentered for consistency with filtering
%   function dftfilt. To view H as an image or mesh plot, it should be centered using Hc = fftshift(H).

% Use function dftuv to set up the meshgrid arrays needed for computing the required distances.
[U, V] = dftuv(M, N);

% Compute the distances D(U, V).
D = hypot(U, V);

% Begin filter computations.
switch type
    case 'ideal'
        H = single(D <= D0);
    case 'btw'
        if nargin == 4
            n = 1;
        end
        H = 1./(1+(D./D0).^(2*n));
    case 'gaussian'
        H = exp(-(D.^2)./(2*(D0^2)));
    otherwise
        error('Unknown filter type.')
end
    
end