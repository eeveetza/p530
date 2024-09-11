% This Recommendation uses integral digital products. They form an integral
% part of the recommendation and may not be reproduced, by any means whatsoever,
% without written permission of ITU.
%
% The user should download the necessary digital maps that are used by this
% implementation directly from ITU-R web site and place the files in the
% folder ./private/maps. After that, the user should execute the script
% contained in this file "initiate_digital_maps.m". The script produces the
% necessary functions that contain the digital maps and are used for
% interpolations.
% The following maps should be extracted in the folder ./private/maps:
% 1. From https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.530-18-202109-I!!ZIP-E.zip
%    - LogK.csv
%    - dN75.csv
% 2. From https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.2001-5-202308-I!!ZIP-E.zip
%    - Esarain_beta_v5.txt
%    - Esarain_Mt_v5.txt
%    - Esarain_Pr6_v5.txt
%    - h0.txt
% 3. From https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.837-7-201706-I!!ZIP-E.zip
%    - R001.TXT


files = {'LogK.csv', 'dN75.csv', 'Esarain_Beta_v5.txt', 'Esarain_Mt_v5.txt', ...
    'Esarain_Pr6_v5.txt', 'h0.txt', 'R001.TXT'};

for i  = 1 : length(files)

    xx = files{i};
    filename = ['private/maps/' xx];
    functionname = ['DigitalMaps_' xx(1:end-4)];
    filename_m = ['private/' functionname '.m'];

    if ~isfile(filename_m)

        fprintf(1, "Processing file: %s --> %s...\n", filename, filename_m);

        % verify that the file does not exist

        % read the file

        fid = fopen(filename, "r");

        if(fid==-1)
            errorstr = sprintf(['Download and extract the required maps to ./private/maps:\n' ...
                'From ITU-R P.530-18: LogK.csv and dN75.csv\n' ...
                'From ITU-R P.2001-5: Esarain_Beta_v5.txt, Esarain_Mt_v5.txt, Esarain_Pr6_v5.txt, h0.txt\n' ...
                'From ITU-R P.837-7: R001.TXT\n']);
            error(errorstr);

        end

        datastr = [];

        while (1)

            line = fgetl(fid);

            if (line == -1)
                break;
            end

            datastr = [datastr line '\n'];

        end

        fclose(fid);

        % write the data in the function.m

        fid = fopen(filename_m, 'w');


        datastr_before = ['function y = ' functionname '()\n' ...
            '%%%% ' functionname ' returns values from the table ' files{i} ,'\n' ...
            '\n' ...
            '\n' ...
            'y = [' ];

        datastr_after = [ '];\n' ...
            'return\n' ...
            'end\n'];

        fprintf(fid, datastr_before);
        fprintf(fid, datastr);
        fprintf(fid, datastr_after);
    end
end