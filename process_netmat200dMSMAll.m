ts = nets_load('200ICdualregtxt.dr', 0.80,0);
ts.DD=[1:73,75:79,81:85,89:90,93:94,98:100,102:104,106,111,114:115,119:122,125:131,133:141,143:144,146:149,151:154,156:200];
ts = nets_tsclean(ts,1);
ts_spectra = nets_spectra(ts);

netmats0=nets_netmats(ts,1,'corr');
netmats1=nets_netmats(ts,1,'ridgep',0.1);


net0_20=netmats0(1:20,:);


net0_830=netmats0(21:22,:);



net1_20=netmats1(1:20,:);

net1_830=netmats1(21:830,:);




tmp1=[]; tmp2=[]; 

for i=1:20/2
    

tmp1=[tmp1; 2*mean(net0_20((i-1)*2+1:i*2,:))];
 tmp2=[tmp2; 2*mean(net1_20((i-1)*2+1:i*2,:))];
 
end
net0_20_new=tmp1; net1_20_new=tmp2; 

tmp1=[]; tmp2=[]; 

for i=1:80/4
    

tmp1=[tmp1; 2*mean(net0_830((i-1)*4+1:i*4,:))];
 tmp2=[tmp2; 2*mean(net1_830((i-1)*4+1:i*4,:))];
 
end
net0_830_new=tmp1; net1_830_new=tmp2; 

tmp1=[]; tmp2=[]; 



netmats0_new=[net0_20_new;net0_830_new];
netmats1_new=[net1_20_new;net1_830_new];


dlmwrite('netmats0.txt',netmats1_e,'delimiter','\t','precision','%.6f');
dlmwrite('netmats1_ridge.txt',netmats0_e,'delimiter','\t','precision','%.6f');



