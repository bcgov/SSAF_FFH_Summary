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

#Identify AOI, AOI shape file name and GBPUs to compare and % overlap
#Input variables - passed to load script
AOI<-'SkeenaESI'
AOI.Name<-"Skeena ESI"
#AOI.ShpName <- "ESI_Skeena_Study_Area_Nov2017"
#AOI.id <- 'OBJECTID'

Wshd.context<-c('Nechako','SkeenaE','SkeenaW','Nass','Coastal')
#GBPU.context<-c('Babine','Bulkley-Lakes','Cranberry','Francois','Upper Skeena-Nass','Tweedsmuir')
#Overlap<-0.20
#AOI.dir <- '../../Projects/ESI/data/Skeena_ESI_Boundary'

source("01_load.R")
#Bear_Load(AOI, AOI.Name, AOI.ShpName, GBPU.context, Overlap)

#Indiators selected for summarizing
IndicatorsW<-c('ECA_Final_PCNT','RdsStrmXing_Density_net', 'Rd_Density_net')

#Clean data, select indicators set up fields for analysis
source("02_clean.R")

source("03_analysis_barchart.R")

source("03_analysis_BoxPlots.R")

#Boxplots(Prov, AOI.name, GBPU.name, GBPU.name, dir.figs, dir.data)
