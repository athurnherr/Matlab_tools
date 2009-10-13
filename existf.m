function [yn,pos]=existf(d,n)
% function yn=existf(d,n)
% checks for existance of variable (n) in data field (d)
an=fieldnames(d);
pos=strcmp(an,n);
yn=sum(pos);


