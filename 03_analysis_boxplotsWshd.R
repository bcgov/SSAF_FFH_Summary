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
  source("03_analysis_BoxWshd.R")
  outdir<- dir.figs

  #unit that is being evaluated - Watershed
  dataWet<-read.csv(file.path(dir.data,paste('Watersheds_',Wet.name, ".csv",sep="")), header=T)

  #Compare to all wetlands in SSAF area
  dataBC<- (read.csv(file.path(dataOutDir,"Watersheds_Context.csv"),header=T))

  if(Prov==1){
    dataBC<- (read.csv(file.path(dir.data,"Watersheds_Context.csv"),header=T))
    compUnit<-"BC"
  } else {
    dataBC<- (read.csv(file.path(dir.data,"Watersheds_Context.csv"),header=T))
    compUnit<-paste("All ", sep="")
  }

  #Must have 2 thresholds in thresh c(0.6,1.25), if binary then repeat c(30,30)
  # 1) ROAD density
  thresh<-c(.4,1.2) #passing in the thresholds for the indicator
  Box.2(dataframe1=dataWet, dataframe2=dataBC,
        use.field="Rd_Density_net",
        use.xlab=expression("Road density ("*km/km^2*")"),
        use.units=quote(km/km^2),
        use.t=thresh,
        use.filename=file.path(outdir,paste(Wet.abbrev,"_","RoadDensity",".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit=compUnit)

  # 2) ECA
  thresh<-c(15,20) #passing in the thresholds for the indicator
  Box.2(dataframe1=dataWet, dataframe2=dataBC,
        use.field="ECA_Final_PCNT",
        use.xlab=expression("ECA (%)"),
        use.units=quote('%'),
        use.t=thresh,
        use.filename=file.path(outdir,paste(Wet.abbrev,"_","ECA",".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit=compUnit)


  # 3) Point Source Pollution
  thresh<-c(1,20) #passing in the thresholds for the indicator
  Box.2(dataframe1=dataWet, dataframe2=dataBC,
        use.field="Pnt_Src_Plltn_Final_Count",
        use.xlab=expression("Point Source (#)"),
        use.units=quote('#'),
        use.t=thresh,
        use.filename=file.path(outdir,paste(Wet.abbrev,"_","PT_SRC",".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit=compUnit)

}
