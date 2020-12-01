# Copyright 2020 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

source("header.R")

ESI_file <- file.path("tmp/ESI")
if (!file.exists(ESI_file)) {
  #Load ESI boundary
  ESIin <- read_sf(file.path(ESIDir,'Skeena_ESI_Boundary'), layer = "ESI_Skeena_Study_Area_Nov2017") %>%
    st_transform(3005)
  ESI <- st_cast(ESIin, "MULTIPOLYGON")
  saveRDS(ESI, file = ESI_file)
}
ESI<-readRDS(ESI_file)

#Build out summary watershed units
#Major Watersheds
Wshd <- get_layer("wsc_drainages", class = "sf") %>%
  select(SUB_DRAINAGE_AREA_NAME, SUB_SUB_DRAINAGE_AREA_NAME) %>%
  `st_crs<-`(3005) %>%
   st_intersection(ESI)
saveRDS(Wshd, file = 'tmp/Wshd')

#drop spatial to build LUT for watershed reporting units
Wshd.dat<- Wshd %>%
  st_drop_geometry() %>%
  dplyr::select(SUB_DRAINAGE_AREA_NAME, SUB_SUB_DRAINAGE_AREA_NAME)
SkeenaE<-Wshd.dat %>%
  dplyr::filter(SUB_SUB_DRAINAGE_AREA_NAME %in% c("Bulkley","Morice",'Babine')) %>%
  mutate(MWshd='SkeenaE') %>%
  dplyr::select(SUB_SUB_DRAINAGE_AREA_NAME, MWshd)
SkeenaW<-Wshd.dat %>%
  dplyr::filter(SUB_SUB_DRAINAGE_AREA_NAME %in% c('Lower Skeena','Central Skeena','Upper Skeena','Headwaters Skeena','Finlay')) %>%
  mutate(MWshd='SkeenaW') %>%
  dplyr::select(SUB_SUB_DRAINAGE_AREA_NAME, MWshd)
Nechako<-Wshd.dat %>%
  dplyr::filter(SUB_DRAINAGE_AREA_NAME %in% c('Nechako','Upper Fraser')) %>%
  mutate(MWshd='Nechako') %>%
  dplyr::select(SUB_SUB_DRAINAGE_AREA_NAME, MWshd)
Coastal<-Wshd.dat %>%
  dplyr::filter(SUB_DRAINAGE_AREA_NAME %in% c('Central Coastal Waters of B.C.','Stikine - Coast')) %>%
  mutate(MWshd='Coastal') %>%
  dplyr::select(SUB_SUB_DRAINAGE_AREA_NAME, MWshd)
Nass<-Wshd.dat %>%
  dplyr::filter(SUB_DRAINAGE_AREA_NAME == 'Nass - Coast') %>%
  mutate(MWshd='Nass') %>%
  dplyr::select(SUB_SUB_DRAINAGE_AREA_NAME, MWshd)

Wshd_LUT<-rbind(Coastal, Nass, SkeenaW, SkeenaE,Nechako)

#Join Wshd_LUT back to spatial group by MWshd to make summary watersheds
WetWshd<-Wshd %>%
  left_join(Wshd_LUT, by='SUB_SUB_DRAINAGE_AREA_NAME') %>%
  group_by(MWshd) %>%
  dplyr::summarise()

write_sf(WetWshd, file.path(spatialOutDir,"WetWshd.gpkg"))

#Check data
mapview(WetWshd) + mapview(Wshd) + mapview(WetWshd) + mapview(ESI)

# AOI for comparing watersheds to ESI full area
AOI.spatial <- ESI

# Read in Watershed indicator data
Wshd_gdb <- list.files(file.path(FFHSpatialDir), pattern = ".gdb", full.names = TRUE)[1]#SSAF_ESI_T1_FFH.gdb
Wshd_list <- st_layers(Wshd_gdb)
FFH_Watershed<-read_sf(Wshd_gdb, layer = "SSAF_CEF_Aquatics_Indicators_2018_200428_200914") %>%
  st_transform(3005)

#Indicator data is in wetlands file - read in from 'Wetland_Skeena_ESI_Monitoring' repo out/spatial
#!Watershed<-read_sf(file.path(ffhspatialdir,"Wetlands3.gpkg"))

#Generate an ESI Wetlands point coverage if it hasnt been done
Pt_file <- file.path("tmp/waterpt")
if (!file.exists(Pt_file)) {
FFH_XY <- st_centroid(FFH_Watershed)
ffhpt <- st_coordinates(FFH_XY)
ffhpt <- FFH_XY %>%
  cbind(ffhpt) %>%
  st_drop_geometry()

waterpt <- st_as_sf(ffhpt, coords= c("X","Y"), crs = 3005) %>%
  st_intersection(AOI.spatial)
waterpt <- waterpt %>%
  mutate(wet_id=as.numeric(rownames(waterpt)))
#st_crs(waterpt)<-3005
saveRDS(waterpt, file = Pt_file)
write_sf(waterpt, file.path(spatialOutDir,"FFH_waterpt.gpkg"))
}

waterpt<-readRDS(Pt_file)

#Not needed for FFH
#Read in Neil's moose stuff
#BrowsePercentinWetlands_2 <- data.frame(read_xlsx(path=file.path(DataDir,paste('BrowsePercentinWetlands_2.xlsx',sep='')),sheet='BrowsePercentinWetlands_2'))

