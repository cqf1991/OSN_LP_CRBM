function[thisauc]=CN(train,test)
    sim=train*train;
    thisauc=CalcAUC(train,test,sim,110);
end