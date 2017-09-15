


















%%
%{
promptT1=' 1: EssexFace96 |';
promptT2=' 2: YaleExtendFace';
promptA1=' 1: neural network |';
promptA2=' 2: maximum likelihoood |';
promptA3=' 3: rbg svm';

promptset = strcat(promptT1,promptT2);
promptmethod = strcat(promptA1,promptA2,promptA3);
name = 'Operation number';
num = 1;
defaultans = {'2','3'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
s = inputdlg({promptset,promptmethod},name,num,defaultans,options);

switch s{1} == '2' & s{2} =='3'
    case [1 1]
        loadYaleSVM;
end
end
%}

