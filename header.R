library(sf)
library(rgdal)
library(dplyr)
library(plyr)
library(readr)
library(raster)
library(bcmaps)
library(bcdata)
library(fasterize)
library(tidyr)
library(rio)
library(WriteXLS)
library(ggplot2)
library(readxl)
library(stringr)
library(mapview)
library(gdata)
library(reshape2)
library(exactextractr)
library(plotKML)
library(purrr)
library(lubridate)
library(tibble)
library(janitor)
library(magrittr)
library(igraph)
library(rgeos)
library(rlist)


#getwd() tells you what directory you are in
#system('dir') should give you the directory listing

OutDir <- 'out'
dataOutDir <- file.path(OutDir,'data')
StrataOutDir <- file.path(dataOutDir,'Strata')
figsOutDir <- file.path(OutDir,'figures')
SpatialDir <- file.path('data','spatial')
DataDir <- file.path('data')
spatialOutDir <- file.path(OutDir,'spatial')

#Set user specific paths
SyncDirR<-file.path('../../../../Sync')
#SyncDirR<-file.path('/Users/jwfraser/Sync')

SyncDir <- file.path(SyncDirR)

FFHSpatialDir <- file.path(SyncDir,'Fish and Fish Habitat/Tier 1/Assessment/Final Package - 2020/Data')
ESIDir <- file.path(SyncDir,'PT and STC/Science and Technical Committee/Base Information/Data')

#Not sure we need these?
#ffhSampspatialdir <- file.path('../FFH_SkeenaESI_')

#GBdataOutDir <- file.path('../GB_Data/out/data')
#GBPDir <-file.path('../GB_Data/data/Population/Bear_Density_2018')
#ESIDir <- file.path('//spatialfiles.bcgov/work/srm/smt/Workarea/ArcProj/P17_Skeena_ESI')
#RoadDir <- file.path('/Users/jwfraser/Dropbox (BVRC)/_dev/Biodiversity/bc-raster-roads/data')
#ESIData <- file.path('//spatialfiles.bcgov/work/srm/smt/Workarea/ArcProj/P17_Skeena_ESI/Data')
#GISDir <- file.path('/Users/jwfraser/Dropbox (BVRC)/Library/GISFiles/BC/Shapefiles')
#GISSkDir <- file.path('/Users/jwfraser/Dropbox (BVRC)/Library/GISFiles/Skeena/Shapefiles')
#FREPDir<-file.path('/Users/jwfraser/Sync/Wetland/Tier 2/Data/FREP')
#Tier2Dir<-file.path('/Users/jwfraser/Sync/Wetland/Tier 2/Data')
#CGLDir<-file.path('/Users/jwfraser//Dropbox (BVRC)/Projects/UBM_LUP/data/CGL_Wetlands')


dir.create(file.path(OutDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(file.path(StrataOutDir), showWarnings = FALSE)
dir.create(file.path(spatialOutDir), showWarnings = FALSE)
dir.create(DataDir, showWarnings = FALSE)
dir.create(figsOutDir, showWarnings = FALSE)
dir.create("tmp", showWarnings = FALSE)

#Location of Monitoring spreadsheet
#WetMonDir<-file.path('../../../Projects/ESI/Wetlands/Monitoring/2019FieldData')
#WetMonDir<-file.path('data')
#WetspatialDir <- file.path('data')
#system(paste('ls ',WetMonDir,sep=''))

