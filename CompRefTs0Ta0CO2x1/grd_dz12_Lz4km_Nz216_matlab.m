Nz = 216; Lz = 4e3;
dz_inv = 12; dz_surf = 25;

xi = linspace(0,1,Nz);
% 15m through inversion, ~25m at surface
dz = min(150, 0.5*(dz_inv+dz_surf) - 0.5*(dz_inv-dz_surf)*tanh(15*(0.08-xi)) + 8e3*max(0,xi-0.77).^3 );

% 250m free trop, ~75m at surface
%%dz = 165 - 85*tanh(15*(0.2-xi)) + 1e4*max(0,xi-0.71).^3;

% sum grid spacing to produce vertical grid (zi_plus -- interfaces,
% z -- centers)
zi_plus = cumsum(dz); % height at interfaces above grid cells
z = [zi_plus(1)/2 0.5*(zi_plus(1:end-1)+zi_plus(2:end))];

disp(sprintf( ...
    'total grid height: %6.3f km,  target height, %6.3f km', ...
    sum(dz)/1e3,Lz/1e3))

if abs(sum(dz)-Lz)<0.1*Lz
  disp(['Close enough to target height.  Maintaining specified grid ' ...
        'spacing'])

  clf
  subplot(221); plot(xi,dz); grid;
  subplot(222); plot(zi_plus(1:end-1),dz(2:end)./dz(1:end-1),'-o')
  subplot(212); plot(cumsum(dz),dz,'-o'); grid

else
  disp(['Stretch grid to meet target height.  This modifies grid spacing.']);

  % modify average grid spacing to put model top at specified height, Lz
  dznew = dz*Lz/sum(dz);
  zi_plus = cumsum(dznew); % height at interfaces above grid cells
  z = [zi_plus(1)/2 0.5*(zi_plus(1:end-1)+zi_plus(2:end))];

  clf
  subplot(221); plot(xi,dz,xi,dznew); grid
  subplot(222); plot(zi_plus(1:end-1),dznew(2:end)./dz(1:end-1),'-o')
  subplot(212); plot(cumsum(dz),dz,'-',cumsum(dznew),dznew,'o-'); grid

end
% $$$ % modify average grid spacing to put model top at specified height, Lz
% $$$ dznew = dz*Lz/sum(dz);
% $$$ zi_plus = cumsum(dznew); % height at interfaces above grid cells
% $$$ z = [zi_plus(1)/2 0.5*(zi_plus(1:end-1)+zi_plus(2:end))];
% $$$ 
% $$$ disp(sprintf( ...
% $$$     'total grid height: %4.1f km,  target height, %4.1f km', ...
% $$$     sum(dz)/1e3,Lz/1e3))
% $$$ if abs(sum(dz)-Lz)>0.1*Lz
% $$$   disp(sprintf( ...
% $$$       'total grid height, %4.1 km, is far from target, %4.1 km', ...
% $$$       sum(dz)/1e3,Lz/1e3))
% $$$ end
% $$$ 
% $$$ subplot(121); plot(xi,dz,xi,dznew); 
% $$$ subplot(122); plot(cumsum(dz),dz,'-',cumsum(dznew),dznew,'o-')
% $$$ 
% $$$ 
% $$$ format bank; disp(z(1:end)')
