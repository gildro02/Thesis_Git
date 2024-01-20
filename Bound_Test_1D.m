B=10;
%a=exp(2*pi*1i*rand(B,1));%.*exp(-(1/2)*sqrt((1:B).'));%+1i*[0;ones(B-2,1)]; % k=0 to B
%a=[0.707671873258695 + 0.706541237153593i;0.988238403497549 + 0.152921083741304i;-0.249817202634132 + 0.968293016223941i;-0.411632223458529 + 0.911350049437968i;-0.568871246227187 - 0.822426595639955i;0.963616145197972 - 0.267289963735642i;0.919568728484166 - 0.392929196667815i;-0.965195103437267 + 0.261530901234871i;0.0597903158092206 + 0.998210958733390i;0.0872124228383627 - 0.996189737601559i];
a=[-0.646641616810157 - 0.762793956064904i,0.877812699563756 - 0.479004033891773i,0.0401582335407562 + 0.999193332783444i,0.816802514387931 + 0.576917370590931i,-0.308579375282474 - 0.951198596061978i,0.375659048440682 + 0.926757939984677i,-0.839511784037794 - 0.543341480527376i,0.805090157386554 - 0.593152458040337i,0.780834669228819 + 0.624737720431799i,-0.400828934416310 - 0.916152915912341i].';
a_symm_1B=[conj(flip(a(1:end))); 1 ;a];

k_symm_1B=-B:B;
k_half_1B=0:B;
k_symm_2B=-2*B:2*B;
k_half_2B=0:2*B;

%seed_hat=exp(1i.*(1:(B*3/5)).').*exp(-((1:(B*3/5)).^(1/4).'));
%{
seed_hat=exp(-((1:(B)).^(1/2).'))
[rho_hat_symm_1B_partial,rho_func]=Generate_Rho_Squared(seed_hat);
rho_hat_symm_2B=[zeros(2*B-2*length(seed_hat),1);
    rho_hat_symm_1B_partial;
    zeros(2*B-2*length(seed_hat),1)];
%}
f_vec=logspace(log10(500*B),log10(10*B),40).';
%f=logspace(-4,-2,40);
%f=logspace(-3,-20,20).';
bound=zeros(length(f_vec),1);
err_squared_good=zeros(length(f_vec),1);
err_squared_bad=zeros(length(f_vec),1);
dist_from_circ=zeros(length(f_vec),1);
delta_kappa=zeros(length(f_vec),1);
for f_index=1:length(f_vec)
%temp=exp(1i*(1:2*B).'./(100*B));
%temp=ones(2*B,1);
%temp= exp(-(abs(1:2*B)).^(1/50).')*0+ones(2*B,1)+0.5*i*exp(-(abs(1:2*B)).^(0.01).');
%temp = ones(2*B,1) + 3i.*ones(2*B,1);
temp=[0.00195583374369666 + 0.00530869159003379i;0.00195583374369666 + 0.00474988194897760i;0.00195583374369666 + 0.00419107230792141i;0.00195583374369666 + 0.00363226266686522i;0.00195583374369666 + 0.00307345302580903i;0.00195583374369666 + 0.00251464338475285i;0.00195583374369666 + 0.00195583374369666i;0.00195583374369666 + 0.00139702410264047i;0.00195583374369666 + 0.000838214461584282i;0.00195583374369666 + 0.000279404820528094i;0.00195583374369666 - 0.000279404820528094i;0.00195583374369666 - 0.000838214461584282i;0.00195583374369666 - 0.00139702410264047i;0.00195583374369666 - 0.00195583374369666i;0.00195583374369666 - 0.00251464338475285i;0.00195583374369666 - 0.00307345302580903i;0.00195583374369666 - 0.00363226266686522i;0.00195583374369666 - 0.00419107230792141i;0.00195583374369666 - 0.00474988194897760i;0.00195583374369666 - 0.00530869159003379i]...
    .*exp(1i*(rand(2*B,1)).^0.2./f_vec(f_index))*3;
%temp=[0.00195583374369666 + 0.00530869159003379i;0.00195583374369666 + 0.00474988194897760i;0.00195583374369666 + 0.00419107230792141i;0.00195583374369666 + 0.00363226266686522i;0.00195583374369666 + 0.00307345302580903i;0.00195583374369666 + 0.00251464338475285i;0.00195583374369666 + 0.00195583374369666i;0.00195583374369666 + 0.00139702410264047i;0.00195583374369666 + 0.000838214461584282i;0.00195583374369666 + 0.000279404820528094i;0.00195583374369666 - 0.000279404820528094i;0.00195583374369666 - 0.000838214461584282i;0.00195583374369666 - 0.00139702410264047i;0.00195583374369666 - 0.00195583374369666i;0.00195583374369666 - 0.00251464338475285i;0.00195583374369666 - 0.00307345302580903i;0.00195583374369666 - 0.00363226266686522i;0.00195583374369666 - 0.00419107230792141i;0.00195583374369666 - 0.00474988194897760i;0.00195583374369666 - 0.00530869159003379i]...
%    .*exp(1i*(0.8*ones(2*B,1)).^0.3./f_vec(f_index).^2)*3;
%temp=[0.00195583374369666 + 0.00530869159003379i;0.00195583374369666 + 0.00474988194897760i;0.00195583374369666 + 0.00419107230792141i;0.00195583374369666 + 0.00363226266686522i;0.00195583374369666 + 0.00307345302580903i;0.00195583374369666 + 0.00251464338475285i;0.00195583374369666 + 0.00195583374369666i;0.00195583374369666 + 0.00139702410264047i;0.00195583374369666 + 0.000838214461584282i;0.00195583374369666 + 0.000279404820528094i;0.00195583374369666 - 0.000279404820528094i;0.00195583374369666 - 0.000838214461584282i;0.00195583374369666 - 0.00139702410264047i;0.00195583374369666 - 0.00195583374369666i;0.00195583374369666 - 0.00251464338475285i;0.00195583374369666 - 0.00307345302580903i;0.00195583374369666 - 0.00363226266686522i;0.00195583374369666 - 0.00419107230792141i;0.00195583374369666 - 0.00474988194897760i;0.00195583374369666 - 0.00530869159003379i]...
%    +f(index)/(5e4*B)*(rand(2*B,1)+1i*rand(2*B,1));
rho_hat_symm_2B_non_normalized =[conj(flip(temp)); 1/(2*pi); temp];
rho_hat_symm_2B_temp=(1/(2*pi)) * (1/abs(rho_hat_symm_2B_non_normalized(k_symm_2B==0)))...
    * rho_hat_symm_2B_non_normalized;
rho_func_temp = @(x) real(rho_hat_symm_2B_temp.'*exp(1i*x'*k_symm_2B).');

t=-pi:1e-4:pi;
min_rho_func=min(rho_func_temp(t));
rho_hat_symm_2B =rho_hat_symm_2B_temp;
rho_hat_symm_2B(k_symm_2B==0)=rho_hat_symm_2B(k_symm_2B==0)-min(min_rho_func,0); %make >=0
rho_hat_symm_2B=rho_hat_symm_2B.*(1/(2*pi))*(1/rho_hat_symm_2B(k_symm_2B==0)); %renormalize
rho_func = @(x) real(rho_hat_symm_2B.'*exp(1i*x.'*k_symm_2B).');

%{
close all
figure
t=-pi:1e-4:pi;
plot(t,rho_func(t))
xlabel("$\theta$","interpreter","latex","FontSize",20);
ylabel("$\rho(\theta)$","interpreter","latex","FontSize",20);
%}

rho_hat_symm_1B=rho_hat_symm_2B(-B<=k_symm_2B & k_symm_2B<=B);
rho_hat_half_2B=rho_hat_symm_2B(0<=k_symm_2B);
W=(1/sqrt(2*B+1))*dftmtx(2*B+1);

h=(1/(2*B+1))*(k_half_2B.'.*[0 ; conj(flip(rho_hat_half_2B(2:end)))]...
    +(2*B+1-k_half_2B.').*rho_hat_half_2B);
C_h=circul(h);
T=toeplitz(conj(rho_hat_half_2B));
M_1=2*pi*a_symm_1B.*rho_hat_symm_1B;
M_2_T=2*pi*diag(a_symm_1B)*T*diag(conj(a_symm_1B));
M_2_C=2*pi*diag(a_symm_1B)*C_h*diag(conj(a_symm_1B));
P_a_symm_1B=abs(a_symm_1B).^2;
a_symm_1B_wave=a_symm_1B./sqrt(P_a_symm_1B);

M_2_T_mathcal=(1/(2*pi))*W'*diag(1./sqrt(P_a_symm_1B))*M_2_T*diag(1./sqrt(P_a_symm_1B))*W;
M_2_C_mathcal=(1/(2*pi))*W'*diag(1./sqrt(P_a_symm_1B))*M_2_C*diag(1./sqrt(P_a_symm_1B))*W;

%norm(M_2_T_mathcal-circul(ifft(a_symm_1B_wave))*W'*T*W*circul(ifft(a_symm_1B_wave))')

M_2_T_mathcal=(M_2_T_mathcal'+M_2_T_mathcal)/2; %force hermitian
M_2_C_mathcal=(M_2_C_mathcal'+M_2_C_mathcal)/2;

[V_T,D_T]=eig(M_2_T_mathcal,"vector");
[V_C,D_C]=eig(M_2_C_mathcal,"vector");

[D_T_sorted,I_T_sort]=sort(D_T,"descend");
[D_C_sorted,I_C_sort]=sort(D_C,"descend");

V_T_sorted=V_T(:,I_T_sort);
V_C_sorted=V_C(:,I_C_sort);

[~,kappa]=max(min(abs(D_T_sorted-D_T_sorted.')+diag(inf(1,2*B+1)),[],2));
%kappa=21;
delta_kappa(f_index)=max(min(abs(D_T_sorted(kappa)-D_C_sorted(1:end~=kappa))),...
    min(abs(D_C_sorted(kappa)-D_T_sorted(1:end~=kappa))));

u=fft(V_T_sorted(:,kappa));
u_renormilized_bad=exp(1i* (angle(a_symm_1B(k_symm_1B==0))-angle(u(k_symm_1B==0)))) *...
    sqrt(P_a_symm_1B).* u; %./abs(u);
[err_squared_bad(f_index),l_bad]=circ_error_continuous(u_renormilized_bad,a_symm_1B,B);
u_renormilized_good=exp(1i* (angle(a_symm_1B(k_symm_1B==0))-angle(u(k_symm_1B==0)))) *...
    sqrt(P_a_symm_1B).* u./abs(u);
[err_squared_good(f_index),l_good]=circ_error_continuous(u_renormilized_good,a_symm_1B,B);

dist_from_circ(f_index)=sum(abs((conj(rho_hat_half_2B(2:end))-flip(rho_hat_half_2B(2:end))).^2)...
    .*(k_half_2B(2:end).'.*(flip(k_half_2B(2:end).')))./(2*B+1));

abs(norm(T-C_h,"fro").^2-dist_from_circ(f_index))
bound_rho=(2*B+1)*2*(1-sqrt(1-dist_from_circ(f_index)/(delta_kappa(f_index)^2)));
bound(f_index)=bound_rho*max(abs(a_symm_1B)).^2;
if imag(bound(f_index))~=0
    bound(f_index) = -1;
end
end

%close all
figure
hold on
[dist_from_circ_sorted,I_circ]=sort(dist_from_circ);
plot(10*log10(dist_from_circ_sorted),10*log10(err_squared_bad(I_circ)),'o')
%plot(10*log10(dist_from_circ_sorted),10*log10(err_squared_good(I_circ)))
plot(10*log10(dist_from_circ_sorted),10*log10(bound(I_circ)))
xlabel("$||T-C_{\underline{h}}||^2_F[dB]$", "interpreter", "latex")
%legend("Error^2 of Bad Normalization","Error^2 of Good Normalization","Bound")
legend("Error^2 of Spectral Algorithm[dB]","Bound[dB]")
set ( gca, 'xdir', 'reverse' )