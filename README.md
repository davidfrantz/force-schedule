# force-schedule

Schedule FORCE processing

## General Usage

How to use:

1) Edit paths in `config/config.txt`
2) install a CRON job, see `cron/cron.sh for suggestions`


## Specific instructions to download Landsat Level 1 Collection 2

### _Requirements_

#### landsatlinks

Follow instructions on [ernstste/landsatlinks](https://github.com/ernstste/landsatlinks#requirements)

>**USGS Account**  
>* Create an [USGS Account](https://ers.cr.usgs.gov/register)  
>* [Request access](https://ers.cr.usgs.gov/profile/access) to the machine-to-machine API
>* Create a secret text-file (_.usgs.txt_) containing the USGS EarthExplorer login in your home directory  
_First line: user, second line: password_

#### Footprint

Create a text file containing a **list of allowed pathrows** (AOI). The list must contain one path/row per line.  
_Format: PPPRRR_  

>To know which pathrows you need, use 
[Landsat WRS-2 Descending Path Row Shapefile](https://www.usgs.gov/media/files/landsat-wrs-2-descending-path-row-shapefile)  
or [EO Grids Web Feature Service (WFS)](https://ows.geo.hu-berlin.de/services/eo-grids/)

#### Configurations

Prepare paths in **_/force-schedule/config/config.txt_**  
`$ vi ./force-schedule/config/config.txt` 

### _Usage_

Run **_/force-schedule/bash/ingest_landsat.sh_** in Terminal.  

`$ ./force-schedule/bash/ingest_landsat.sh`
