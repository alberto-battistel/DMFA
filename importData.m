% import data
clear
clc

filename = 'Redox_MultiACL07_quasiCV2_10mV';
cwd = pwd;

cd('RawData')

load(filename)

cd(cwd)