function [check] = iscirculant(C)
check=1;
for n=2:size(C,1)
check=check&(norm(C(:,n)-circshift(C(:,n-1),1))==0);
end
end

