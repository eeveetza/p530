%     Class implementing Recommendation ITU-R P.530-18
%
%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    10MAY22     Ivica Stevanovic, OFCOM         Initial version

classdef P530

    methods

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                               Section 2.1                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function Aa = atmospheric_attenuation(obj, fGHz, dkm, press, rho, T)
            %atmospheric_attenuation Computes attenuation due to atmospheric gases
            %
            % Recommendation ITU-R P.530-18 § 2.1
            % Uses ITU-R P.676 and ITU-R P.836
            %
            % Inputs
            % Variable    Unit     Type     Description
            % fGHz	      GHz	   float    Frequency
            % dkm         km       float    Path length
            % press       hPa      float    Dry-air pressure
            % rho         g/m^3    float    Water vapor density
            % T           K        float    Temperature
            %
            % Outputs:
            %
            % Aa          dB       float    Attenuation due to atmospheric gases


            % Specific attenuation (dB/km) using Recommendation ITU-R P.676

            [g0, gw] = p676d11_ga(obj, fGHz, press, rho, T);

            Aa = (g0 + gw) * dkm;

        end


        function [g_0, g_w] = p676d11_ga(obj, f, p, rho, T)
            %p676d11_ga Specific attenuation due to dry air and water vapour
            % [g_0, g_w] = p676d11_ga(f, p, rho, T)
            % This function computes the specific attenuation due to dry air and water vapour,
            % at frequencies up to 1 000 GHz for different values of of pressure, temperature
            % and humidity by means of a summation of the individual resonance lines from
            % oxygen and water vapour according to ITU-R P.676-11
            %
            % Input parameters:
            % f       -   Frequency (GHz)
            % p       -   Dry air pressure (hPa)
            % rho     -   Water vapor density (g/m^3)
            % T       -   Temperature (K)
            %
            % Output parameters:
            % g_o, g_w   -   specific attenuation due to dry air and water vapour


            %% spectroscopic data for oxigen
            %             f0        a1    a2     a3   a4     a5     a6
            oxigen = [50.474214, 0.975, 9.651, 6.690, 0.0, 2.566, 6.850;
                50.987745, 2.529, 8.653, 7.170, 0.0, 2.246, 6.800;
                51.503360, 6.193, 7.709, 7.640, 0.0, 1.947, 6.729;
                52.021429, 14.320, 6.819, 8.110, 0.0, 1.667, 6.640;
                52.542418, 31.240, 5.983, 8.580, 0.0, 1.388, 6.526;
                53.066934, 64.290, 5.201, 9.060, 0.0, 1.349, 6.206;
                53.595775, 124.600, 4.474, 9.550, 0.0, 2.227, 5.085;
                54.130025, 227.300, 3.800, 9.960, 0.0, 3.170, 3.750;
                54.671180, 389.700, 3.182, 10.370, 0.0, 3.558, 2.654;
                55.221384, 627.100, 2.618, 10.890, 0.0, 2.560, 2.952;
                55.783815, 945.300, 2.109, 11.340, 0.0, -1.172, 6.135;
                56.264774, 543.400, 0.014, 17.030, 0.0, 3.525, -0.978;
                56.363399, 1331.800, 1.654, 11.890, 0.0, -2.378, 6.547;
                56.968211, 1746.600, 1.255, 12.230, 0.0, -3.545, 6.451;
                57.612486, 2120.100, 0.910, 12.620, 0.0, -5.416, 6.056;
                58.323877, 2363.700, 0.621, 12.950, 0.0, -1.932, 0.436;
                58.446588, 1442.100, 0.083, 14.910, 0.0, 6.768, -1.273;
                59.164204, 2379.900, 0.387, 13.530, 0.0, -6.561, 2.309;
                59.590983, 2090.700, 0.207, 14.080, 0.0, 6.957, -0.776;
                60.306056, 2103.400, 0.207, 14.150, 0.0, -6.395, 0.699;
                60.434778, 2438.000, 0.386, 13.390, 0.0, 6.342, -2.825;
                61.150562, 2479.500, 0.621, 12.920, 0.0, 1.014, -0.584;
                61.800158, 2275.900, 0.910, 12.630, 0.0, 5.014, -6.619;
                62.411220, 1915.400, 1.255, 12.170, 0.0, 3.029, -6.759;
                62.486253, 1503.000, 0.083, 15.130, 0.0, -4.499, 0.844;
                62.997984, 1490.200, 1.654, 11.740, 0.0, 1.856, -6.675;
                63.568526, 1078.000, 2.108, 11.340, 0.0, 0.658, -6.139;
                64.127775, 728.700, 2.617, 10.880, 0.0, -3.036, -2.895;
                64.678910, 461.300, 3.181, 10.380, 0.0, -3.968, -2.590;
                65.224078, 274.000, 3.800, 9.960, 0.0, -3.528, -3.680;
                65.764779, 153.000, 4.473, 9.550, 0.0, -2.548, -5.002;
                66.302096, 80.400, 5.200, 9.060, 0.0, -1.660, -6.091;
                66.836834, 39.800, 5.982, 8.580, 0.0, -1.680, -6.393;
                67.369601, 18.560, 6.818, 8.110, 0.0, -1.956, -6.475;
                67.900868, 8.172, 7.708, 7.640, 0.0, -2.216, -6.545;
                68.431006, 3.397, 8.652, 7.170, 0.0, -2.492, -6.600;
                68.960312, 1.334, 9.650, 6.690, 0.0, -2.773, -6.650;
                118.750334, 940.300, 0.010, 16.640, 0.0, -0.439, 0.079;
                368.498246, 67.400, 0.048, 16.400, 0.0, 0.000, 0.000;
                424.763020, 637.700, 0.044, 16.400, 0.0, 0.000, 0.000;
                487.249273, 237.400, 0.049, 16.000, 0.0, 0.000, 0.000;
                715.392902, 98.100, 0.145, 16.000, 0.0, 0.000, 0.000;
                773.839490, 572.300, 0.141, 16.200, 0.0, 0.000, 0.000;
                834.145546, 183.100, 0.145, 14.700, 0.0, 0.000, 0.000];

            %% spectroscopic data for water-vapor %Table 2, modified in version P.676-11
            %            f0       b1    b2    b3   b4   b5   b6
            vapor = [22.235080 .1079 2.144 26.38 .76 5.087 1.00;
                67.803960 .0011 8.732 28.58 .69 4.930 .82;
                119.995940 .0007 8.353 29.48 .70 4.780 .79;
                183.310087 2.273 .668 29.06 .77 5.022 .85;
                321.225630 .0470 6.179 24.04 .67 4.398 .54;
                325.152888 1.514 1.541 28.23 .64 4.893 .74;
                336.227764 .0010 9.825 26.93 .69 4.740 .61;
                380.197353 11.67 1.048 28.11 .54 5.063 .89;
                390.134508 .0045 7.347 21.52 .63 4.810 .55;
                437.346667 .0632 5.048 18.45 .60 4.230 .48;
                439.150807 .9098 3.595 20.07 .63 4.483 .52;
                443.018343 .1920 5.048 15.55 .60 5.083 .50;
                448.001085 10.41 1.405 25.64 .66 5.028 .67;
                470.888999 .3254 3.597 21.34 .66 4.506 .65;
                474.689092 1.260 2.379 23.20 .65 4.804 .64;
                488.490108 .2529 2.852 25.86 .69 5.201 .72;
                503.568532 .0372 6.731 16.12 .61 3.980 .43;
                504.482692 .0124 6.731 16.12 .61 4.010 .45;
                547.676440 .9785 .158 26.00 .70 4.500 1.00;
                552.020960 .1840 .158 26.00 .70 4.500 1.00;
                556.935985 497.0 .159 30.86 .69 4.552 1.00;
                620.700807 5.015 2.391 24.38 .71 4.856 .68;
                645.766085 .0067 8.633 18.00 .60 4.000 .50;
                658.005280 .2732 7.816 32.10 .69 4.140 1.00;
                752.033113 243.4 .396 30.86 .68 4.352 .84;
                841.051732 .0134 8.177 15.90 .33 5.760 .45;
                859.965698 .1325 8.055 30.60 .68 4.090 .84;
                899.303175 .0547 7.914 29.85 .68 4.530 .90;
                902.611085 .0386 8.429 28.65 .70 5.100 .95;
                906.205957 .1836 5.110 24.08 .70 4.700 .53;
                916.171582 8.400 1.441 26.73 .70 5.150 .78;
                923.112692 .0079 10.293 29.00 .70 5.000 .80;
                970.315022 9.009 1.919 25.50 .64 4.940 .67;
                987.926764 134.6 .257 29.85 .68 4.550 .90;
                1780.000000 17506. .952 196.3 2.00 24.15 5.00];

            a1 = oxigen(:,2);
            a2 = oxigen(:,3);
            a3 = oxigen(:,4);
            a4 = oxigen(:,5);
            a5 = oxigen(:,6);
            a6 = oxigen(:,7);

            b1 = vapor(:,2);
            b2 = vapor(:,3);
            b3 = vapor(:,4);
            b4 = vapor(:,5);
            b5 = vapor(:,6);
            b6 = vapor(:,7);



            theta = 300.0/T;

            e = rho * T / 216.7;        % equation (4)

            %% Oxigen computation
            fi = oxigen(:,1);

            Si = a1 .* 1e-7 * p * theta.^3 .*exp(a2 * (1.0 - theta));       % equation (3)

            df = a3 .* 1e-4 .* (p .* theta .^ (0.8-a4) + 1.1 * e * theta);  % equation (6a)

            % Doppler broadening

            df = sqrt( df.*df + 2.25e-6);                                   % equation (6b)

            delta = (a5 + a6 * theta) * 1e-4 * (p + e) .* theta.^(0.8);     % equation (7)

            Fi = f ./ fi .* (  (df - delta .* (fi - f))./( (fi - f).^2 + df.^2  ) + ...
                (df - delta .* (fi + f))./( (fi + f).^2 + df.^2  ));        % equation (5)

            d = 5.6e-4 * (p + e) * theta.^(0.8);                            % equation (9)

            Ndf = f * p * theta.^2 *( 6.14e-5/(d * (1 + (f/d).^2) ) + ...
                1.4e-12 * p * theta.^(1.5)/(1 + 1.9e-5 * f.^(1.5)) );       % equation (8)

            % specific attenuation due to dry air (oxygen, pressure induced nitrogen
            % and non-resonant Debye attenuation), equations (1-2)

            g_0 = 0.182 * f * (sum(Si .* Fi) + Ndf);

            %% vapor computation

            fi = vapor(:,1);

            Si = b1 .* 1e-1 .* e .* theta.^3.5 .*exp(b2 .* (1.0 - theta));      % equation (3)

            df = b3 .* 1e-4 .* (p .* theta .^ (b4) + b5 .* e .* theta.^b6);     % equation (6a)

            % Doppler broadening

            df = 0.535 .* df + sqrt( 0.217* df.*df + 2.1316e-12 * fi.*fi/theta); % equation (6b)

            delta = 0;                                                           % equation (7)

            Fi = f ./ fi .* (  (df - delta .* (fi - f))./( (fi - f).^2 + df.^2  ) + ...
                (df - delta.* (fi + f))./( (fi + f).^2 + df.^2  ));              % equation (5)

            % specific attenuation due to water vapour, equations (1-2)

            g_w = 0.182 * f * (sum(Si .* Fi) );

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                               Section 2.2                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function F1 = first_fresnel_radius(obj, f, d1, d2)
            %first_fresnel_radius Computes radius of the 1st Fresnel ellipsoid
            %
            % Recommendation ITU-R P.530-18 § 2.2.1
            %
            % Inputs
            % Variable    Unit     Type     Description
            % f  	      GHz	   float    Frequency
            % d1          km       float    Distance from 1st terminal to the path obstruction
            % d2          km       float    Distance from 2nd terminal to the path obstruction
            %
            % Outputs:
            %
            % F1          m       float    Radius of the first Fresnel ellipsoid

            F1 = 17.3 * sqrt(d1*d2/(f*(d1 + d2)));    % (3)

        end

        function Ad = diffraction_loss(obj, h, f, d1, d2)
            % Computes diffraction loss over average terrain
            %
            % Recommendation ITU-R P.530-18 § 2.2.1
            %
            % Inputs
            % Variable    Unit     Type     Description
            % h           m        float    Height difference between blockage and virtual line-of-sight
            % f  	      GHz	   float    Frequency
            % d1          km       float    Distance from 1st terminal to the path obstruction
            % d2          km       float    Distance from 2nd terminal to the path obstruction
            %
            % Outputs:
            %
            % Ad          dB       float    Diffraction loss

            Ad = -20 * h / first_fresnel_radius(obj, f, d1, d2) + 10;    % (2)

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                               Section 2.3                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function pw = multipath_fading_single_freq(obj, lon, lat, d, he, hr, ht, f, A)
            % Computes the percentage of time pw that fade depth A (dB) is
            % exceeded in the average worst month
            %
            % Recommendation ITU-R P.530-18 § 2.3.1
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % he          masl     float    Emitter antenna height
            % hr          masl     float    Receiver antenna height
            % ht          masl     float    mean terrain elevation along
            %                               the path (excluding trees)
            % f           GHz      float    Frequency
            % A           dB       float    Fade depth
            %
            % Outputs:
            %
            % pw          %        float    percentage of time that the
            %                               fade depth A is exceeded in
            %                               the average worst month
            %
            % This method is used for predicting the single-frequency (or
            % narrow-band) fading distribution at large fade depths in teh
            % average worst month in any part of the world. It does not
            % make use of the path profile and can be used for initial
            % planning, licensing, or design purposes.
            % It is valid for small percentages of time
            % it needs to be calculated for path lenghts longer than 5 km,
            % and can be set to zero for shorter paths

            %% Step 1 of §2.3.1
            % Estimate the geoclimatic factor K and dN75 for the average worst month
            % from from table LogK and dN75

            logK_m = get_interp2(obj, 'LogK', lon, lat);

            dN75 = get_interp2(obj, 'dN75', lon, lat);

            K = 10.^(logK_m);

            %% Step 2 of §2.3.1

            ep = abs(hr - he)/d;

            hc = 0.5*(hr + he) - d^2/102 - ht;

            hL = min(he, hr);

            %% Step 3 of §2.3.1

            vsrlim = dN75 * d.^(1.5) * f.^(0.5)/24730;

            vsr = min( (dN75/50.0).^(1.8) * exp(-hc/(2.5*sqrt(d))), vsrlim);

            arg = -0.376*tanh((hc-147)/125)-0.334*ep.^(0.39)-0.00027*hL + 17.85*vsr - A/10;
            pw = K*d.^(3.51)*(f.^2 + 13).^(0.447)*10.^(arg);

        end

        function pw = multipath_fading(obj, lon, lat, d, he, hr, ht, f, A)
            % Computes the percentage of time pw that fade depth A (dB) is
            % exceeded in the average worst month
            %
            % Recommendation ITU-R P.530-18 § 2.3.2
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % he          masl     float    Emitter antenna height
            % hr          masl     float    Receiver antenna height
            % ht          masl     float    mean terrain elevation along
            %                               the path (excluding trees)
            % f           GHz      float    Frequency
            % A           dB       float    Fade depth
            %
            % Outputs:
            %
            % pw          %        float    percentage of time that the
            %                               fade depth A is exceeded in
            %                               the average worst month
            %
            % This method predicts the percentage of time that any fade
            % depth is exceeded

            %% Step 1 of §2.3.2

            p0 = multipath_fading_single_freq(obj, lon, lat, d, he, hr, ht, f, 0.0);

            %% Step 2
            At = 25 + 1.2*log10(p0);

            if A >= At
                %% Step 3a
                pw = p0* 10.^(-A/10);

            else
                %% Step 3b
                pt = p0*10.^(-At/10);
                qap = -20*log10( -log( (100-pt)/100) )/At;
                qt = (qap-2)/((1+0.3*10.^(-At/20))*10.^(-0.016*At)) - 4.3*(10.^(-At/20) + At/800);

                qa = 2 + (1 + 0.3 * 10.^(-A/20)) * (10^(-0.016*A)) * (qt + 4.3 *(10.^(-A/20) + A/800));

                pw = 100 * (1 - exp(-10^(-qa*A/20)));
            end

        end

        function pw = duct_enhancement(obj, lon, lat, d, he, hr, ht, f, E)
            % Computes the percentage of time pw that enhancement E (dB) is
            % not exceeded
            %
            % Recommendation ITU-R P.530-18 § 2.3.3
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % he          masl     float    Emitter antenna height
            % hr          masl     float    Receiver antenna height
            % ht          masl     float    mean terrain elevation along
            %                               the path (excluding trees)
            % f           GHz      float    Frequency
            % A           dB       float    Fade depth
            %
            % Outputs:
            %
            % pw          %        float    percentage of time that the
            %                               fade depth A is exceeded in
            %                               the average worst month


            %% Step 1 of §2.3.2

            p0 = multipath_fading_single_freq(obj, lon, lat, d, he, hr, ht, f, 0.0);

            A001 = 10 * log10(p0/0.01);

            % Average worst month enhancement above 10 dB should be
            % predicted using (19)

            if (E > 10)

                pw = 100 - 10.^((-1.7 + 0.2 * A001 - E) / 3.5);

            elseif (E > 0)

                Ep = 10;

                % Step 1
                pwp =  100 - 10.^((-1.7 + 0.2 * A001 - Ep) / 3.5);

                % Step 2
                qep = -20/Ep * (log10(-log( 1 - (100-pwp)/58.21 )));

                % Step3
                qs = 2.05 * qep - 20.3;

                % Step 4
                qe = 8 + (1 + 0.3*10.^(-E/20)) * (10.^(-0.7*E/20)) * ...
                    (qs + 12 * (10.^(-E/20) + E/800));

                % Step 5
                pw = 100 - 58.21*(1-exp(-10.^(-qe*E/20)));


            else

                error('Enhancement E must be positive.')


            end

        end

        function p = multipath_fading_single_freq_annual(obj, lon, lat, d, he, hr, ht, f, A)
            % Computes the percentage of time pw that fade depth A (dB) is
            % exceeded in the average year
            %
            % Recommendation ITU-R P.530-18 § 2.3.4
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % he          masl     float    Emitter antenna height
            % hr          masl     float    Receiver antenna height
            % ht          masl     float    mean terrain elevation along
            %                               the path (excluding trees)
            % f           GHz      float    Frequency
            % A           dB       float    Fade depth
            %
            % Outputs:
            %
            % p          %        float    percentage of time that the
            %                               fade depth A is exceeded in
            %                               the average year
            %
            % This method is used for predicting the single-frequency (or
            % narrow-band) fading distribution at large fade depths in teh
            % average worst month in any part of the world. It does not
            % make use of the path profile and can be used for initial
            % planning, licensing, or design purposes.
            % It is valid for small percentages of time
            % it needs to be calculated for path lenghts longer than 5 km,
            % and can be set to zero for shorter paths

            %% Step 1 of §2.3.4
            % Calculate the percentage of time pw fade depth A is exceeded
            % in the large tail of the distribution for the average worst
            % month from equation (7)

            pw = multipath_fading_single_freq(obj, lon, lat, d, he, hr, ht, f, A);

            %% Step 2 of §2.3.4
            % Calculated the logarithmic geoconversion factor
            ep = abs(hr - he)/d;
            ksi = abs(lat); % latitude, North or South

            DG = 10.5 - 5.6*log10(1.1 + sign(45-ksi) * (abs(cosd(2*ksi))).^0.7) ...
                - 2.7*log10(d) + 1.7*log10(1 + abs(ep));

            DG = max(DG, 10.8);

            p = 10.^(-DG/10) * pw;

        end

        function p = multipath_fading_annual(obj, lon, lat, d, he, hr, ht, f, A)
            % Computes the percentage of time pw that fade depth A (dB) is
            % exceeded in the average year
            %
            % Recommendation ITU-R P.530-18 § 2.3.4
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % he          masl     float    Emitter antenna height
            % hr          masl     float    Receiver antenna height
            % ht          masl     float    mean terrain elevation along
            %                               the path (excluding trees)
            % f           GHz      float    Frequency
            % A           dB       float    Fade depth
            %
            % Outputs:
            %
            % p           %        float    percentage of time that the
            %                               fade depth A is exceeded in
            %                               the average year
            %
            % This method predicts the percentage of time that any fade
            % depth is exceeded

            %% Step 1 of §2.3.2

            p0 = multipath_fading_single_freq(obj, lon, lat, d, he, hr, ht, f, 0.0);

            %% Step 2 of §2.3.2
            At = 25 + 1.2*log10(p0);


            %% Step 3b of §2.3.2

            pt = p0*10.^(-At/10);    %(14)

            %% Step 2 of §2.3.4
            % Calculated the logarithmic geoconversion factor
            ep = abs(hr - he)/d;
            ksi = abs(lat); % latitude, North or South

            DG = 10.5 - 5.6*log10(1.1 + sign(45-ksi) * (abs(cosd(2*ksi))).^0.7) ...
                - 2.7*log10(d) + 1.7*log10(1 + abs(ep));

            DG = max(DG, 10.8);

            %% Step 4.1) of §2.3.4

            pt = 10.^(-DG/10) * pt;

            qap = -20*log10( -log( (100-pt)/100) )/At;     %(15)

            %% Step 4.2) of §2.3.4

            qt = (qap-2)/((1+0.3*10.^(-At/20))*10.^(-0.016*At)) - 4.3*(10.^(-At/20) + At/800);   %(16)

            qa = 2 + (1 + 0.3 * 10.^(-A/20)) * (10^(-0.016*A)) * (qt + 4.3 *(10.^(-A/20) + A/800));   %(17)

            p = 100 * (1 - exp(-10^(-qa*A/20)));  % (18)


        end

        function p = duct_enhancement_annual(obj, lon, lat, d, he, hr, ht, f, E)
            % Computes the percentage of time (average year) that enhancement E (dB) is
            % not exceeded
            %
            % Recommendation ITU-R P.530-18 § 2.3.4, Step 5
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % he          masl     float    Emitter antenna height
            % hr          masl     float    Receiver antenna height
            % ht          masl     float    mean terrain elevation along
            %                               the path (excluding trees)
            % f           GHz      float    Frequency
            % A           dB       float    Fade depth
            %
            % Outputs:
            %
            % p          %        float    percentage of time that the
            %                               fade depth A is exceeded in
            %                               the average year
            %

            %% Step 2 of §2.3.4
            % Calculate the logarithmic geoconversion factor

            ep = abs(hr - he)/d;
            ksi = abs(lat); % latitude, North or South

            DG = 10.5 - 5.6*log10(1.1 + sign(45-ksi) * (abs(cosd(2*ksi))).^0.7) ...
                - 2.7*log10(d) + 1.7*log10(1 + abs(ep));

            DG = max(DG, 10.8);

            % Obtain pw by inverting equation (25) with p = 0.01%

            pw = 0.01 * 10.^(DG/10);

            %% Step 1 of §2.3.2

            p0 = multipath_fading_single_freq(obj, lon, lat, d, he, hr, ht, f, 0.0);

            A001 = 10 * log10(p0/pw); % inverting equation (7)


            % Average worst month enhancement above 10 dB should be
            % predicted using (19)

            if (E > 10)

                p = 100 - 10.^((-1.7 + 0.2 * A001 - E) / 3.5);

            elseif (E > 0)

                Ep = 10;

                % Step 1
                pwp =  100 - 10.^((-1.7 + 0.2 * A001 - Ep) / 3.5);

                % Step 2
                qep = -20/Ep * (log10(-log( 1 - (100-pwp)/58.21 )));

                % Step3
                qs = 2.05 * qep - 20.3;

                % Step 4
                qe = 8 + (1 + 0.3*10.^(-E/20)) * (10.^(-0.7*E/20)) * ...
                    (qs + 12 * (10.^(-E/20) + E/800));

                % Step 5
                p = 100 - 58.21*(1-exp(-10.^(-qe*E/20)));

            else

                error('Enhancement E must be positive.')

            end

        end

        function psw = pw2psw(obj, pw, T, cs)
            % Converts the percentage of time pw of exceeding a deep fade A
            % in the average worst month to a percentage of time psw of
            % exceeding the same deep fade during a shorter worst period
            % of time T
            %
            % Recommendation ITU-R P.530-18 § 2.3.5
            %
            % Inputs
            % Variable    Unit     Type     Description
            % pw          %        float    Percentage of time (worst month)
            % T           hours    float    Worst period of time
            % cs          -        int      0 - relatively flat paths
            %                               1 - hilly paths
            %                               2 - hilly land paths
            % Outputs:
            %
            % psw         %        float    percentage of time for shorter
            %                               worst period of time T


            if (T < 1 || T >= 720)
                error ('Short worst period of time must be within the interval [1, 720) h');
            end

            switch cs
                case 0

                    psw = pw *(89.34 * T.^(-0.854) + 0.676);

                case 1

                    psw = pw *(119 * T.^(-0.78) + 0.295);

                case 2

                    psw = pw *(199.85 * T.^(-0.834) + 0.175);

                otherwise

                    error('Allowed values for cs are 0, 1, or 2');
            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                               Section 2.4.1                             %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function [gammaR, alpha] = specific_rain_attenuation_p838(obj,  R, f, theta, pol )
            %p838 Recommendation ITU-R P.838-3
            %   This function computes the specific rain attenuation for
            %   a given rain rate, frequency, path inclination and polarization
            % according to ITU-R Recommendation P.838-3
            %
            %     Input parameters:
            %     R        -   Rain rate (mm/h)
            %     f        -   Frequency (GHz): from 1 to 1000 GHz
            %     theta    -   Path inclination (radians)
            %     pol      -   Polarization 0 = horizontal, 1 = vertical, 2 = circular
            %
            %     Output parameters:
            %     gammaR -   specific rain attenuation (dB/km)
            %     alpha  -   exponent in the specific attenuation (-)

            if (f < 1 || f > 1000)
                warning('Frequency out of valid band [1, 1000] GHz.');
            end

            if pol == 0 % horizontal polarization

                tau = 0;

            elseif (pol == 1) % vertical polarization

                tau = pi/2;

            else % circular polarization

                tau = pi/4;

            end

            % Coefficients for kH
            Table1 = [  -5.33980 -0.10008 1.13098
                -0.35351 1.26970 0.45400
                -0.23789 0.86036 0.15354
                -0.94158 0.64552 0.16817];

            aj_kh = Table1(:,1);
            bj_kh = Table1(:,2);
            cj_kh = Table1(:,3);
            m_kh = -0.18961;
            c_kh = 0.71147;

            % Coefficients for kV

            Table2 = [  -3.80595 0.56934 0.81061
                -3.44965 -0.22911 0.51059
                -0.39902 0.73042 0.11899
                0.50167 1.07319 0.27195];

            aj_kv = Table2(:,1);
            bj_kv = Table2(:,2);
            cj_kv = Table2(:,3);
            m_kv = -0.16398;
            c_kv = 0.63297;

            % Coefficients for aH

            Table3 = [  -0.14318 1.82442 -0.55187
                0.29591 0.77564 0.19822
                0.32177 0.63773 0.13164
                -5.37610 -0.96230 1.47828
                16.1721 -3.29980 3.43990];

            aj_ah = Table3(:,1);
            bj_ah = Table3(:,2);
            cj_ah = Table3(:,3);
            m_ah  = 0.67849;
            c_ah  = -1.95537;

            % Coefficients for aV

            Table4 = [  -0.07771 2.33840 -0.76284
                0.56727 0.95545 0.54039
                -0.20238 1.14520 0.26809
                -48.2991 0.791669 0.116226
                48.5833 0.791459 0.116479];

            aj_av = Table4(:,1);
            bj_av = Table4(:,2);
            cj_av = Table4(:,3);
            m_av = -0.053739;
            c_av = 0.83433;

            logkh = sum(aj_kh.* exp(-((log10(f)-bj_kh)./cj_kh).^2)) + m_kh*log10(f) + c_kh;
            kh = 10.^(logkh);

            logkv = sum(aj_kv.* exp(-((log10(f)-bj_kv)./cj_kv).^2)) + m_kv*log10(f) + c_kv;
            kv = 10.^(logkv);

            ah = sum(aj_ah.* exp(-((log10(f)-bj_ah)./cj_ah).^2)) + m_ah*log10(f) + c_ah;

            av = sum(aj_av.* exp(-((log10(f)-bj_av)./cj_av).^2)) + m_av*log10(f) + c_av;

            k = (kh + kv + (kh - kv)*(cos(theta))^2 * cos(2*tau))/2;

            alpha = (kh*ah + kv*av + (kh*ah - kv*av)*(cos(theta))^2 * cos(2*tau))/(2*k);

            gammaR = k * R.^alpha;

        end


        function Ap = rain_attenuation_statistics(obj, lon, lat, d, f, p, pol, theta, varargin)
            % Computes long-term statistics of rain attenuation
            %
            % Recommendation ITU-R P.530-18 § 2.4.1
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % f           GHz      float    Frequency
            % p           %        float    Percentage of time
            % pol         -        int      0 - horizontal
            %                               1 - vertical
            % theta       rad      float    Path inclination
            % Optional Inputs
            % R001        %        float    Rain rate exceeded for 0.01%
            %                               of the time (integration 1 min)
            %
            % Outputs:
            %
            % Ap          %        float    attenuation exceeded for
            %                      percentage of time p

            %% Read the input arguments and check them

            if (p<0.001 || p > 1)
                warning('Percentage of time outside the valid range [0.001, 1]%');
            end
            iP = inputParser;
            % Parse the optional input
            iP.addParameter('R001',[])
            iP.parse(varargin{:});

            % Step 1: Obtain the rain rate R001 exceeded for 0.01% of the
            % time with an integration time of 1 min

            R001 = iP.Results.R001;

            if isempty(R001)
                % estimate the value from Recommendation ITU-R P.837

                R001 = get_interp2(obj, 'R001', lon, lat);

            end

            % Step 2: Compute the specific attenuation for frequency,
            % polarization and rain rate using P.838

            [gammaR, alpha] = specific_rain_attenuation_p838(obj, R001, f, theta, pol );

            % Step 3: Compute the effective path length

            r = 1.0/(0.477*d.^0.633 * R001.^(0.073* alpha) * f.^0.123 - ...
                10.579*(1-exp(-0.024*d)));

            deff = r * d;

            % Step 4: An estimate of the path attenuation exceeded for
            % 0.01% of the time

            A001 = gammaR * deff;

            % Step 5: attenuation exceeded for other percentages of time in
            % the range 0001% to 1%

            C0 = 0.12;

            if f >= 10

                C0 = 0.12 + 0.4 * log10((f/10)^0.8);

            end

            C1 = (0.07.^C0)*(0.12.^(1-C0));
            C2 = 0.855*C0 + 0.546*(1-C0);
            C3 = 0.139*C0 + 0.043*(1-C0);

            Ap = A001 * C1 * p.^(-(C2 + C3*log10(p)));


        end



        function A2 = scale_rain_statistics_f(obj, f1, A1, f2)
            % Scales long-term statistics of rain attenuation with
            % frequency
            %
            % Recommendation ITU-R P.530-18 § 2.4.3
            %
            % Inputs
            % Variable    Unit     Type     Description
            % f1          GHz      float    Available frequency
            % A1          dB       float    Long term attenuation at f1
            % f2          GHz      float    Sought for frequency
            %
            % Outputs:
            %
            % A2          %        float    Long term attenuation at f2
            %
            % Rough estimate for frequencies in the range 7 to 50 GHz for
            % the same hop lenght and in the same climatic region

            F1 = f1^2/(1+1e-4*f1^2);
            F2 = f2^2/(1+1e-4*f2^2);

            H = 1.12e-3 * sqrt(F2/F1) * (F1 * A1).^0.55;

            A2 = A1 * (F2/F1)^(1 - H);
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                               Section 2.4.2                             %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function rain_snow_flag = preliminary_test(obj, h1, h2, lon, lat)
            % Performs preliminary tests and decides on which method to use
            %
            % Recommendation ITU-R P.530-18 § 2.4.2.1
            %
            % Inputs:
            % Variable    Unit     Type     Description
            % h1, h2      masl     float    Link terminal heights in masl
            % lon, lat    deg      float    Longitude/Latitude of the path location
            %
            % Outputs:
            % rain_snow_flag  -    int      flag set to 1 for attenuation due to rain only,
            %                                    set to 2 when attenuation due to precipitation can be taken to be zero and
            %                                    set to 3 when combined effect of rain/wet-snow model needs to be used

            % Calcluate lower and higher antenna heights (37)
            hlo = min(h1, h2);
            hhi = max(h1, h2);

            % Obtain the mean rain height (masl) from Recommendation ITU-R P.839

            hrainm = get_interp2(obj, 'h0', lon, lat);

            if (hhi <= hrainm - 3600)
                rain_snow_flag = 1;
            elseif(hlo > hrainm + 2400)
                rain_snow_flag = 2;
            else
                rain_snow_flag = 3;
            end

        end


        function [T, A, P0, Arainp] = preliminary_calculation(obj, lon, lat, d, f, p, pol, theta)
            % Computes preliminary values
            %
            % Recommendation ITU-R P.530-18 § 2.4.2.2
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % f           GHz      float    Frequency
            % p           %        float    Percentage of time
            % pol         -        int      0 - horizontal
            %                               1 - vertical
            % theta       rad      float    Path inclination
            %
            % Outputs:
            %
            % T          %        array    Percentage time (decreasing logarithmically at 10 values per decade)
            % A          dB       array    Rain-only attenuations exceeded for each percentage of time in T
            % P0         %        float    Percentage probability of rain in an average year
            % Arainp     dB       float    Rain attenuation exceeded for the percentage time P0

            % i) rain-only attenuation exceeded for the required percentage time

            Arainp = rain_attenuation_statistics(obj, lon, lat, d, f, p, pol, theta);

            % ii) Vectors of rain-only attenunation and corresponding
            % percentage time
            % From Annex 1 of Rec. ITU-R P.837-6
            % Compute Pr6, Mt and beta by bi-linear interpolation from data

            Pr6 = get_interp2('Esarain_Pr6',lon,lat);
            Mt  = get_interp2('Esarain_Mt', lon,lat);
            beta = get_interp2('Esarain_Beta', lon, lat);

            % Convert Mt and beta to Mc and Ms
            Mc = beta * Mt;
            Ms = (1-beta)*Mt;

            % derive the percentage probability of rain in an average year
            if Pr6 == 0
                P0 = 0;
                Rp = 0;
            else
                P0 = Pr6*(1-exp(-0.0079*(Ms/Pr6)));


                % derive the rainfall rate Rp exceeded for p% of the average
                % year where p <= P0

                a = 1.09;
                b = (Mc + Ms)/(21797 * P0);
                c = 26.02*b;

                A = a*b;
                B = a + c*log(p/P0);
                C = log(p/P0);

                Rp = (-B + sqrt(B^2-4*A*C))/(2*A);
            end

            T(1) = P0;
            A(1) = 0;
            t = 1;
            while (1)
                T(t+1) = P0*10^(-0.1*t); % % of time Eq (40)
                % possibly simplify the following function as many values
                % remain constant, but I do not see how, as the function
                % only calls for R001 which is obtained from the map?

                A(t+1) = rain_attenuation_statistics(obj, lon, lat, d, f, T(t+1), pol, theta); % Eq (41)

                if (T(t+1) < 0.001 || A(t+1)-A(t) <= 0.1)
                    break;
                end

                t = t + 1;

            end
        end


        function G = attenuation_multiplier(obj, dh)
            % Function 1: Attenuation multiplier
            %
            % Recommendation ITU-R P.530-18 § 2.4.2.4
            %
            % Variable    Unit     Type     Description
            %
            % Inputs:
            % dh          m        float    Height of interest relative to the rain height
            %
            % Outputs:
            % G           n.u.     float    Variation of specific attenuation


            % Eq (43)

            G = 0;

            if (dh < -1200)

                G = 1;

            elseif (dh >= -1200 && dh <= 0)

                G = 4.0 * (1 - exp(dh / 70)).^2 / ( 1 + ( 1 - exp(-((dh/600).^2)) ).^2 * ( 4 * (1 - exp(dh / 70 ) ).^2 -1 ) );

            end
        end

        function g = path_averaged_multiplier(obj, hrain, hlo, hhi)
            % Function 2: Path-averaged multiplier
            %
            % Recommendation ITU-R P.530-18 § 2.4.2.4
            %
            % Variable    Unit     Type     Description
            %
            % Inputs:
            % hrain       m        float    Rain height above mean sea level
            % hlo,hhi     m        float    lowest and highest heights of the radio path evaluated in §2.4.2.1
            % Outputs:
            % G           n.u.     float    Path-averaged multiplier

            % Calculate the indices of the lowest and highest slices
            % occupied by any part of the path

            slo = 1 + floor((hrain-hlo)/100);   % (44a)
            shi = 1 + floor((hrain-hhi)/100);   % (44b)

            if (slo < 1) % the path is wholly above the melting layer
                g = 0;
                return
            end

            if (shi > 12) % the path is wholly below the melting layer
                g = 1;
                return
            end

            if (slo == shi) % the path is sholly within one slice of the melting layer
                dh = 0.5 * (hlo + hhi) - hrain;
                g = attenuation_multiplier(dh);
                return
            end

            % In the following, the path traverses more than one slice of
            % the melting layer and parts of the path may exist below and
            % above the layyer

            % Calculate the first and last slice indices to be taken into
            % account int he loop

            sfirst = max(shi, 1);
            slast = min(slo, 12);

            % Initialize the multiplier to zero to be used as an
            % accumulator

            g = 0;

            for s = sfirst : slast  % For each slice index including sfirst and slast

                if (shi < s && s < slo) % the path fully traverses the slice
                    dh = 100.0 *  (0.5 - s); % m (47a)
                    q = 100.0 / (hhi - hlo); %   (47b)
                elseif (s == slo) % the lower of the antennas is within the slice
                    dh = 0.5 * (hlo - hrain - 100 * (s-1));  % m (48a)
                    q = (hrain - 100 * (s-1) - hlo) / (hhi - hlo);  % (48b)
                elseif (s == shi) % the higher of the antennas is within the slice
                    dh = 0.5 * (hhi - hrain - 100*s); % m (49a)
                    q = (hhi - hrain + 100*s) / (hhi - hlo);  %(49b)
                end

                % Use function 1 to calculate the attenuation multiplier
                % for the slice

                gslice = attenuation_multiplier(dh);  % (50)

                % Accumulate the multiplier weighted by the fraction of the
                % path within the slice

                g = g + q * gslice;  % (51)

            end

            if (slo > 12) % part of the path is below the melting layer
                % Calculate the fraction of the path which is below the
                % layer

                q = (hrain - 1200 - hlo) / (hhi - hlo);  % (52)

                % since the attenuation multiplier is 1, accumulate this
                % path fraction

                g = g + q;
            end

        end


        function T0 = A2T(obj, T, A, A0)
            % Function 3: Percentage time as function of rain-only
            % attenuation
            %
            % Recommendation ITU-R P.530-18 § 2.4.2.4
            %
            % Variable    Unit     Type     Description
            %
            % Inputs:
            % T          %        array    Percentage time computed in §2.4.2.2
            % A          dB       array    Rain-only attenuations exceeded for each percentage of time in T as computed in §2.4.2.2
            % A0         dB       float    Given rain-only attenuation
            % Outputs:
            % T0         %        float    Percentage time for which the given rain only attenuation A0 is exceeded

            if (A0 > A(end))
                T0 = 10.^( A(end) - A + log10(T(end)) );  % (54)
            else
                % set inferior and superior indices for A ant T to initial
                % values bracketing the complete vectors (55a), (55b)
                % Note that here we use 1-index and not 0-index base
                kinf = 1;
                ksup = length(T);

                while(ksup - kinf > 1)
                    ktry = (floor(kinf + ksup)/2.0);  % (56)
                    if (A(ktry) < A)
                        kinf = ktry;
                    else
                        ksup = ktry;
                    end
                end

                % the required percentage of time is approximated by
                % logarithmic interpolation

                u = log10(T(ksup)) + log10(T(kinf)/T(ksup)) * (A(ksup) - A) / (A(ksup) - A(kinf)); % (57a)

                T0 = 10.^u;


            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                               Section 4                                 %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        function Pxp = XPD_outage_clear_air(obj, lon, lat, d, he, hr, ht, f, cir, xpdg, varargin )
            % Computes cross-polar discrimination (XPD) outage due to clear-air
            % effects
            %
            % Recommendation ITU-R P.530-18 § 4.1
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % he          masl     float    Emitter antenna height
            % hr          masl     float    Receiver antenna height
            % ht          masl     float    mean terrain elevation along
            %                               the path (excluding trees)
            % f           GHz      float    Frequency
            % xpdg        dB       float    Minimum Tx/Rx XPD at boresight
            %                               guaranteed by manufacturer
            % cir         dB       float    Carrier-to-Interference ratio
            %                               for a reference BER
            % st          m        float    In case of two transmit
            %                               antennas, their vertical separation
            %                               otherwise use []
            % xpif        dB       float    laboratory-measure
            %                               cross-polarization imporvement
            %                               factor, typical value 20 dB
            %
            % Outputs:
            %
            % Pxp         -        float    XPD outage due to clear-air
            %                               effects
            %

            % check if there are one or two transmit antennas
            st = [];
            xpif = [];
            if nargin >= 11
                st = varargin{11};
                if (nargin == 12)
                    xpif = varargin{11};
                end
            end

            % Step 1: Compute XPD0

            xpd0 = 40;
            if (xpdg <= 35)
                xpd0 = xpdg + 5;
            end

            % Step 2: evaluate the multipath activity parameter

            P0 = multipath_fading_single_freq_annual(obj, lon, lat, d, he, hr, ht, f, 0)/100;

            eta = 1 - exp(-0.2*P0^0.75);

            % Step 3: Determine Q

            kXP = 0.7;

            if(~isempty(st))
                lam = 0.2998/f;
                kXP =1 - 0.3 * exp(-4 * 1e-6 * (st/lam).^2);
            end

            Q = -10*log10(kXP * eta / P0);

            % Step 4:

            C = xpd0 + Q;

            % Step 5:

            Mxpd = C - cir;
            if (~isempty(xpif))
                Mxpd = Mxp + xpif;
            end

            Pxp = P0 * 10.^(-Mxpd/10);

        end

        function Pxpr = XPD_outage_precipitation(obj, lon, lat, d, f, pol, theta, cir, U0, xpif )
            % Computes cross-polar discrimination (XPD) outage due to
            % precipitation
            %
            % Recommendation ITU-R P.530-18 § 4.2
            %
            % Inputs
            % Variable    Unit     Type     Description
            % lon, lat    deg      float    Longitude/Latitude of the path location
            % d           km       float    Path distance
            % f           GHz      float    Frequency
            % pol         -        int      0 - horizontal
            %                               1 - vertical
            % theta       rad      float    Path inclination
            %                               of the time (integration 1 min)
            % xpdg        dB       float    Minimum Tx/Rx XPD at boresight
            %                               guaranteed by manufacturer
            % cir         dB       float    Carrier-to-Interference ratio
            %                               for a reference BER
            % U0          dB       float    U Coefficient
            % st          m        float    In case of two transmit
            %                               antennas, their vertical separation
            %                               otherwise use []
            % xpif        dB       float    laboratory-measure
            %                               cross-polarization imporvement
            %                               factor, typical value 20 dB
            %
            % Outputs:
            %
            % Pxpr        -        float    XPD outage due precipitation
            %


            % Step 1: Determine A001 from equation (34)

            A001 = rain_attenuation_statistics(obj, lon, lat, d, f, 0.01, pol, theta);

            % Step 2:

            U = U0 + 30*log10(f);
            if f <= 20
                V = 12.8 * f.^0.19;
            else
                V = 22.6;
            end

            Ap = 10.^( (U - cir + xpif)/V );

            % Step 3:

            m = min(40, 23.26 * log10(Ap / (0.12*A001) ) );

            n = (-12.7 + sqrt(161.23 - 4*m) )/2.0;

            % Step 4:

            Pxpr = 10.^(n-2);

        end

        function y = get_interp2(obj, mapstr, phie, phin)
            %get_inter2 Interpolates the value from Map at a given phie,phin
            %
            %     Input parameters:
            %     mapstr  -   string pointing to the radiometeorological map
            %     phie    -   Longitude, positive to east (deg) (-180, 180)
            %     phin    -   Latitude, positive to north (deg) (-90, 90)
            %
            %     Output parameters:
            %     y      -    Interpolated value from the radiometeorological map at the point (phie,phin)
            %
            %     Rev   Date        Author                          Description
            %     -------------------------------------------------------------------------------
            %     v0    09SEP24     Ivica Stevanovic, OFCOM         Initial version


            if (phin < -90 || phin > 90)
                error ('Latitude must be within the range -90 to 90 degrees');
            end

            if (phie < -180 || phie > 180)
                error('Longitude must be within the range -180 to 180 degrees');
            end

            errorstr = sprintf(['DigitalMaps_%s() not found. \n' ...
                '\nBefore running get_interp2, make sure to: \n' ...
                '    1. Download and extract the required maps to ./private/maps:\n' ...
                '        - From ITU-R P.530-18: LogK.csv and dN75.csv\n' ...
                '        - From ITU-R P.2001-5: Esarain_Beta_v5.txt, Esarain_Mt_v5.txt, Esarain_Pr6_v5.txt, h0.txt\n' ...
                '        - From ITU-R P.837-7: R001.TXT\n' ...
                '    2. Run the script initiate_digital_maps.m to generate the necessary functions.\n'], mapstr);


            switch mapstr

                case 'DN50'
                    try
                        map = DigitalMaps_DN50();
                    catch
                        error(errorstr);
                    end
                    nr = 121;
                    nc = 241;
                    spacing = 1.5;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with 0
                    longitudeOffset = phie;
                    if phie < 0
                        longitudeOffset = phie + 360;
                    end


                case 'N050'
                    try
                        map = DigitalMaps_N050();
                    catch
                        error(errorstr);
                    end
                    nr = 121;
                    nc = 241;
                    spacing = 1.5;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with 0
                    longitudeOffset = phie;
                    if phie < 0
                        longitudeOffset = phie + 360;
                    end

                case 'h0'
                    try
                        map = DigitalMaps_h0();
                    catch
                        error(errorstr);
                    end
                    nr = 121;
                    nc = 241;
                    spacing = 1.5;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with 0
                    longitudeOffset = phie;
                    if phie < 0
                        longitudeOffset = phie + 360;
                    end


                case 'Esarain_Pr6'
                    try
                        map = DigitalMaps_Esarain_Pr6_v5();
                    catch
                        error(errorstr);
                    end
                    nr = 161;
                    nc = 321;
                    spacing = 1.125;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with 0
                    longitudeOffset = phie;
                    if phie < 0
                        longitudeOffset = phie + 360;
                    end

                case 'Esarain_Mt'
                    try   map = DigitalMaps_Esarain_Mt_v5();
                    catch
                        error(errorstr);
                    end
                    nr = 161;
                    nc = 321;
                    spacing = 1.125;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with 0
                    longitudeOffset = phie;
                    if phie < 0
                        longitudeOffset = phie + 360;
                    end

                case 'Esarain_Beta'
                    try
                        map = DigitalMaps_Esarain_Beta_v5();
                    catch
                        error(errorstr);
                    end
                    nr = 161;
                    nc = 321;
                    spacing = 1.125;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with 0
                    longitudeOffset = phie;
                    if phie < 0
                        longitudeOffset = phie + 360;
                    end

                case 'dN75'
                    try
                        map = DigitalMaps_dN75();
                    catch
                        error(errorstr);
                    end
                    nr = 721;
                    nc = 1441;
                    spacing = 0.25;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with -180
                    longitudeOffset = phie + 180;


                case 'LogK'
                    try
                        map = DigitalMaps_LogK();
                    catch
                        error(errorstr);
                    end
                    nr = 721;
                    nc = 1441;
                    spacing = 0.25;
                    % lat starts with 90
                    latitudeOffset = 90 - phin;
                    % lon starts with -180
                    longitudeOffset = phie + 180;


                case 'R001'
                    try
                        map = DigitalMaps_R001();
                    catch
                        error(errorstr);
                    end
                    nr = 1441;
                    nc = 2881;
                    spacing = 0.125;
                    % lat starts with -90
                    latitudeOffset = phin + 90;
                    % lon starts with -180
                    longitudeOffset = phie + 180;

                otherwise

                    error('Error in function call. Uknown map: %s.\n',mapstr);
            end


        latitudeIndex  = floor(latitudeOffset / spacing)  + 1;
        longitudeIndex = floor(longitudeOffset / spacing) + 1;

        latitudeFraction  = (latitudeOffset / spacing)  - (latitudeIndex  - 1);
        longitudeFraction = (longitudeOffset / spacing) - (longitudeIndex - 1);

        val_ul = map(latitudeIndex, longitudeIndex);
        val_ur = map(latitudeIndex, min(longitudeIndex + 1, nc));
        val_ll = map(min(latitudeIndex + 1, nr), longitudeIndex);
        val_lr = map(min(latitudeIndex + 1, nr), min(longitudeIndex + 1, nc));

        y1 = longitudeFraction  * ( val_ur - val_ul ) + val_ul;
        y2 = longitudeFraction  * ( val_lr - val_ll ) + val_ll;
        y  = latitudeFraction * ( y2 - y1 ) + y1;

        return
    end

        function y = test_get_interp2(obj, mapstr)
            % This script tests the interpolation routines against MATLAB 2D
            % interpolation routines

            % N-random latitudes and longitudes to define N^2 points in which we will
            % be interpolating
            N = 10;
            Phin = (2*rand(N,1)-1)*90;
            Phie = (2*rand(N,1)-1)*180;


            N1 = zeros(length(Phin),length(Phie));
            N2 = zeros(length(Phin),length(Phie));

            fprintf(1,'Testing get_interp2(''%s'',.):\n',mapstr)

            tic
            for nn = 1:length(Phin)
                for ee = 1:length(Phie)
                    phim_e = Phie(ee);
                    phim_n = Phin(nn);
                    N2(nn,ee) = get_interp2(obj, mapstr, phim_e,phim_n);

                end
            end
            toc


            switch mapstr
                case 'DN50'
                    map = DigitalMaps_DN50();
                    spacing = 1.5;
                    latcnt = 90:-spacing:-90;               
                    loncnt = 0:spacing:360;

                case 'N050'
                    map = DigitalMaps_N050();
                    spacing = 1.5;
                    latcnt = 90:-spacing:-90;               
                    loncnt = 0:spacing:360;

                case 'h0'
                    map = DigitalMaps_h0();
                    spacing = 1.5;
                    latcnt = 90:-spacing:-90;               
                    loncnt = 0:spacing:360;


                case 'Esarain_Pr6'
                    map = DigitalMaps_Esarain_Pr6_v5();
                    spacing = 1.125;
                    latcnt = 90:-spacing:-90;               
                    loncnt = 0:spacing:360;

                case 'Esarain_Mt'
                    map = DigitalMaps_Esarain_Mt_v5();
                    spacing = 1.125;
                    latcnt = 90:-spacing:-90;               
                    loncnt = 0:spacing:360;

                case 'Esarain_Beta'
                    map = DigitalMaps_Esarain_Beta_v5();
                    spacing = 1.125;
                    latcnt = 90:-spacing:-90;               
                    loncnt = 0:spacing:360;

                case 'dN75'
                    map = DigitalMaps_dN75();
                    spacing = 0.25;
                    latcnt = 90:-spacing:-90;               
                    loncnt = -180:spacing:180;

                case 'LogK'
                    map = DigitalMaps_LogK();
                    spacing = 0.25;
                    latcnt = 90:-spacing:-90;               
                    loncnt = -180:spacing:180;

                case 'R001'
                    map = DigitalMaps_R001();
                    spacing = 0.125;
                    latcnt = -90:spacing:90;               
                    loncnt = -180:spacing:180;
            end


            [LON,LAT] = meshgrid(loncnt, latcnt);


            tic
            for nn = 1:length(Phin)
                for ee = 1:length(Phie)
                    phim_e = Phie(ee);
                    phim_n = Phin(nn);

                    N1(nn,ee) = interp2(LON,LAT,map,phim_e,phim_n);


                end
            end
            toc

            fprintf(1,'Maximum deviation from MATLAB interpolation is: %g\n', max(max(abs(N2-N1))) );

        end
    end

end
