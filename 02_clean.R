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


# #Add watersheds to FWA AUs
# #use centre point of Watershed and assign each to a major watershed
# #See if it is already done - computationally intensive
# ffh_file <- file.path("tmp/ffh.spatial")
# if (!file.exists(ffh_file)) {
# Wshd_pts <-st_intersection(waterpt, FN) %>%
#   st_drop_geometry() %>%
#   dplyr::select('WATERSHED_FEATURE_ID', 'MajorWshd')
#
#
# #join back to FFH_Watershed
# ffh.spatial<-FFH_Watershed %>%
#   left_join(Wshd_pts, by='WATERSHED_FEATURE_ID')
#
# saveRDS(ffh.spatial, file = ffh_file)
# }

#Add FN Territory to FWA AUs
#use centre point of Watershed and assign each to a FN Territory
#See if it is already done - computationally intensive
ffh_file <- file.path("tmp/ffh.spatial")
if (!file.exists(ffh_file)) {
  Wshd_pts <-st_intersection(waterpt, FN) %>%
    st_drop_geometry() %>%
    dplyr::select('WATERSHED_FEATURE_ID', 'BOUNDARY_N')


#join back to FFH_Watershed
ffh.spatial<-FFH_Watershed %>%
  left_join(Wshd_pts, by='WATERSHED_FEATURE_ID')

saveRDS(ffh.spatial, file = ffh_file)
}

ffh.spatial<-readRDS(file = ffh_file)

#Generate Watershed units for watershed indicators
Watersheds_Context<-ffh.spatial %>%
  st_drop_geometry()

print (IndicatorsW)


#Check continuous indicator distribution and clean up where needed
Indicators_df<-Watersheds_Context[IndicatorsW]
lapply(Indicators_df, range, na.rm = TRUE)

Watersheds_Context<-Watersheds_Context %>%
   mutate(ECA_Final_PCNT=ifelse(ECA_Final_PCNT>100,0,ECA_Final_PCNT))
   #mutate(Rip_Tot_All_Dstrb_PCNT=ifelse(is.na(Rip_Tot_All_Dstrb_PCNT),0,Rip_Tot_All_Dstrb_PCNT))
write.table(Watersheds_Context,file = file.path(dataOutDir,"Watersheds_Context.csv"),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")

#Loop through Watersheds, AOI and indicators and output analysis ready data sets
#Write a function to filter and output table for box plots
WshdFn <- function(df, Wshd){
  df %>%
    dplyr::filter(df$MWshd==Wshd) %>%
    dplyr::select(MWshd, WATERSHED_FEATURE_ID, all_of(IndicatorsW)) %>%
    write_csv(paste(dataOutDir,"/Watersheds_",Wshd,".csv", sep=''))
}
dfrun<-lapply(Wshd.context[], function(i) WshdFn(Watersheds_Context, i))

#Wshds used for analysis
Wshds.used <- subset(Watersheds_Context, MWshd %in% Wshd.context)
nameWshd<-data.frame(Wshd_NAME=Wshds.used$MWshd)



#Try to do the same for Non-Risk Indicators


#Add watersheds to wetlands
#use centre point of wetland and assign each to a major watershed
#See if it is already done - computationally intensive
ffh_file <- file.path("tmp/ffh.spatial")
if (!file.exists(ffh_file)) {
  Wshd_pts <-st_intersection(waterpt, MajorWshd) %>%
    st_drop_geometry() %>%
    dplyr::select('WATERSHED_FEATURE_ID', 'MWshd')

  #join back to FFH_Watershed
  ffh.spatial<-FFH_Watershed %>%
    left_join(Wshd_pts, by='WATERSHED_FEATURE_ID')

  saveRDS(ffh.spatial, file = ffh_file)
}

ffh.spatial<-readRDS(file = ffh_file)

#Generate Watershed units for watershed indicators
WatershedsF_Context<-ffh.spatial %>%
  st_drop_geometry()

print (IndicatorsF)

#Check continuous indicator distribution and clean up where needed
IndicatorsF_df<-WatershedsF_Context[IndicatorsF]
lapply(IndicatorsF_df, range, na.rm = TRUE)

#mutate(Rip_Tot_All_Dstrb_PCNT=ifelse(is.na(Rip_Tot_All_Dstrb_PCNT),0,Rip_Tot_All_Dstrb_PCNT))
write.table(WatershedsF_Context,file = file.path(dataOutDir,"Watersheds_ContextF.csv"),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")

#Loop through Watersheds, AOI and indicators and output analysis ready data sets
#Write a function to filter and output table for box plots
WshdFnF <- function(df_F, Wshd){
  df_F %>%
    dplyr::filter(df_F$MWshd==Wshd) %>%
    dplyr::select(MWshd, WATERSHED_FEATURE_ID, all_of(IndicatorsF)) %>%
    write_csv(paste(dataOutDir,"/WatershedsF_",Wshd,".csv", sep=''))
}
dfrun<-lapply(Wshd.context[], function(i) WshdFnF(WatershedsF_Context, i))

#Wshds used for analysis
Wshds.used <- subset(WatershedsF_Context, MWshd %in% Wshd.context)
nameWshd<-data.frame(Wshd_NAME=Wshds.used$MWshd)
