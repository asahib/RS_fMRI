function [EDGE]=get_netvalues(netmat,ts,IC1,IC2)


i=(IC1-1)*ts.Nnodes + IC2; 
[a,b]= size(netmat);
EDGE=netmat(1:a,i);