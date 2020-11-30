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

source("header_jwfraser.R")

#Add watersheds to wetlands
#use centre point of wetland and assign each to a major watershed
#See if it is already done - computationally intensive
FFH_file <- file.path("tmp/Wetlands.spatial")
if (!file.exists(Wet_file)) {
Wshd_pts <-st_intersection(waterpt, WetWshd) %>%
  st_drop_geometry() %>%
  dplyr::select('Wetland_Co', 'MWshd')

#Join point coverage back to main wetland file
Wetlands.spatial<-Wetlands %>%
  #st_drop_geometry %>%
  left_join(Wshd_pts, by='Wetland_Co')

#Set NULL to 0
#Wetlands.spatial[is.na(Wetlands.spatial)] <- 0
saveRDS(ffh.spatial, file = ffh_file)
}

ffh.spatial<-readRDS(file = ffh_file)

#Clean up Wetlands attributes
ffh.spatial<-ffh.spatial %>%
  mutate(ECA_Final_PCNT=ifelse(ECA_Final_PCNT>100,0,ECA_Final_PCNT)) %>%
  #mutate(FloodControl_function=ifelse(FloodControl_function ==  '0', 'Very Low to Zero',FloodControl_function)) %>%
  #mutate(WaterPurification_function=ifelse(WaterPurification_function ==  '0', 'Low',WaterPurification_function)) %>%
  mutate(Sufficient_OG=ifelse(Mature_OG_PCT>min_pct_target_Mature_Old, 'Yes', 'No')) %>%
  #mutate(Nat_SemiNat_PCTR=100-Nat_SemiNat_PCT)

#Not necessary in FFH
#ffh.spatial<-ffh.spatial %>%
  #st_drop_geometry() %>%
  #left_join(BrowsePercentinWetlands_2,by=c('OBJECTID'))

#"BCLCS_LEVEL_4" IN ( 'TB' , 'ST' , 'SL' ) AND "PROJ_AGE_CLASS_CD_1" IN ('1', '2')

#Change Yes, No and categorical to standardizaed coding for stacked bars
#Hydrologic Support:
#FloodControl_function (High/Medium/Low/Very Low to Zero)
#FloodControl_function_flag_LUT<-data.frame(FloodControl_function=sort(unique(Wetlands.spatial$FloodControl_function)),
#                                          FloodControl_function_flag=c('High','Low','Medium','Zero'))
#SocietalAsset_5km_ds (Yes/No)
#SocietalAsset_5km_ds_flag_LUT<-data.frame(SocietalAsset_5km_ds=sort(unique(Wetlands.spatial$SocietalAsset_5km_ds)),
#  SocietalAsset_5km_ds_flag=c('Zero','High'))
#Water Purification:
#WaterPurification_function (High/Medium/Low)
#WaterPurification_function_LUT<-data.frame(WaterPurification_function=
#                                           sort(unique(Wetlands.spatial$WaterPurification_function)),
#                                           WaterPurification_function_flag=c('High','Low','Medium'))
#SocietalAsset_WQ_Class (High/Moderate/Low)
#SocietalAsset_WQ_Class_LUT<-data.frame(SocietalAsset_WQ_Class=
#                                             sort(unique(Wetlands.spatial$SocietalAsset_WQ_Class)),
#                                       SocietalAsset_WQ_Class_flag=c('High','Low','Medium'))
#Aquatic:
#Aquatic_Life_Support (Yes/No)
#Aquatic_Life_Support_LUT<-data.frame(Aquatic_Life_Support=
#                                         sort(unique(Wetlands.spatial$Aquatic_Life_Support)),
#                                     Aquatic_Life_Support_flag=c('High','Low','Medium'))
#Wildlife Habitat:
#Moose_Forage (Yes/No)
#Moose_Forage_LUT<-data.frame(Moose_Forage=
#Moose_Forage_LUT<-data.frame(Browse.Yes.or.No=
#                               sort(unique(Wetlands.spatial$Browse.Yes.or.No)),
#                             Moose_Forage_flag=c('Zero','High'))
#Mature_OG_PCT (%)
#sufOG_LUT<-data.frame(Sufficient_OG=
#                                sort(unique(Wetlands.spatial$Sufficient_OG)),
#                      Sufficient_OG_flag=c('Zero','High'))
#Protected_Ovrlp (Yes/No)
#Protected_Ovrlp_LUT<-data.frame(Protected_Ovrlp=
#                               sort(unique(Wetlands.spatial$Protected_Ovrlp)),
#                            Protected_Ovrlp_flag=c('Zero','High'))
#Open_Wtr_Class (High/Moderate/Low)
#Open_Wtr_Class_LUT<-data.frame(Open_Wtr_Class=
#                                sort(unique(Wetlands.spatial$Open_Wtr_Class)),
#                               Open_Wtr_Class_flag=c('High','Low','Medium'))
#Cultural;
#RAAD_500m (Yes/No)
#RAAD_500m_LUT<-data.frame(RAAD_500m=
#                              sort(unique(Wetlands.spatial$RAAD_500m)),
#                          RAAD_500m_flag=c('Zero','High'))
#Cultural_Access_Class (High/Medium/Low)
#Cultural_Access_Class_LUT<-data.frame(Cultural_Access_Class=
#                            sort(unique(Wetlands.spatial$Cultural_Access_Class)),
#                            Cultural_Access_Class_flag=c('High','Low','Medium'))

