function [z,cost] = lp_power(lambda,q,c)

L_idx = 1;
U_idx = length(c);
% assert(L_idx < U_idx);
numIters = floor(log2(U_idx)+1);

for i = 1:numIters
    M_idx = floor((L_idx+U_idx)/2);
    
    if (L_idx == (U_idx-1))
%         assert(c(L_idx) < c(U_idx));
        slope = (c(U_idx) - c(L_idx))/(q(U_idx) - q(L_idx));
%         assert(slope > 0);
        if ((slope - lambda) >= 0)
            z = q(L_idx);
            cost = c(L_idx)-lambda*z;
        else
            z = q(U_idx);
            cost = c(U_idx)-lambda*z;
        end
        return
    elseif (L_idx == U_idx)
        z = q(M_idx);
        cost = c(M_idx)-lambda*z;
        return
    else
        Lslope = (c(M_idx) - c(M_idx-1))/(q(M_idx) - q(M_idx-1)) - lambda;
        Rslope = (c(M_idx+1) - c(M_idx))/(q(M_idx+1) - q(M_idx)) - lambda;

        if (Lslope <= 0 && Rslope >= 0)
            z = q(M_idx);
            cost = c(M_idx)-lambda*z;
            return 
        elseif (Lslope >= 0 && Rslope >= 0)
            U_idx = M_idx-1;
        elseif (Lslope <= 0 && Rslope <= 0)
            L_idx = M_idx+1;
        else
            error('Something wrong with bisection-type search');
        end
    end
end