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

# ------------------------------------------------------------------------------
# BOXPLOTS For one Wshd at a time
#
# ------------------------------------------------------------------------------
Boxplots <- function(Prov, AOI.name, Wet.name, Wet.abbrev, dir.figs, dir.data) {
  source("03_analysis_BoxWetAll.R")
  #source("03_analysis_BoxWet.R")
  outdir<- dir.figs

  #unit that is being evaluated - Watershed
  dataWet<-read.csv(file.path(dir.data,paste('Wetlands_',Wet.name, ".csv",sep="")), header=T)

  #Compare to all wetlands in SSAF area
  dataBC<- (read.csv(file.path(dataOutDir,"Wetlands_Context.csv"),header=T))

  if(Prov==1){
    dataBC<- (read.csv(file.path(dir.data,"Wetlands_Context.csv"),header=T))
    compUnit<-"BC"
  } else {
    dataBC<- (read.csv(file.path(dir.data,"Wetlands_Context.csv"),header=T))
    #compUnit<-paste(AOI.name,"'s intersecting GBPU's", sep="")
    compUnit<-paste("All ", sep="")
  }

  #Must have 2 thresholds in thresh c(0.6,1.25), if binary then repeat c(30,30)
  # 4.4) ROAD density within 100m
  thresh<-c(.08,.16) #passing in the thresholds for the indicator
  Box.2(dataframe1=dataWet, dataframe2=dataBC,
        use.field="RoadDensity_100m",
        use.xlab=expression("Road density w100 ("*km/km^2*")"),
        use.units=quote(km/km^2),
        use.t=thresh,
        use.filename=file.path(outdir,paste(Wet.abbrev,"_","RoadDensity_100m",".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit=compUnit)

  # 4.5) ROAD density within 2000m
  thresh<-c(.4,1.2) #passing in the thresholds for the indicator
  Box.2(dataframe1=dataWet, dataframe2=dataBC,
        use.field="RoadDensity_2000m",
        use.xlab=expression("Road density w2000 ("*km/km^2*")"),
        use.units=quote(km/km^2),
        use.t=thresh,
        use.filename=file.path(outdir,paste(Wet.abbrev,"_","RoadDensity_2000m",".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit=compUnit)

  # 4.6) Natural Semi Natural
  thresh<-c(60,90) #passing in the thresholds for the indicator
  Box.2(dataframe1=dataWet, dataframe2=dataBC,
        use.field="Nat_SemiNat_PCTR",
        use.xlab=expression("Natural Semi-Natural (%)"),
        use.units=quote('%'),
        use.t=thresh,
        use.filename=file.path(outdir,paste(Wet.abbrev,"_","Nat_SemiNat_PCT",".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit=compUnit)






}