#Categroy is either High/Medium/Low, or High/Low for Yes/No, or High/Medium/Low/Zero
ffh.spatial<-ffh.spatial %>%
  #Wetland Features - legacy
  #left_join(FloodControl_function_flag_LUT) %>%
  #left_join(SocietalAsset_5km_ds_flag_LUT) %>%
  #left_join(WaterPurification_function_LUT) %>%
  #left_join(SocietalAsset_WQ_Class_LUT)%>%
  #left_join(Aquatic_Life_Support_LUT)%>%
  #left_join(Moose_Forage_LUT)%>%
  #left_join(Protected_Ovrlp_LUT)%>%
  #left_join(sufOG_LUT)%>%
  #left_join(Open_Wtr_Class_LUT)%>%
  #left_join(RAAD_500m_LUT)%>%
  #left_join(Cultural_Access_Class_LUT)
  
  #Add ffh features here
  left_join()
#data check
#table(Wetlands.spatial$FloodControl_function)
#tt<-Wetlands.spatial %>%
#  st_drop_geometry() %>%
#  dplyr::select(Wetland_Co, Mature_OG_PCT, min_pct_target_Mature_Old)

#Subset all wetlands in Watershed context area and strip sf geometry and write to file for box plots
Wetlands_Context.spatial<-Wetlands.spatial

Wetlands_Context<-Wetlands_Context.spatial %>%
  st_drop_geometry()
write.table(Wetlands_Context, file = file.path(dataOutDir,"Wetlands_Context.csv"),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")
#Data Check
#df<-Wetlands_Context %>% dplyr::select(MWshd,Wetland_Co)

#Loop through Watersheds, AOI and indicators and output analysis ready data sets
#Write a function to filter and output table for box plots
WshdFn <- function(df, Wshdi){
  df %>%
    dplyr::filter(df$MWshd==Wshdi) %>%
    dplyr::select(MWshd, Wetland_Co, all_of(Indicators)) %>%
    write_csv(paste(dataOutDir,"/Wetlands_",Wshdi,".csv", sep=''))
}
dfrun<-lapply(Wshd.context[], function(i) WshdFn(Wetlands_Context, i))

#tt<-read.csv(paste(dataOutDir,"/Wetlands_Coastal",".csv", sep=''), header=T)

#Wshds used for analysis
Wshds.used <- subset(WetWshd, MWshd %in% Wshd.context)
nameWshd<-data.frame(Wshd_NAME=Wshds.used$MWshd)

#Generate table for stacked bars
#Needs to be Wetland_Co, Category (H, M, L, y, n,...), threat Type (Indicator)
#start with Wetlands.spatial
#Generate by indicator -



