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
# Define a function for doing boxplots
#
# ------------------------------------------------------------------------------
Boxplots <- function(AOI.name, Wet.name, Wet.abbrev, dir.figs, dir.data, Inds, Inds_Label, Thresh, InU) {

  source('BoxFunction.R')

  #unit that is being evaluated - Watershed
  dataWshd<-read.csv(file.path(dir.data,paste('Watersheds_',Wet.name, ".csv",sep="")), header=T)
  #Compare to all wetlands in SSAF area
  dataSSAF<- read.csv(file.path(dir.data,"Watersheds_Context.csv"),header=T)

  #Must have 2 thresholds in thresh c(0.6,1.25), if binary then repeat c(30,30)
  thresh<-Thresh #passing in the thresholds for the indicator
  Box.2(dataframe1=dataWshd, dataframe2=dataSSAF,
        use.field=Inds,
        #use.xlab=expression(Inds_Label),
        use.xlab=Inds_Label,
        use.units=InU,
        use.t=thresh,
        use.filename=file.path(dir.figs,paste(Wet.abbrev,"_",Inds,".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit='All ')

}

# Same, but with F at the end of variables for Fish, which are non-risk related values.
BoxplotBack <- function(AOI.name, Wet.name, Wet.abbrev, dir.figs, dir.data, IndsN, Inds_Label_N, ThreshN, InUN) {

  source('NonRiskBoxFunction.R')

  #unit that is being evaluated - Watershed
  dataWshdF<-read.csv(file.path(dir.data,paste('WatershedsF_',Wet.name, ".csv",sep="")), header=T)
  #Compare to all wetlands in SSAF area
  dataSSAF_F<- read.csv(file.path(dir.data,"Watersheds_ContextF.csv"),header=T)

  #Must have 2 thresholds in thresh c(0.6,1.25), if binary then repeat c(30,30)
  threshn<-ThreshN #passing in the thresholds for the indicator
  Box.3(dataframe3=dataWshdF, dataframe4=dataSSAF_F,
        use.field=IndsN,
        #use.xlab=expression(Inds_Label),
        use.xlab=Inds_Label_N,
        use.units=InUN,
        use.t=threshn,
        use.filename=file.path(dir.figs,paste(Wet.abbrev,"_",IndsN,".png",sep="")),
        use.cuname=Wet.name,
        use.compUnit='All ')

}
