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
library(scales)
library(ggplot2)
library(RColorBrewer)

#Summarizes Wetlands by Major Watershed
#By Don Morgan, MoE

IndicatorLevels<-list()

#Loop through make a list for each
for (i in 1:length(CatIndicators)) {
  IndicatorLevels[[i]]<-Wetlands_Context %>%
    dplyr::select(MWshd,Wetland_Co, IndicatorLevel = CatIndicators[i]) %>%
    mutate(IndicatorType = CatIndicators[i])
}
#Row bind the list to make a GBPU, IndicatorLevel, ThreatLevel table for graphing
IndTableAll<-  bind_rows(IndicatorLevels)

IndTableAll$IndicatorLevel <- factor(IndTableAll$IndicatorLevel, levels=c("High", "Medium", "Low", "Zero"))
IndTableAll$IndicatorType <- factor(IndTableAll$IndicatorType, levels=rev(CatIndicators))


#Set colours
CatPalette<-c('#92D050','#FFC000','#FF0000','#D0CECE')
HydroFInds<-c("FloodControl_function_flag","WaterPurification_function_flag")
HydroFNames<-c("Flood Reduction Potential","Water Purification")
HydroBInds<-c("SocietalAsset_5km_ds_flag","SocietalAsset_WQ_Class_flag")
HydroBNames<-c("Flood Reduction Benefits","Water Purifications Benefits")
SupportInds<-c('Aquatic_Life_Support_flag','Moose_Forage_flag','Sufficient_OG_flag','Protected_Ovrlp_flag')
SupportNames<-c('Aquatic Life Support','Moose Forage','Habitat Connectivity','Wetland Conservation')
CulturalInds<-c('RAAD_500m_flag','Cultural_Access_Class_flag')
CulturalNames<-c('Proximity to Known Arch. Site','Cultural Accessibility')

xlab<-c("Hydrological Function Indicators","Hydrological Benefitt Indicators","Habitat Function Indicators","Cultural Indicators")
IndGroups<-list(HydroFInds, HydroBInds, SupportInds,CulturalInds)
IndGroupNames<-list(HydroFNames, HydroBNames, SupportNames,CulturalNames)

#Loop through each indicator groups
for (j in 1:length(IndGroups)) {
IndG<-IndGroups[[j]]
IndGNames<-IndGroupNames[[j]]
#Loop through each Major Watershed and generate a graph
for (i in 1:length(Wshd.context)) {

  #Step for doing SSAF wide bar
  #if(i==length(Wshd.context)+10) {
  #  BarShed='SSAF'
  #  IndTable<-IndTableAll %>%
  #    dplyr::filter(IndicatorType %in% IndG)
 # } else {
  BarShed<-Wshd.context[i]
  IndTable<-IndTableAll %>%
  dplyr::filter(MWshd==BarShed) %>%
  dplyr::filter(IndicatorType %in% IndG)
 # }
  #IF colours not working for certain graph sets then manual change pallete - not ideal but it works
  #CatPalette<-c('#92D050','#FFC000','#D0CECE')

pdf(file=file.path(figsOutDir,paste(BarShed,"_",xlab[j],'.pdf', sep="")))
print(ggplot(data=IndTable) +
  geom_bar(aes(x = factor(IndicatorType), fill = IndicatorLevel),
           position = position_stack(reverse = TRUE), width = 0.75) +
  scale_fill_manual(values=CatPalette) +
#scale_fill_manual(values=brewer.pal(5, 'RdYlGn')[2:5]) +
  labs(fill = 'Category') +
  scale_x_discrete(limit = rev(IndG),
                   labels = rev(IndGNames)) +
  xlab(xlab[j]) + ylab("Proportion of Wetlands") +
  theme(axis.title = element_text(size = 20)) +
  theme(axis.text = element_text(size = 15)) +
  theme(legend.text=element_text(size=15)) +
  theme(legend.title=element_text(size=15)) +

  coord_flip() +
  theme(panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks  = element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        axis.line   = element_line(colour=NA),
        panel.border = element_rect(colour = "black", fill=NA, size=2)))
dev.off()
}

}

#Data check
#tt<- Wetlands_Context %>%
#  dplyr::filter(Wetland_Co==80) %>%
#  dplyr::select(Wetland_Co, FloodControl_function, FloodControl_function_flag,
#                WaterPurification_function,WaterPurification_function_flag)


