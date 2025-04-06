clear all
close all
options = optimset('Display','iter')
fzero(@tan,4.5, options)
fzero(@tan,6.0, options)
%tan(4.7124)
%tan(6.2832)