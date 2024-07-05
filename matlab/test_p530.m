d1 = 10;
d2 = 10;
d = 10;
f = 29;
h =100;
he = 100;
hr = 100;
ht = 50;
A = 10;
Ap = 10;
el = 45;
xpdg = 20;
cir = 20;
lat = 51;
lon = -53;
p = 0.05;
E = 10;
pol = 0;
U0 = 15;
xpif = 20;


p530 = P530;


F = p530.first_fresnel_radius(f, d1, d2);

Ad = p530.diffraction_loss(h, f, d1, d2);

pw231 = p530.multipath_fading_single_freq(lon, lat, d, he, hr, ht, f, A);

pw232 = p530.multipath_fading(lon, lat, d, he, hr, ht, f, A);

pw233 = p530.duct_enhancement(lon, lat, d, he, hr, ht, f, E);

p231 = p530.multipath_fading_single_freq_annual(lon, lat, d, he, hr, ht, f, A);

p232 = p530.multipath_fading_annual(lon, lat, d, he ,hr ,ht ,f,  A);

p233 = p530.duct_enhancement_annual(lon, lat, d, he ,hr, ht, f, E);

Ap = p530.rain_attenuation_statistics(lon, lat, d, f, p, pol, el);

Pxp = p530.XPD_outage_clear_air(lon, lat, d, he, hr, ht, f, cir, xpdg);

Pxpr = p530.XPD_outage_precipitation(lon, lat, d, f, pol, el, cir, U0, xpif);

rain_snow_flag = p530.preliminary_test(ht, hr, lon, lat);