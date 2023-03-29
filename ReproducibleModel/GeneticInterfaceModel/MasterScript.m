%% Script to reproduce BSA model
% Data2Dynamics needs to be installed and added to the path as well as all
% necessary packages needed for Data2Dynamics

%% Loading model and Data
set(0, 'DefaultFigureRenderer', 'painters');

%% New figures also send them to Carolina
%% New profiles with  new names
%% New table

arInit;
model = 'BSA_Rec_Model';
SaveName = model;
arLoadModel(model);
arLoadData('DR_BSA')
arCompileAll;
ar.config.backup_modelAndData = 0;
arSave([SaveName]);

ar.config.atol = 1e-9;
ar.config.rtol = 1e-9;
ar.config.maxsteps=5000;
ar.config.optim.MaxIter = 5000;
ar.config.fiterrors = 0;


arFitLHS(100);
arPlotFitsCustom(1);
ar.config.showLegends = 0;
arPlot(1);
ar.config.showLegends = 1;
arSave('Current');

arPLEInit;
ple();
plePlot([],1);
plePlotMulti([],1);
arSave('Current');

close all

%% Fix practically non-identifiable parameter k_bind_complex to 10^3
arSetPars('k_bind_complex',3,0);
arFit
arSave([model '_fixed_k_bind_complex']);


arFitLHS(100);
arPlotFitsCustom(1);
ar.config.showLegends = 0;
arPlot(1);
ar.config.showLegends = 1;
arSave('Current');

arPLEInit;
ple();
plePlot([],1);
plePlotMulti([],1);
arSave('Current');

close all


arExportPEtab([SaveName '_final']);
arSave('Current');

[~,allmerits] = arGetMerit;
merits = struct2table(allmerits);
merits.Model = [model];
merits = movevars(merits,"Model",'Before',"loglik");
writetable(merits,['Merits_' model '.csv'])

