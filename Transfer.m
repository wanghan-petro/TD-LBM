% STEP 2 = TRANSFER
% We adopt the "reception" point of view : we scan each (nx,ny,i) and look for the place where it comes from.
% We define the "boundary of the computational domain" as nx=1 or nx=Nx or ny=1 or ny=Ny

% For mass
for nx=1:Nx
    for ny=1:Ny
        for i=1:Q
            % to fill in
            ixd = nxsf(nx, ny, i);
            iyd = nysf(nx, ny, i);
            id = i_sf(nx, ny, i);
            F_a(nx,ny,i) = Fpost_a(ixd, iyd, id); % to fill in
        end
    end
end
CP='T1'; CheckPoints;                             % Check the construction of F_a

% For temperature, there are two parts
if IsWithHeatTransfer
    for nx=1:Nx
        for ny=1:Ny
            for i=1:Q_t
                ixd = nxst(nx, ny, i);
                iyd = nyst(nx, ny, i);
                id = i_st(nx, ny, i);
                type = SourceNodeType(nx, ny, i);
                switch id
                	case 2
                    	T_w = Tleft_a;
                    	q_w = qinleft;
                        dx = 0;
                        dy = 1;
                	case 3
                    	T_w = Tbottom_a;
                    	q_w = qinbottom;
                        dx = -1;
                        dy = 0;
                    case 4
                    	T_w = Tright_a;
                    	q_w = qinright;
                        dx = 0;
                        dy = -1;
                	case 1
                    	T_w = Ttop_a;
                    	q_w = qintop;
                        dx = 1;
                        dy = 0;
                end
                switch type
                    case 0
                        G_a(ixd,iyd,i) =  Gpost_a(nx, ny, id);
                    case 1
                        % on ne prend pas en compte une paroie qui se
                        % d�placerait parall�lement � elle-m�me.
                        G_a(ixd,iyd,id) = - Gpost_a(nx, ny, i) + 2*T_w.*W_t(i);
%                         tmp = (T_w + 0.75*T_a(ixd+dx,iyd+dy) - 0.125 * T_a(ixd+2*dx,iyd+2*dy))/1.625;
%                         for ii=1:Q_t
%                             if(ii ~= i)
%                                 tmp = tmp - G_a(ixd,iyd,ii);
%                             end
%                         end
%                         G_a(ixd,iyd,id) = tmp;
                    case 2
                        T_w = T_a(ixd,iyd) + Deltax_d * q_w / (2*lambda_d);
                        G_a(ixd,iyd,id) = - Gpost_a(nx, ny, i) + 2*T_w.*W_t(i);                        
                end
            end
        end
    end
end
