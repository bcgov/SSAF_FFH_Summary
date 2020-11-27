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

#Output box plots as a single graphic
library(knitr)
library(png)

IndicatorsW<-c('Rd_Density_net','ECA_Final_PCNT', 'Pnt_Src_Plltn_Final_Count')
IndicatorsWFile<-c('RoadDensity','ECA','PT_SRC')
Indicators<-c('RoadDensity_100m','RoadDensity_2000m','Nat_SemiNat_PCT')
IndicatorsFile<-c('RoadDensity_100m','RoadDensity_2000m','Nat_SemiNat_PCT')


imageL<-list()

for (i in 1:nrow(nameWshd)) {
  Wshd.name <- nameWshd[i,]

  for (j in 1:length(IndicatorsWFile)) {
    file.name <- IndicatorsWFile[j]
    imageL[[j]]<-readPNG(file.path(figsOutDir,paste(Wshd.name,"_",file.name,".png",sep="")), native=TRUE, info=TRUE)
  }

  for (k in 1:length(IndicatorsFile)) {
    file.name <- IndicatorsFile[k]
    imageL[[k+length(IndicatorsWFile)]]<-readPNG(file.path(figsOutDir,paste(Wshd.name,"_",file.name,".png",sep="")), native=TRUE, info=TRUE)
  }

  TextL<-c(IndicatorsWFile,IndicatorsFile)
  TextL<-c("Road Density","Equivalent Clear-cut Area","Point Source per Watershed",
           "RoadDensity 100m","RoadDensity 2 km","%Natural/Semi-Natural Disturbed")

  numFiles<-length(TextL)

  pdf(file=file.path(figsOutDir,paste(Wshd.name,'.pdf', sep="")))
  #plot.new()
  par(mfrow=c(numFiles,1),mar=rep(0,4)) # rep(4)no margins
  #c(5, 4, 4, 2) + 0.1
  # layout the plots into a matrix w/ 12 columns, by row
  #layout(matrix(1:2, ncol=1, byrow=TRUE))

  # do the plotting
#for(i in 1:length(IndicatorsWFile)) {
    for(i in 1:numFiles) {
      #text(.5,.5, "Test", cex=5, col=rgb(.2,.2,.2,.7))
    plot(NA,xlim=0:1,ylim=0:1,xaxt="n",yaxt="n",bty="n")
    #plot(NA,xlim=0:1,ylim=0:1,xaxt="n",yaxt="n",bty="n")
    rasterImage(imageL[[i]],0,0,1,1)
    text( 0.15,0.25,TextL[[i]], cex=1.4)
  }

  dev.off()
}

