%% Parameter Setup
sigma_vec_reduced=logspace(-2,2,20).';
%sigma_vec_reduced=zeros(10,1);
num_unique_sigma=length(sigma_vec_reduced);
num_rep=10;
sigma_vec=repelem(sigma_vec_reduced,num_rep);
%f_vec=[0,0.1,1,2];
f_vec=[0,0.1];
%f_vec=[0];
isUniformPowerSpectrum=[0,1];
%isUniformPowerSpectrum=[0];

err_squared_FM=zeros(length(sigma_vec),length(f_vec),length(isUniformPowerSpectrum));
err_squared_Spectral_true=zeros(length(sigma_vec),length(f_vec),length(isUniformPowerSpectrum));
err_squared_Spectral_emp=zeros(length(sigma_vec),length(f_vec),length(isUniformPowerSpectrum));
dist_from_circ=zeros(length(f_vec),length(isUniformPowerSpectrum));
bound=zeros(length(f_vec),length(isUniformPowerSpectrum));
B=10;
Q=2;
M=2*B+1;
W_M=(1/sqrt(M))*dftmtx(M);
W_Q=(1/sqrt(Q))*dftmtx(Q);
W=kron(W_M,W_Q);

N=5e5; %num of rotated photos;
%% Relevant frequencies
[freq_file_name]=saveFrequencies(Q,B);
load(freq_file_name);
%% Definition of Picture
images=cell(length(isUniformPowerSpectrum),1);
a_symm_1B_cell=cell(length(isUniformPowerSpectrum),1);

[a_symm_1B_cell{1},images{1}]=Generate_Picture_cut([pwd '\Flower_Images\Oxalis_tetraphylla_flower.jpg'],B,Q,isUniformPowerSpectrum(1));
[a_symm_1B_cell{2},images{2}]=Generate_Picture_cut([pwd '\Flower_Images\Oxalis_tetraphylla_flower.jpg'],B,Q,isUniformPowerSpectrum(2));
P_a_cell=cellfun(@(x) abs(x).^2,a_symm_1B_cell,"UniformOutput",false);

