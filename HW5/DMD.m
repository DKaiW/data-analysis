 function [X_DMD,X1]=DMD(X,videodata,lowrank)
clearvars -except X lowrank videodata singulvalues
%DMD
X1 = X(:,1:end-1);
X2 = X(:,2:end);

dt=videodata.Duration/videodata.NumFrames;

% lowrank=360;

[U, Sigma, V] = svd(X1,'econ');
Ulr=U(:,1:lowrank);
Slr=Sigma(1:lowrank,1:lowrank);
Vlr=V(:,1:lowrank);

S = Ulr' * X2 * Vlr*diag(1./diag(Slr));

[eV, D] = eig(S); % compute eigenvalues + eigenvectors
mu = diag(D); % extract eigenvalues
omega = log(mu)/dt;% eigenvalues in exp form

clearvars -except X lowrank videodata singulvalues X1 X2 Vlr Slr eV omega dt Nnum
%clear some variable since the memery would not be enough
Phi = X2*Vlr/Slr*eV;

y0=Phi\X1(:,1);

X_DMD=zeros(lowrank,videodata.NumFrames-1);

for i=1:videodata.NumFrames-1
   X_DMD(:,i)=y0.*exp(omega*dt*(i-1));
end

X_DMD=Phi*X_DMD;

end