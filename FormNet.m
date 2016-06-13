function[net]=FormNet(linklist)
if ~all(all(linklist(:,1:2)))
    linklist(:,1:2)=linklist(:,1:2)+1;
end
linklist(:,3)=1;
net=spconvert(linklist);
nodenum=length(net);
net(nodenum,nodenum)=0;

net=net-diag(diag(net));
net=spones(net+net');
end