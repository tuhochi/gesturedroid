function [v] = realfile(filename)
%realfile Ueberprueft ob die Datei keine Systemdatei ist 
%
%   realfile(filename)
%                       Es wird ueberprueft ob eine Dateikeine Systemdatei
%                       ist
%                       Wenn dies der Fall ist wird 'true'
%                       zurueckgeliefert, ansonst 'false'.
%
%
% I/O Spec
%   filename     Pfad der zu ueberpruefenden Datei
%               
%
%   v           1: es ist keine Systemdatei
%               0: es handelt sich um eine Systemdatei

    [pathstr,name,ext] = fileparts(filename);
    v=0;
    if ~strcmp(filename,'.svn')
        if ~strcmp(filename,'.DS_Store') 
            if ~strcmp(filename,'Thumbs.db') 
                if ~strcmp(ext,'.mat')
                    v=1;
                end
            end
        end

    end

end
