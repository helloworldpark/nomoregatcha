library("ggplot2")
library("dplyr")

######################################
##### Plotting for Ideal Gatchas #####
######################################

# Loading Data

ntag <- rep(as.character(1:30), each=10000)
gatcha.u <- data.frame(Picks=rep(0, times=10000*30), Tag=ntag)

for(i in 1:30)
{
  tmp <- read_csv(paste("~/Documents/gatcha_uniform_",i,".csv", sep=""))
  gatcha.u$Picks[(((i-1)*10000+1):(i*10000))] <- tmp$Picks
}

gatcha.ideal <- read_csv(paste("~/Documents/gatcha_ideal.csv", sep=""))

# Draw Histogram
items.toDraw <- as.character(c(10,20,30))
ggplot(data=filter(gatcha.u, Tag == items.toDraw)) + 
  geom_density(aes(x = Picks, fill = Tag)) + 
  labs(x = "Picks for completing a n-item set",
       y = "Density") + 
  scale_fill_manual(name=" No. of \n Items(n)",
                    values=c("10" = "#deebf775", "20" = "#9ecae175", "30" = "#3182bd75"))

tt <- select(gatcha.u, Picks, Tag) %>% 
  group_by(Tag) %>% 
  summarize(mean(Picks))
colnames(tt) <- c("Tag", "Mean")
tt$IdealMean <- gatcha.ideal$Mean

tt.draw <- select(tt, Mean, IdealMean)

tt.draw.format <- data.frame(Items = factor(rep(1:30, times=2)),
                             Type = factor(rep(c("Simulation", "Theoretical"), each=30)),
                             Mean = c(tt.draw$Mean, tt.draw$IdealMean))

ggplot() + 
  geom_bar(data=filter(tt.draw.format, Type == "Simulation"), 
           aes(x=Items, y=Mean, fill="Simulation"), 
           stat="identity", 
           position=position_dodge()) + 
  geom_line(data=filter(tt.draw.format, Type == "Theoretical"),
            aes(group=Type, x = Items, y = Mean, colour = "Theoretical")) +
  geom_point(data=filter(tt.draw.format, Type == "Theoretical"),
            aes(x = Items, y = Mean),
            col="#2c7bb6") + 
  scale_colour_manual(" ", values=c("Simulation" = "#fdae61", "Theoretical" = "#2c7bb6")) + 
  scale_fill_manual("", values=c("Simulation" = "#fdae61")) + 
  theme(legend.key = element_blank(),
        legend.title = element_blank(),
        legend.box = "horizontal",
        legend.position = "bottom")+
  labs(x = "No. of items to collect",
       y = "Mean of picks to collect all")

######################################
##### Plotting for Weird Gatchas #####
######################################

# Loading Data
ntag <- rep(as.character(12:1), each=10000)
gatcha.r <- data.frame(Picks=rep(0, times=10000*12), Tag=factor(ntag))

for(i in 12:1)
{
  path <- paste("~/Documents/gatcha_rare_0.",formatC(i, width=2, flag="0"),".csv", sep="")
  tmp <- read_csv(path)
  p <- 13 - i
  gatcha.r$Picks[(((p-1)*10000+1):(p*10000))] <- tmp$Picks
}

# Draw Histogram
items.toDraw <- as.character(c(4,2,1))
ggplot(data=filter(gatcha.r, Tag == items.toDraw)) + 
  geom_density(aes(x = Picks, fill = Tag)) + 
  labs(x = "Picks for completing a 8-item set",
       y = "Density") + 
  scale_fill_manual(name=" Prob. of \n Rare Item",
                    labels=c("4" = "4%", "2" = "2%", "1" = "1%"),
                    values=c("4" = "#bababa44", "2" = "#f4a58244", "1" = "#ca002044"))

rr <- select(gatcha.r, Picks, Tag) %>% 
  group_by(Tag) %>% 
  summarize(mean(Picks))
colnames(rr) <- c("Tag", "Mean")
rr <- mutate(rr, sortingTag = as.numeric(levels(rr$Tag))[rr$Tag]) %>%
  arrange(desc(sortingTag)) %>%
  select(Mean, Tag)

rr.draw <- select(rr, Mean)
rr.label <- c(0.12, 0.11, 0.10, 0.09, 0.08, 0.07,
              0.06, 0.05, 0.04, 0.03, 0.02, 0.01)
rr.draw$Odds <- factor(rr.label, levels=rr.label[rev(order(rr.label))])

ggplot(data=rr.draw, aes(x=Odds, y=Mean)) + geom_line(aes(group=1)) + 
  geom_point() + 
  labs(x = "Probability of picking a rare item",
       y = "Mean of picks to collect all items")
