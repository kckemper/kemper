clear all
close all
clc


sa(1) = saData('T10');
sa(2) = saData('T20');
sa(3) = saData('T20A');
sa(4) = saData('T100');

evo(1) = evoData('T10');
evo(2) = evoData('T20');
evo(3) = evoData('T20A');
evo(4) = evoData('T100');

plotData(sa(1),evo(1));
save2pdf('./figures/out_T10.pdf')

plotData(sa(2),evo(2));
save2pdf('./figures/out_T20.pdf')

plotData(sa(3),evo(3));
save2pdf('./figures/out_T20A.pdf')

plotData(sa(4),evo(4));
save2pdf('./figures/out_T100.pdf')

plotPath(evo(1));
save2pdf('./figures/path_evo_T10.pdf')
plotPath(evo(2));
save2pdf('./figures/path_evo_T20.pdf')
plotPath(evo(3));
save2pdf('./figures/path_evo_T20A.pdf')
plotPath(evo(4));
save2pdf('./figures/path_evo_T100.pdf')

plotPath(sa(1));
save2pdf('./figures/path_sa_T10.pdf')
plotPath(sa(2));
save2pdf('./figures/path_sa_T20.pdf')
plotPath(sa(3));
save2pdf('./figures/path_sa_T20A.pdf')
plotPath(sa(4));
save2pdf('./figures/path_sa_T100.pdf')