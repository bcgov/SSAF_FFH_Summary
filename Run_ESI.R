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

source("01_load.R")
#Bear_Load(AOI, AOI.Name, AOI.ShpName, GBPU.context, Overlap)

#Indiators selected for summarizing
IndicatorsW<-c('ECA_Final_PCNT', 'Rd_Density_net')
IndicatorsW_Label <- c('ECA','Road density')
IndUnits <- c('%','km/km2')
Thresh <- list(c(15,20),c(.4,1.2))

#Clean data, select indicators set up fields for analysis
source("02_clean.R")

#Source boxplot function
source("03_analysis_boxplotsWshd.R")

#Do a loop for each Major Watershed in the unit and one for the entire AOI
for (i in 1:nrow(nameWshd)) {
  Wshd.name <- nameWshd[i,]
  Boxplots(Prov, AOI, Wshd.name, Wshd.name, figsOutDir, dataOutDir)
}

