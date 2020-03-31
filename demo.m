%Readme:
%      1: Click the mouse on the texture  N times by your perception,
%        and then press the ¡®Enter¡¯ to end the selection of texture patch.
%      2: Click the mouse on the structure  M times by your perception,
%        and then press the ¡®Enter¡¯ to end the selection of structure patch.
close all
clear
clc
I=imread('fish.png');
J=imread('fishG1.png');
y=T3SI(I,J)
