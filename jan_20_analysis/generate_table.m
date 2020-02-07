function generate_table(numRepeats,header,calculated,caption,label,varargin)
[data,header,calculated] = repeatData(varargin,header,calculated,numRepeats);

fprintf('\n');
fprintf('\\begin{table}[H]\n');
fprintf('\\center\n');
fprintf('\\begin{tabular}{');
for n = 1:length(data)
    fprintf('c')
    if n ~= length(data)
        fprintf(' ')
    end
end
fprintf('}\n');
fprintf('\\hline \\hline \n');
for n = 1:length(data)
    fprintf('$%s \\left(\\mathrm{%s}\\right)$',header{n},data{n}.unit);
    if n == length(data)
        fprintf(' \\\\\n');
    else
        fprintf(' & ');
    end
end
fprintf('\\hline \n');
for n = 1:length(data{1}.val)
    for m = 1:length(data)
        fprintf('%s',formatValuesLatex(data{m}.val(n),data{m}.err(n),calculated(m)));
        if m == length(data)
            fprintf(' \\\\\n');
        else
            fprintf(' & ');
        end
    end
end
fprintf('\\hline \\hline \n');
fprintf('\\end{tabular}\n');
fprintf('\\caption{%s}\n',caption);
fprintf('\\label{tab:%s}\n',label);
fprintf('\\end{table}\n');
fprintf('\n');
end

function [dataOut,headerOut,calculatedOut] = repeatData(data,header,calculated,numRepeats)
len = length(data);
lenOut = len*numRepeats;
dataOut = cell(1,lenOut);
headerOut = cell(1,lenOut);
calculatedOut = false(1,lenOut);
numPoints = ceil(length(data{1}.val)/numRepeats);
numPointsArr = 1:numPoints;
currentPoint = 0;
for n = 1:length(dataOut)
    currentI = mod(n-1,length(data))+1;
    dataOut{n}.val = data{currentI}.val(numPointsArr + currentPoint);
    dataOut{n}.err = data{currentI}.err(numPointsArr + currentPoint);
    dataOut{n}.unit = data{currentI}.unit;
    headerOut{n} = header{currentI};
    calculatedOut(n) = calculated(currentI);
    if currentI == len
        currentPoint = currentPoint + numPoints;
    end
end
end

function [out] = formatValues(val,err,calculated)
if nargin == 2
    calculated = true;
end

out = formatValuesGeneral(val,err,calculated,'%%.%if \\x00B1 %%.%if');
end

function [out] = formatValuesGeneral(val,err,calculated,format)
p = floor(log10(err));
if calculated
    p = p - 1;
end
dec = 0;
if p < 0
    dec = -p;
end
errNew = round(err * 10^(-p))*10^p;
valNew = round(val * 10^(-p))*10^p;
outText = sprintf(format,dec,dec);
out = sprintf(outText,valNew,errNew);
end

function [out] = formatValuesLatex(val,err,calculated)
if nargin == 2
    calculated = true;
end

out = formatValuesGeneral(val,err,calculated,'$%%.%if \\\\pm %%.%if$');
end

function [] = createFigure(figureHandle,outputFolder,caption,label,width)
if nargin == 4
    width = 1;
end

label = strrep(label,'.','_');
filename = [label,'.png'];
saveas(figureHandle,[outputFolder,filename]);
fprintf('\n');
fprintf('\\begin{figure}[H]\n');
fprintf('\\begin{center}\n');
fprintf('\\captionsetup{width=\\textwidth}\n');
fprintf('\\includegraphics[width=%.2f\\textwidth]{%s}\n',width,filename);
fprintf('\\captionof{figure}{%s}\n',caption);
fprintf('\\label{fig:%s}\n',label);
fprintf('\\end{center}\n');
fprintf('\\end{figure}\n');
fprintf('\n');
end