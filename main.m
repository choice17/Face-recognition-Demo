clear cam;

addpath('include');
addpath('data');
    
prompt1='input operation number';
prompt2=' 0: close application';
prompt3=' 1: training new image  ';
prompt4=' 2: perform face recognition';
prompt5=' 3: check class image';
prompt = {prompt2,prompt3,prompt4,prompt5};

run = true;
while (run)

    d = dialog('Position',[650 600 250 150],'Name','OPERATION');
    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 50],...
               'String',prompt);
    
    name = 'Operation number';
    defaultans = {'1'};
    options.Interpreter = 'tex';
    operation = inputdlg(prompt1,name,1,defaultans,options);
    close(d);
    close all;

    switch (operation{1})
        case '0'
        clear cam;
        close all;
        run = false; 
        
        case '1'
        trainNewFace(); % save new image
            
        case '2'
        performFaceRecognition; 
        
        case '3'
        close all;
        load predictMdl.mat
        figure;
        displayData(classMdl.cImg');
        pause(3);
        
    end
end
clearvars;
