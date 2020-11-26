ts = nets_load('200ICdualregtxt.dr', 0.80,0);
ts.DD=[1:73,75:79,81:85,89:90,93:94,98:100,102:104,106,111,114:115,119:122,125:131,133:141,143:144,146:149,151:154,156:200];
ts = nets_tsclean(ts,1);
ts_spectra = nets_spectra(ts);
group_maps='200IC';
%group_maps='Figures200d'
netmats0= dlmread('netmats0.txt');
netmats1=dlmread('netmats1_ridge.txt');
[Znet_0,Mnet_0]=nets_groupmean(netmats0,0);
[Znet_2,Mnet_2]=nets_groupmean(netmats1,1);

nets_hierarchy(Znet_0,Znet_2,ts.DD,group_maps);
nets_nodepics(ts,group_maps);
nets_netweb(Znet_0,Znet_2,ts.DD,group_maps,'netweb_average_830sessions');
% netmats0_KET12=dlmread('KET1_KET2_net0.txt');
% [Znet_0ket12,Mnet_0ket12]=nets_groupmean(netmats0_KET12,0); %%v Full correlation
netmats1_KET12=dlmread('KET1_KET2_netmat1.txt'); %%%L1 regularization lambda 10

[Znet2_ket12,Mnet2_ket12]=nets_groupmean(netmats1_KET12,1);
% nets_hierarchy(Znet_0ket12,Znet2_ket12,ts.DD,group_maps);
[p_uncorrectedket12,p_correctedket12]=nets_glm(netmats1_KET12,'design_KET12.mat','design_KET12.con',1);
% [p_uncorrected2,p_corrected2]=nets_glm(netmats1_KET12,'design_ket12.mat','design_ket12.con',1);
nets_edgepics(ts,group_maps,Znet2_ket12,reshape(p_correctedket12(1,:),ts.Nnodes,ts.Nnodes),3);
nets_boxplots(ts,netmats1_KET12,23,6,39);
set(gca,'linew',1)
set(findobj(gca,'type','line'),'linew',2)
EDGE_ket12=get_netvalues(netmats2_KET12,ts,13,1);

% netmats0_KET13=dlmread('KET1_KET3_net0.txt');
% [Znet_0ket13,Mnet_0ket13]=nets_groupmean(netmats0_KET13,0); %%v Full correlation
netmats1_KET13=dlmread('KET1_KET3_netmat1.txt'); %%%L1 regularization lambda 10
% netmats1_KET13=dlmread('KET1_KET3_net1.txt');
[Znet2_ket13,Mnet2_ket13]=nets_groupmean(netmats1_KET13,1);
% nets_hierarchy(Znet_0ket13,Znet2_ket13,ts.DD,group_maps);

[p_uncorrected2,p_corrected2]=nets_glm(netmats1_KET13,'design_KET13.mat','design_KET13.con',1);

nets_boxplots(ts,netmats1_KET13,5,1,51);
set(gca,'linew',1)
set(findobj(gca,'type','line'),'linew',2)
EDGE_ket13_45_44=get_netvalues(netmats1_KET13,ts,45,44);

netmats2_ket1min3=dlmread('ket1minket3_39.txt');
[p_uncorrectedhamd,p_correctedhamd]=nets_glm(netmats2_ket1min3,'design_HAMD.mat','design_HAMD.con',1);
[Znet2_ket1min3,Mnet2_ket1min3]=nets_groupmean(netmats2_ket1min3,1);
nets_edgepics(ts,group_maps,Znet2_ket1min3,reshape(p_uncorrectedhamd(2,:),ts.Nnodes,ts.Nnodes),2);
netmats2_ket13_38=dlmread('KET1_KET3_rej31_net2.txt');
[p_uncorrectedket38,p_correctedket38]=nets_glm(netmats2_ket13_38,'design_ket13_38.mat','design_ket13_38.con',1);

%netmats2_ECT12=dlmread('ECT1_ECT2_net2.txt');
netmats1_ECT12=dlmread('ECT1_ECT2_netmat1.txt');
[p_uncorrectedectect,p_correctedectect]=nets_glm(netmats1_ECT12,'design_ECT12.mat','design_ECT12.con',1);
[Znet2_ect12,Mnet2_ect12]=nets_groupmean(netmats1_ECT12,1);
nets_edgepics(ts,group_maps,Znet2_ect12,reshape(p_correctedectect(2,:),ts.Nnodes,ts.Nnodes),2);
nets_boxplots(ts,netmats2_ECT12,25,24,20);

netmats1_HCvsMDD=dlmread('HCvsMDD_ket_netmat1.txt');
[p_uncorrectedhcvsmdd,p_correctedhcvsmdd]=nets_glm(netmats1_HCvsMDD,'design_HCvsMDD.mat','design_HCvsMDD.con',1);
[Znet2_hcvsmdd,Mnet2_hcvsmdd]=nets_groupmean(netmats1_HCvsMDD,1);
nets_edgepics(ts,group_maps,Znet2_hcvsmdd,reshape(p_correctedhcvsmdd(1,:),ts.Nnodes,ts.Nnodes),4);
nets_boxplots(ts,netmats1_HCvsMDD,5,1,40);

netmats1_KET23=dlmread('KET_TP2_TP3_netmat1.txt');
nets_boxplots(ts,netmats1_KET23,45,44,44);