%% Numerics
tic
for UPS=1:length(isUniformPowerSpectrum)
    a_symm_1B=a_symm_1B_cell{UPS};
    a_symm_1B_mat=mat(a_symm_1B,Q,B);
    a_half_1B_mat=a_symm_1B_mat(:,k_symm_1B>=0);
    a_half_1B_vec=vec(a_half_1B_mat);
    for f_index=1:length(f_vec)
        
        %% Rho Definition
        %temp=[0.00195583374369666 + 0.00530869159003379i;0.00195583374369666 + 0.00474988194897760i;0.00195583374369666 + 0.00419107230792141i;0.00195583374369666 + 0.00363226266686522i;0.00195583374369666 + 0.00307345302580903i;0.00195583374369666 + 0.00251464338475285i;0.00195583374369666 + 0.00195583374369666i;0.00195583374369666 + 0.00139702410264047i;0.00195583374369666 + 0.000838214461584282i;0.00195583374369666 + 0.000279404820528094i;0.00195583374369666 - 0.000279404820528094i;0.00195583374369666 - 0.000838214461584282i;0.00195583374369666 - 0.00139702410264047i;0.00195583374369666 - 0.00195583374369666i;0.00195583374369666 - 0.00251464338475285i;0.00195583374369666 - 0.00307345302580903i;0.00195583374369666 - 0.00363226266686522i;0.00195583374369666 - 0.00419107230792141i;0.00195583374369666 - 0.00474988194897760i;0.00195583374369666 - 0.00530869159003379i]...
        %    .*exp(1i*(f_vec(f_index)*rand(2*B,1)).^0.2)*3;
        temp=[0.00195583374369666 + 0.00530869159003379i;0.00195583374369666 + 0.00474988194897760i;0.00195583374369666 + 0.00419107230792141i;0.00195583374369666 + 0.00363226266686522i;0.00195583374369666 + 0.00307345302580903i;0.00195583374369666 + 0.00251464338475285i;0.00195583374369666 + 0.00195583374369666i;0.00195583374369666 + 0.00139702410264047i;0.00195583374369666 + 0.000838214461584282i;0.00195583374369666 + 0.000279404820528094i;0.00195583374369666 - 0.000279404820528094i;0.00195583374369666 - 0.000838214461584282i;0.00195583374369666 - 0.00139702410264047i;0.00195583374369666 - 0.00195583374369666i;0.00195583374369666 - 0.00251464338475285i;0.00195583374369666 - 0.00307345302580903i;0.00195583374369666 - 0.00363226266686522i;0.00195583374369666 - 0.00419107230792141i;0.00195583374369666 - 0.00474988194897760i;0.00195583374369666 - 0.00530869159003379i]...
            .*exp(1i*(f_vec(f_index)*rand(2*B,1)).^0.2)*3;
        %temp=[0.00195583374369666 + 0.00530869159003379i;0.00195583374369666 + 0.00474988194897760i;0.00195583374369666 + 0.00419107230792141i;0.00195583374369666 + 0.00363226266686522i;0.00195583374369666 + 0.00307345302580903i;0.00195583374369666 + 0.00251464338475285i;0.00195583374369666 + 0.00195583374369666i;0.00195583374369666 + 0.00139702410264047i;0.00195583374369666 + 0.000838214461584282i;0.00195583374369666 + 0.000279404820528094i;0.00195583374369666 - 0.000279404820528094i;0.00195583374369666 - 0.000838214461584282i;0.00195583374369666 - 0.00139702410264047i;0.00195583374369666 - 0.00195583374369666i;0.00195583374369666 - 0.00251464338475285i;0.00195583374369666 - 0.00307345302580903i;0.00195583374369666 - 0.00363226266686522i;0.00195583374369666 - 0.00419107230792141i;0.00195583374369666 - 0.00474988194897760i;0.00195583374369666 - 0.00530869159003379i]...
        %.*exp(1i*(0.8*ones(2*B,1)).^0.3./f_vec(f_index).^2)*3;
        %temp=[0.00195583374369666 + 0.00530869159003379i;0.00195583374369666 + 0.00474988194897760i;0.00195583374369666 + 0.00419107230792141i;0.00195583374369666 + 0.00363226266686522i;0.00195583374369666 + 0.00307345302580903i;0.00195583374369666 + 0.00251464338475285i;0.00195583374369666 + 0.00195583374369666i;0.00195583374369666 + 0.00139702410264047i;0.00195583374369666 + 0.000838214461584282i;0.00195583374369666 + 0.000279404820528094i;0.00195583374369666 - 0.000279404820528094i;0.00195583374369666 - 0.000838214461584282i;0.00195583374369666 - 0.00139702410264047i;0.00195583374369666 - 0.00195583374369666i;0.00195583374369666 - 0.00251464338475285i;0.00195583374369666 - 0.00307345302580903i;0.00195583374369666 - 0.00363226266686522i;0.00195583374369666 - 0.00419107230792141i;0.00195583374369666 - 0.00474988194897760i;0.00195583374369666 - 0.00530869159003379i]...
        %    +f(index)/(5e4*B)*(rand(2*B,1)+1i*rand(2*B,1));
        
        t=-pi:1e-4:pi;
        [rho_hat_symm_2B, rho_func]=GenerateDistribution(temp,t,Q,B);

        rho_hat_symm_1B=rho_hat_symm_2B(-B<=k_symm_2B & k_symm_2B<=B);
        rho_hat_half_2B=rho_hat_symm_2B(0<=k_symm_2B);
        rho_hat_half_1B=rho_hat_symm_2B(0<=k_symm_2B & k_symm_2B<=B);

        varrho=repelem(rho_hat_symm_1B,Q);
        h=(1/(2*B+1))*(k_half_2B.'.*[0 ; conj(flip(rho_hat_half_2B(2:end)))]...
            +(2*B+1-k_half_2B.').*rho_hat_half_2B);
        zeta=repmat(h.',[Q,1]);

        %% Generate Data
        for sigma_index=1:length(sigma_vec)
            toc
            disp("f_index="+f_index+", sigma_index="+sigma_index)
            sigma=sigma_vec(sigma_index); %noise level
            dt=t(2)-t(1); %Quantization of [0,2pi].
            rotations=randsample(t,N,true,abs(rho_func(t))).';
            %absolute value to avoid numeric negatives, rho should always be positive.

            a_half_1B_mat_rot=a_half_1B_mat.*exp(-1i*k_half_1B_Q_mat.*permute(rotations,[3,2,1]))...
                +sigma*randn([size(a_half_1B_mat) N]);
            a_half_1B_mat_rot_conj=conj(flip(reshape(...
                a_half_1B_mat_rot(repmat(k_half_1B_Q_mat~=0,[1,1,N]))...
                ,[Q,B,N]),2));
            a_symm_1B_mat_rot=cat(2,a_half_1B_mat_rot_conj,a_half_1B_mat_rot);
            a_symm_1B_rot=reshape(a_symm_1B_mat_rot,[Q*(2*B+1),N]);
            %% Calculate Moments (M1 and M2)

            %first moment
            M_1_true=a_symm_1B.*varrho.*(2*pi);
            M_1_emp=vec(mean(a_symm_1B_mat_rot,3));

            %second moment
            T=BTTB(repmat(rho_hat_half_2B.',Q,1));

            %Bias occurs only for q1=q2,k1=+-k2
            Logical_Bias_Mat=zeros(length(a_symm_1B));
            Logical_Bias_Mat(k_symm_1B_Q_vec-k_symm_1B_Q_vec.'==0&...
                q_full_1B_vec-q_full_1B_vec.'==0) = 1; %q1=q2,k1=k2
            Logical_Bias_Mat(k_symm_1B_Q_vec+k_symm_1B_Q_vec.'==0&...
                q_full_1B_vec-q_full_1B_vec.'==0) = 1; %q1=q2,k1=-k2

            M_2_true=(2*pi)*diag(a_symm_1B)*T*diag(conj(a_symm_1B))+(sigma^2)*Logical_Bias_Mat; %'=complex conjugate transpose
            M_2_emp=(1/N)*(a_symm_1B_rot*a_symm_1B_rot');

            diff_M2_true_emp(sigma_index) = norm(M_2_true-M_2_emp,"fro");
            M_2_true_wave=M_2_true-(sigma^2)*Logical_Bias_Mat;
            M_2_emp_wave=M_2_emp-(sigma^2)*Logical_Bias_Mat;

            moment_type="emp";
            %moment_type="true";
            if strcmp(moment_type,"emp")==1
                M_1=M_1_emp;
                M_2=M_2_emp;
                M_2_wave=M_2_emp_wave;
            end
            if strcmp(moment_type,"true")==1
                M_1=M_1_true;
                M_2=M_2_true;
                M_2_wave=M_2_true_wave;
            end
            %% Frequency Marching Algorithm
            S_mathcal=2*pi*diag(1./M_1)*M_2_wave*diag(1./M_1)';
            weights_q=cell(2*B+1,2*B+1);
            for k1=-B:B
                for k2=-B:B
                    weight=exp(-q_1B).'*exp(-q_1B); %low q's are worth most
                    weights_q{k_symm_1B==k1,k_symm_1B==k2}=weight./sum(weight,"all"); %normalize
                end
            end
            S_mathcal_tilde=zeros(2*B+1,2*B+1); %condensed S
            for k1=-B:B
                for k2=-B:B
                    S_mathcal_tilde(k_symm_1B==k1,k_symm_1B==k2)...
                        =sum(weights_q{k_symm_1B==k1,k_symm_1B==k2}...
                        .*S_mathcal(k_symm_1B_Q_vec==k1,k_symm_1B_Q_vec==k2),"all");
                end
            end
            weights_k=cell(1,B); %max number of approximations x max freq-1
            for k=2:B
                weights_k{k}=exp(-abs(ceil(k/2)-(1:k-1).')); %lorentzian of length n centered at ceil(n/2)
                weights_k{k}=weights_k{k}./sum(weights_k{k}); %normalize to sum 1.
            end
            %%
            rho_approx_half_1B=zeros(length(k_half_1B),1);
            rho_approx_tilde_half_1B= zeros(length(k_half_1B),1);

            rho_abs_half_1B = sqrt(abs(1./(2*pi*diag(S_mathcal_tilde(k_symm_1B>=0,k_symm_1B>=0)))));
            rho_approx_half_1B(k_half_1B==0)=1/(2*pi);
            %arbitrarily pick phase of 1'st coeff to be 1:
            rho_approx_half_1B(k_half_1B==1) = rho_abs_half_1B(k_half_1B==1);

            for k=2:B
                rho_approx_tilde_half_1B(k_half_1B==k) = sum(weights_k{k}.*flip(rho_approx_half_1B(1<=k_half_1B & k_half_1B <= k-1))./...
                    conj(rho_approx_half_1B(1<=k_half_1B & k_half_1B <= k-1))./...
                    S_mathcal_tilde(k_symm_1B==k, 1<=k_symm_1B & k_symm_1B <= k-1).');

                rho_approx_half_1B(k_half_1B==k)=rho_abs_half_1B(k_half_1B==k).*...
                    rho_approx_tilde_half_1B(k_half_1B==k)./abs(rho_approx_tilde_half_1B(k_half_1B==k));
            end
            rho_approx_symm_1B= [conj(flip(rho_approx_half_1B(2:end))); rho_approx_half_1B];
            varrho_approx=repelem(rho_approx_symm_1B,Q);

            a_approx_symm_1B=M_1./(2*pi.*varrho_approx);
            [err_squared_FM(sigma_index,f_index,UPS),theta_min]=...
                circ_error_continuous_unrestricted_2D(a_approx_symm_1B,a_symm_1B,Q,B);
            %% Spectral Algorithm
            C=BCCB(zeta);

            %A=BCCB(ifft2(mat(a_tilde_symm_1B,Q,B)));

            P_a_true=diag(M_2_true_wave);
            P_a_emp=diag(M_2_emp_wave);
            v_p_true=1./sqrt(P_a_true);
            v_p_emp=1./sqrt(P_a_emp);

            M_2_C=2*pi*diag(a_symm_1B)*C*diag(a_symm_1B)';
            M_2_C_mathcal=(1/(2*pi))*W'*diag(v_p_true)*M_2_C*diag(v_p_true)*W;

            M_2_T_true_mathcal=(1/(2*pi))*W'*diag(v_p_true)*M_2_true_wave*diag(v_p_true)*W;
            M_2_T_emp_mathcal=(1/(2*pi))*W'*diag(v_p_emp)*M_2_emp_wave*diag(v_p_emp)*W;


            M_2_T_true_mathcal=(M_2_T_true_mathcal'+M_2_T_true_mathcal)/2; %force hermitian
            M_2_T_emp_mathcal=(M_2_T_emp_mathcal'+M_2_T_emp_mathcal)/2;
            M_2_C_mathcal=(M_2_C_mathcal'+M_2_C_mathcal)/2;

            [V_T_true,D_T_true]=eig(M_2_T_true_mathcal,"vector");
            [V_T_emp,D_T_emp]=eig(M_2_T_emp_mathcal,"vector");
            [V_C,D_C]=eig(M_2_C_mathcal,"vector");

            [D_T_true_sorted,I_T_true_sort]=sort(D_T_true,"descend");
            [D_T_emp_sorted,I_T_emp_sort]=sort(D_T_emp,"descend");
            [D_C_sorted,I_C_sort]=sort(D_C,"descend");

            V_T_true_sorted=V_T_true(:,I_T_true_sort);
            V_T_emp_sorted=V_T_emp(:,I_T_emp_sort);
            V_C_sorted=V_C(:,I_C_sort);

            [~,kappa_true]=max(min(abs(D_T_true_sorted-D_T_true_sorted.')+diag(inf(1,Q*(2*B+1))),[],2));
            [~,kappa_emp]=max(min(abs(D_T_emp_sorted-D_T_emp_sorted.')+diag(inf(1,Q*(2*B+1))),[],2));

            delta_kappa=max(min(abs(D_T_true_sorted(kappa_true)-D_C_sorted(1:end~=kappa_true))),...
                min(abs(D_C_sorted(kappa_true)-D_T_true_sorted(1:end~=kappa_true))));
            %change to kappa_emp? no this complicates the comparison

            v_T_kappa_true=V_T_true_sorted(:,kappa_true); %unique eigenvector
            v_T_kappa_emp=V_T_emp_sorted(:,kappa_emp);

            a_est_tilde_T_true=vec(fft2(mat(v_T_kappa_true,Q,B)));
            a_est_T_true=a_est_tilde_T_true...
                .*exp(1i.*(angle(M_1_true(k_symm_1B_Q_vec==0 & q_full_1B_vec==0))...
                -angle(a_est_tilde_T_true(k_symm_1B_Q_vec==0 & q_full_1B_vec==0))))...
                .*sqrt(P_a_true);
            [err_squared_Spectral_true(sigma_index,f_index,UPS),l_T_true]=...
                Circ_Error_Continuous_2D(a_est_T_true,a_symm_1B,Q,B);

            a_est_tilde_T_emp=vec(fft2(mat(v_T_kappa_emp,Q,B)));
            a_est_T_emp=a_est_tilde_T_emp...
                .*exp(1i.*(angle(M_1_emp(k_symm_1B_Q_vec==0 & q_full_1B_vec==0))...
                -angle(a_est_tilde_T_emp(k_symm_1B_Q_vec==0 & q_full_1B_vec==0))))...
                .*sqrt(P_a_emp);
            [err_squared_Spectral_emp(sigma_index,f_index,UPS),l_T_emp]=...
                Circ_Error_Continuous_2D(a_est_T_emp,a_symm_1B,Q,B);

            dist_from_circ(f_index,UPS)=(Q^2)*sum(abs((conj(rho_hat_half_2B(2:end))-flip(rho_hat_half_2B(2:end))).^2)...
                .*(k_half_2B(2:end).'.*(flip(k_half_2B(2:end).')))./(2*B+1));

            %dist_from_circ(f_index,UPS)=norm(T-C,"fro").^2;
            bound(f_index,UPS)=2*Q*(2*B+1)*max(P_a_true).*(1-sqrt(1-dist_from_circ(f_index,UPS)./delta_kappa.^2));
            if abs(imag(bound(f_index,UPS)))>=1e-10 %not numerically imaginary
                bound(f_index,UPS)=-1;
            else
                bound(f_index,UPS)=real(bound(f_index,UPS));
            end
            %for testing
            if err_squared_Spectral_emp(sigma_index,f_index,UPS)>=5e1
                %error()
            end
        end
    end
end
%{
%% Plots
close all
figures=cell(length(isUniformPowerSpectrum),1);
energy_of_a=zeros(length(isUniformPowerSpectrum),1);
SNR=zeros(length(sigma_vec_reduced),length(isUniformPowerSpectrum));
f_indecies_for_plot=[2];
for UPS=1:length(isUniformPowerSpectrum)
    energy_of_a(UPS)=sum(abs(a_symm_1B_cell{UPS}).^2);
    SNR(:,UPS)=energy_of_a(UPS)./((2*B+1)*Q*sigma_vec_reduced.^2);

    figures{UPS}=figure;
    err_FM_for_plot=mean(reshape(err_squared_FM(:,f_indecies_for_plot,UPS),num_rep,num_unique_sigma),1).'./energy_of_a(UPS);
    err_spectral_for_plot=mean(reshape(err_squared_Spectral_emp(:,f_indecies_for_plot,UPS),num_rep,num_unique_sigma),1).'./energy_of_a(UPS);
    subplot(1,2,2)
    loglog(SNR(:,UPS),err_spectral_for_plot);
    if UPS==1
        title("Non Uniform Power Spectrum")
    end
    if UPS==2
        title("Uniform Power Spectrum")
    end
    hold on
    loglog(SNR(:,UPS),err_FM_for_plot);
    yline(bound(f_indecies_for_plot,UPS));
    axis tight
    legend("spectral","FM")

    subplot(1,2,1)
    imagesc(images{UPS})
    set(gca,'ydir','normal')
    axis off
    colormap gray
    colorbar('SouthOutside')
end
%}
%%
%close all
figures=cell(length(isUniformPowerSpectrum),1);
energy_of_a=zeros(length(isUniformPowerSpectrum),1);
SNR=zeros(length(sigma_vec_reduced),length(isUniformPowerSpectrum));
f_indecies_for_plot=[1 2];
for UPS=1:length(isUniformPowerSpectrum)
    energy_of_a(UPS)=sum(abs(a_symm_1B_cell{UPS}).^2);
    SNR(:,UPS)=energy_of_a(UPS)./((2*B+1)*Q*sigma_vec_reduced.^2);
    figures{UPS}=figure;
    
    for f_index=1:length(f_indecies_for_plot)
        err_FM_for_plot=mean(reshape(err_squared_FM(...
            :,f_index,UPS),num_rep,num_unique_sigma),1).'./energy_of_a(UPS);
        err_spectral_for_plot=mean(reshape(err_squared_Spectral_emp(...
            :,f_index,UPS),num_rep,num_unique_sigma),1).'./energy_of_a(UPS);
        subplot(1,2,f_index)
        lg_cells=cell(1,4);

        loglog(SNR(:,UPS),err_FM_for_plot,'-blue',"linewidth",1.15);
        lg_cells{find(cellfun(@isempty,lg_cells), 1,"first" )}=...
            "$\textnormal{Frequency Marching Algorithm}$";

        hold on

        loglog(SNR(:,UPS),err_spectral_for_plot,'-red',"linewidth",1.15);
        lg_cells{find(cellfun(@isempty,lg_cells), 1,"first" )}=...
            "$\textnormal{Spectral Algorithm}$";

        if bound(f_index,UPS) ~=0 & bound(f_index,UPS)~=-1
            yline(bound(f_index,UPS)./energy_of_a(UPS),"--black","linewidth",1.15);
            lg_cells{find(cellfun(@isempty,lg_cells), 1,"first")}=...
                "$\textnormal{Bound on Noiseless Spectral Algorithm} = "+round(bound(f_index,UPS)./energy_of_a(UPS),2)+"$";
        end

       
        xlabel("$\textnormal{SNR}$","fontsize",15,"interpreter","latex")
        ylabel("$\textnormal{Relative Squared Error}$","fontsize",15,"interpreter","latex")
        title("$||T-C_{\underline{h}}||^2 = "+round(dist_from_circ(f_index,UPS),4)+"$",...
            "interpreter","latex","fontsize",15)
        axis tight
        
        %SNR_critical_point= min(SNR(SNR>=1e4 & err_spectral_for_plot>=err_FM_for_plot));
        cutoff=1e-3;
        [~,SNR_critical_point_index]=min(abs(err_spectral_for_plot(SNR(:,UPS)>=cutoff)-err_FM_for_plot(SNR(:,UPS)>=cutoff)));
        SNR_half=SNR(SNR(:,UPS)>=cutoff,UPS);
        SNR_critical_point=SNR_half(SNR_critical_point_index);
        if ~isempty(SNR_critical_point) & SNR_critical_point ~= max(SNR(:,UPS))
            xline(SNR_critical_point,"--","color",[0.5 0.5 0.5],"linewidth",1.15);
            loglog(SNR_critical_point,err_spectral_for_plot(SNR(:,UPS)==SNR_critical_point),...
                "o","color","m","linewidth",1.2);

            %lg_cells{min(find(cellfun(@isempty,lg_cells)))} = "Critical SNR = "+sprintf("%10e",SNR_critical_point);
            lg_cells{find(cellfun(@isempty,lg_cells), 1,"first" )} ="$\textnormal{Critical SNR} = "...
                +round(SNR_critical_point./cutoff,2) + "\times {10}^{"+log10(cutoff)+"}$";
        end
        
        lg_cells(cellfun(@isempty,lg_cells))=[];
        lg=legend(lg_cells);
        lg.FontSize=10.5;
        lg.Location="southwest";
        lg.Interpreter="Latex";
        %legend(cat(2,lg_cells,{"fontsize",10.5,"location","southwest"}))
    end
    sgtitle("$\textnormal{FM Algorithm vs. Spectral Algorithm, isUniformPowerSpectrum=}"...
        +isUniformPowerSpectrum(UPS)+"$","interpreter","latex","fontsize",25)
    
    if isUniformPowerSpectrum(UPS)==1
        figure_string='Comparison_2D_With_Uniform_Spectrum';
    else
        figure_string='Comparison_2D_Without_Uniform_Spectrum';
    end
    saveas(figures{UPS},[pwd '/Figures_Thesis/' figure_string '.fig']);
    saveas(figures{UPS},[pwd '/Figures_Thesis/' figure_string '.png']);
    print(figures{UPS},'-depsc',[pwd '/Figures_Thesis/' figure_string '.eps']);
end
%sgtitle("$\textnormal{FM Algorithm vs. Spectral Algorithm}$","interpreter","latex","fontsize",25)
