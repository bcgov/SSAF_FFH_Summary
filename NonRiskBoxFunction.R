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

#Box.2<-function(dataframe1, dataframe2, use.field="", use.xlab, use.units="", use.t, use.filename="", use.cuname="", use.compUnit=""){
Box.3<-function(dataframe3, dataframe4, use.field="", use.xlab="", use.units="", use.t, use.filename="", use.cuname="", use.compUnit=""){
  use.df3<-as.numeric(unlist(dataframe3[use.field]))
  use.df4<-as.numeric(unlist(subset(dataframe4[use.field],dataframe4[use.field]!="-")))
  n.df3<-length(use.df3)
  n.df4<-length(use.df4)
  use.xlim<-round(max(use.df4)+.1*max(use.df4))

  # set-up 8 x 1.5 inch PNG output file and plot margins
  png(use.filename,width=8,height=1.5,units="in",res=150)
  par(pin=c(8.5, 1.5),mai=c(0.6,2.7,0.1,1.8),
      #par(pin=c(8.5, 1.5),mai=c(0.6,2.2,0.1,1.8),
      cex=1,mgp=c(1.6,0.5,0),ljoin=1,las=1)

  # force to not use scientific notation for numbers
  options(scipen=50)

  # empty plot
  boxplot(list(use.df3,use.df4),horizontal=TRUE,las=1,
          medlty='blank',boxlty="blank",whisklty="blank",names=c("",""),
          staplelty='blank',outlty='blank',outpch=NA,
          xlab=use.xlab)

  # draw shaded green/yellow/red background based on threshold values
  cust.green <- rgb(184,209, 178,  alpha=150, maxColorValue=255)
  cust.green2<-rgb(120, 166, 111, alpha=150, maxColorValue=255)
  cust.green3<-rgb(66, 128, 56, alpha=250, maxColorValue=255)

  # set left limit of green to -50000 so there is no white space
  rect(-50000,-1,use.t[1],100,col=cust.green,border=NA)
  rect(use.t[1],-1,use.t[2],100,col=cust.green2,border=NA)
  rect(use.t[2],-1,use.xlim+100,100,col=cust.green3,border=NA)

  # set-up and draw legend
  leg.pos<-"topleft"
  # if indicator has binary use.t...
  if ((use.t)[1]==(use.t)[2]){
    #if (use.t[1]==0 & use.t[2]==0){
    use.leg1<-c("Lower Amount",as.expression(bquote("(="~.(use.t[1])~.(use.units)*")")))
    use.leg2<-c("Higher Amount",as.expression(bquote("(>"~.(use.t[1])~.(use.units)*")")))
    legend(leg.pos,inset=c(1,0),xpd=TRUE,fill=c(cust.green,"white"),border=c("black","white"),
           legend=use.leg1, bty='n',y.intersp=.75)
    legend(leg.pos,inset=c(1,0.5),xpd=TRUE,fill=c(cust.green3,"white"),border=c("black","white"),
           legend=use.leg2, bty='n',y.intersp=.75)
  } else {
    if(use.t[1]==0){
      use.leg1<-c("Low Amount",as.expression(bquote("(="~.(use.t[1])~.(use.units)*")")))
      use.leg2<-c("Moderate Amount",as.expression(bquote("(>"~.(use.t[1])~.(use.units)*")")))
      use.leg3<-c("High Amount",as.expression(bquote("(>="~.(use.t[2])~.(use.units)*")")))
    } else {
      use.leg1<-c("Low Amount",as.expression(bquote("(<"~.(use.t[1])~.(use.units)*")")))
      use.leg2<-c("Moderate Amount",as.expression(bquote("(>="~.(use.t[1])~.(use.units)*")")))
      use.leg3<-c("High Amount",as.expression(bquote("(>="~.(use.t[2])~.(use.units)*")")))
    }
    legend(leg.pos,inset=c(1,0),xpd=TRUE,fill=c(cust.green,"white"),border=c("black","white"),
           legend=use.leg1, bty='n',y.intersp=.75)
    legend(leg.pos,inset=c(1,0.5),xpd=TRUE,fill=c(cust.green2,"white"),border=c("black","white"),
           legend=use.leg2, bty='n',y.intersp=.75)
    legend(leg.pos,inset=c(1,1),xpd=TRUE,fill=c(cust.green3,"white"),border=c("black","white"),
           legend=use.leg3, bty='n',y.intersp=.75)
  }

  # set boxplot colours
  cust.bpcol<-rgb(0,0,0,alpha=100,maxColorValue=255)
  cust.medcol<-rgb(0, 0, 0, maxColorValue=255)
  col.box<-cust.bpcol
  col.out<-cust.bpcol
  col.wsk<-cust.bpcol
  col.spl<-cust.bpcol
  col.med<-cust.medcol

  # draw boxplot
  boxplot(list(use.df3,use.df4),horizontal=TRUE,las=1,
          medcol=col.med,medlwd=3,boxwex=0.5,boxlty="blank",boxfill=col.box,whisklty="solid",whiskcol=col.wsk,
          whisklwd=2,staplecol=col.spl,staplelwd=2,outcol=col.out,outcex=.75,outpch=19,
          names=c(paste(use.cuname," Watersheds\n (n=",n.df3,")",sep=""),paste(use.compUnit, " Watersheds\n(n=",n.df4,")",sep="")),
          #names=c(paste("\n",use.cuname,"\nspawning watersheds\n(n=",n.df1,")",sep=""),paste("All Skeena watersheds\n(n=",n.df2,")",sep="")),cex.axis=.9,
          xlab=use.xlab,add=TRUE,ljoin=1)

  dev.off()

}
