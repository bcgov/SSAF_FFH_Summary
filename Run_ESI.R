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

source('header.R')

#Input variables - passed to subsequent script
AOI<-'SkeenaESI'
Wshd.context<-c('Nechako','SkeenaE','SkeenaW','Nass','Coastal')

#Indicators selected for summarizing
IndicatorsW<-c('ECA_Final_PCNT', 'Rd_Density_net', 'Dam_Lines_Count', 'POD_Count', 'Mine_Points_Count', 'AU_TOT_Disturb_all_PCNT', 'RdsStrmXing_Density_net', 'RdsStrmBuff100_Density_net', 'RdSteepSlopes_Density_net', 'DDR_Score', 'Pnt_Src_Plltn_Final_Count', 'Lakes_Wetlands_PCNT', 'Summer_Sens_PCNT', 'Winter_Sens_PCNT', 'Rip_Tot_All_Dstrb_PCNT', 'Second_Growth_PCNT_net')
IndicatorsW_Label <- c('ECA','Road density', 'Dam', 'Water Licenses', 'Total Land Disturbance', 'Road Stream Crossing Density', 'Road Desnity near Streams', 'Roads on Unstable Slopes', 'Drainage Density Ruggedness', 'Point Source Pollution', 'Extent of Lakes and Wetlands', 'Summer Low Flow Sensitivity', 'Winter Low Flow Sensitivity', 'Riparian Distrubance', 'Amount of 2nd Growth')
IndUnits <- c('%','km/km2', '#', '#', '%', '#/km2', 'km/km2', 'km/km2', 'Score', '#', '%', '%', '%', '%', '%')
Thresh <- list(c(15,20),c(.4,1.2),c(1,3),c(1,3),c(25,75),c(0.16,0.32),c(0.08,0.16),c(0.06,0.12),c(2000,4000),c(1,5),c(2,20),c(5,50),c(5,50),c(5,15),c(5,25))

#Read spreadsheet names from FFH_LUTs.xlsx
LUT_In<- excel_sheets(file.path(ESIDir,'Water/FFH_LUTs.xlsx'))
#Subsequent sheets are veg plots
x<-LUT_In[1:length(LUT_In)]
LUT_List<-lapply(x,function(x) {
  read_excel(file.path(ESIDir,'Water/FFH_LUTs.xlsx'), sheet=x)
})
names(LUT_List) <- x

#or create LUTs
#eg.
#Aquatic_Life_Support	Aquatic_Life_Support_flag
#High	High
#Low	Low
#Medium	Medium
#Aquatic_Life_Support (Yes/No)
#R code for generating LUT
#Aquatic_Life_Support_LUT<-data.frame(Aquatic_Life_Support=
#                          sort(unique(Wetlands.spatial$Aquatic_Life_Support)),
#                          Aquatic_Life_Support_flag=c('High','Low','Medium'))

#Load all the data
source("01_load.R")

#Clean data, select indicators set up fields for analysis
source("02_clean.R")

#Source boxplot function
source("03_analysis_BoxPlots.R")

#Do a loop for each Major Watershed
for (i in 1:nrow(nameWshd)) {
  Wshd.name <- nameWshd[i,]

  #Loop through each of the indicators and generate box plot
  for (j in 1:length(IndicatorsW)) {
    Ind<-IndicatorsW[j]
    IndL<-IndicatorsW_Label[j]
    Thrsh <- Thresh[[j]]
    IndU <- IndUnits[j]
    Boxplots(AOI, Wshd.name, Wshd.name, figsOutDir, dataOutDir, Ind, IndL,Thrsh, IndU)
  }

}

