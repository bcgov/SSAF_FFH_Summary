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
IndicatorsW<-c('ECA_Final_PCNT', 'Rd_Density_net')
IndicatorsW_Label <- c('ECA','Road density')
IndUnits <- c('%','km/km2')
Thresh <- list(c(15,20),c(.4,1.2))

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

