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
ffh_file <- file.path("tmp/ffh.spatial")
if (!file.exists(ffh_file)) {
Wshd_pts <-st_intersection(waterpt, WetWshd) %>%
  st_drop_geometry() %>%
  dplyr::select('Wetland_Co', 'MWshd')
#Unecessary
#Join point coverage back to main wetland file
#ffh.spatial<-ffh %>%
  #st_drop_geometry %>%
  #left_join(Wshd_pts, by='Wetland_Co')

#Set NULL to 0
#Wetlands.spatial[is.na(Wetlands.spatial)] <- 0
saveRDS(ffh.spatial, file = ffh_file)
}

ffh.spatial<-readRDS(file = ffh_file)

#Clean up Wetlands attributes
ffh.spatial<-ffh.spatial %>%
  mutate(ECA_Final_PCNT=ifelse(ECA_Final_PCNT>100,0,ECA_Final_PCNT))

#Generage Watershed units for first 3 watershed indicators
Watersheds_Context<-ffh.spatial %>%
  st_drop_geometry() %>%
  group_by(WATERSHED_FEATURE_ID) %>%
  dplyr::summarise(MWshd=first(MWshd), Rd_Density_net=first(Rd_Density_net),
                   ECA_Final_PCNT=first(ECA_Final_PCNT),
                   Pnt_Src_Plltn_Final_Count=first(Pnt_Src_Plltn_Final_Count))

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
Wshds.used <- subset(WetWshd, MWshd %in% Wshd.context)
nameWshd<-data.frame(Wshd_NAME=Wshds.used$MWshd)



