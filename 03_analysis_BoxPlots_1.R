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

# Copyright 2017 Province of British Columbia
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

#Summarizes Provincial LU indicators by AOI and by GBPU
#By Don Morgan, MoE

#############
# Based on aquatics summary R script generate box plots for gbears
#############

#source files for each panel
source("03_analysis_BoxPlots_2.R")

#Do a loop for each Major Watershed in the unit and one for the entire AOI
for (i in 1:nrow(nameWshd)) {
  Wshd.name <- nameWshd[i,]
  #Loop through each of the indicators
  for (j in 1:length(IndicatorsW)) {
    Ind<-IndicatorsW[j]
    IndL<-IndicatorsW_Label[j]
    Thrsh <- Thresh[[j]]
    IndU <- IndUnits[j]
  Boxplots(AOI, Wshd.name, Wshd.name, figsOutDir, dataOutDir, Ind, IndL,Thrsh, IndU)
  }
}
