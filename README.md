# MATLAB/Octave Implementation of Recommendation ITU-R P.530

This code repository contains a MATLAB/Octave software implementation of parts of Recommendation [ITU-R P.530-18](https://www.itu.int/rec/R-REC-P.530/en) with propagation data and prediction methods required for the design of terrestrial line-of-sight systems.    


The following table describes the structure of the folder `./matlab/` containing the MATLAB/Octave implementation of Recommendation ITU-R P.530.

This is a very first implementation. It has not been tested and may contain errors and bugs.

| File/Folder               | Description                                                         |
|----------------------------|---------------------------------------------------------------------|
|`P530.m`                | MATLAB class with methods implementing Recommendation ITU-R P.530-18          |
|`initiate_digital_maps.m`| MATLAB script that processes the ITU-R maps and generates the necessary functions. It needs to be run prior to using this software implementation. For details, see [Integrating ITU Digital Products](#integrating-itu-digital-products). |
|`test_p530.m`          | MATLAB script (under development) that will be used to validate the implementation of this Recommendation  |


## Integrating ITU Digital Products

This software uses ITU digital products that are integral part of Recommendations. These products must not be reproduced or distributed without explicit written permission from the ITU.

### Setup Instructions

1. **Download and extract the required maps** to `./private/maps`:

   - From [ITU-R P.530-18](https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.530-18-202109-I!!ZIP-E.zip):
     - `LogK.csv`
     - `dN75.csv`

   - From [ITU-R P.2001-5](https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.2001-5-202308-I!!ZIP-E.zip):
     - `Esarain_beta_v5.txt`
     - `Esarain_Mt_v5.txt`
     - `Esarain_Pr6_v5.txt`
     - `h0.txt`

   - From [ITU-R P.837-7](https://www.itu.int/dms_pubrec/itu-r/rec/p/R-REC-P.837-7-201706-I!!ZIP-E.zip):
     - `R001.TXT`

2. **Run the script** `initiate_digital_maps.m` to generate the necessary functions for retrieving and interpolating data from from the maps.

### Notes

- Ensure all files are placed in `./private/maps` before running the script.
- The script processes the maps, which are critical for the software’s functionality.
- The resulting `*.m` files are placed in the folder `./private`.



## Methods implemented in class P530
| Function          | Reference  | Description  |
|-------------------|------------|--------------|
|`atmospheric_attenuation`| §2.1|Attenuation due to atmospheric gases using ITU-R P.676|
|`first_fresnel_radius`|  §2.2.1 | Radius of the 1st Fresnel ellipsoid|
|`diffraction_loss`|  §2.2.1 | Diffraction loss over average terrain|
|`multipath_fading_single_freq`|  §2.3.1 | Percentage of time that fade depth is exceeded in the average worst month (single-frequency (or narrow-band) fading distribution at large fade depths) |
|`multipath_fading`|  §2.3.2 | Percentage of time that (any) fade depth is exceeded in the average worst month|
|`duct_enhancement`|  §2.3.3 |  Percentage of time that enhancement is not exceeded in the average worst month  |
|`multipath_fading_single_freq_annual`|  §2.3.4 | Percentage of time that fade depth is exceeded in the average year (single-frequency (or narrow-band) fading distribution at large fade depths)  |
|`multipath_fading_annual`|  §2.3.4 | Percentage of time that (any) fade depth is exceeded in the average year|
|`duct_enhancement_annual`|  §2.3.4 |  Percentage of time that enhancement is not exceeded in the average year |
|`pw2psw`|  §2.3.5 |  Converts the percentage of time in the average worst month to a percentage of time pduring a shorter worst period of time  |
|`specific_rain_attenuation_p838`|  ITU-R P.838-3 |  Specific rain attenuation |
|`rain_attenuation_statistics`|  §2.4.1 |  Long-term statistics of rain attenuation |
|`preliminary_test`|  §2.4.2.1 |  Performs preliminary tests and decides on which method to use in combined method for rain and wet snow |
|`preliminary_calculation`|  §2.4.2.2 |  Computes preliminary values for rain and wet snow method |
|`attenuation_multiplier`|  §2.4.2.4 |  Function 1: Attenuation multiplier  |
|`path_averaged_multiplier`|  §2.4.2.4 |  Function 2: Path-averaged multiplier  |
|`A2T`|  §2.4.2.4 |  Function 3: Percentage time as function of rain-only attenuation |
|`scale_rain_statistics_f`|  §2.4.3 |  Scales long-term statistics of rain attenuation with frequency |
|`XPD_outage_clear_air`|  §4.1 |  Cross-polar discrimination (XPD) outage due to clear-air effects|
|`XPD_outage_precipitation`|  §4.2|  Cross-polar discrimination (XPD) outage due to precipitation |



## Function Call


## Required input arguments

| Variable          | Type   | Units | Limits       | Description  |
|-------------------|--------|-------|--------------|--------------|

## Optional input arguments
| Variable          | Type   | Units | Limits       | Description  |
|-------------------|--------|-------|--------------|--------------|


## Outputs ##

| Variable   | Type   | Units | Description |
|------------|--------|-------|-------------|



## Software Versions
The code was tested and runs on:
* MATLAB versions 2017a and 2020a
* Octave version 6.1.0

## References

* [Recommendation ITU-R P.530](https://www.itu.int/rec/R-REC-P.452/en)
* 

