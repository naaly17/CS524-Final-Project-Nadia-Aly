walltimes<-read.csv("flou_walltimes_new.csv",sep=",",header=TRUE)
robtimes<-read.csv("rob_walltimes.csv",sep=",",header=TRUE)
alltimes<-read.csv("master.csv",sep=",",header=TRUE)
subset<-read.csv("master_subset.csv",sep=",",header=TRUE)


alltimes$jobnames <-as.numeric(alltimes$jobname)
alltimes$group <-as.numeric(alltimes$group)
alltimes$username<-as.numeric(alltimes$username)

write.table(alltimes, "master_factors.csv",sep=",",header=TRUE)

for(t in unique(alltimes$group)) {
  alltimes[paste("type",t,sep="")] <- ifelse(alltimes$jobname==t,1,0)
}
head(alltimes)

jobnames <-alltimes$jobname
times <-robtimes$length

set.seed(101)
x <- c(0:length(alltimes$jobname))
names <- sample(x, 18,replace = FALSE, prob = NULL)
unique_names <- unique(jobnames)

times1 <- times[jobnames==jobnames[names[1]]]
hist(times1, xlim=c(0,max(times1)), type="l",xlab="Time", main=names[1], probability=TRUE,col="gray", border="white")

jobnames <-unique(alltimes$jobname)

names = c(jobnames[3],jobnames[10], jobnames[50],jobnames[50])
names=c("run_bayes ","runscript_casestudy.txt","runscript_geoSIMEX_dist.txt", "runscript_geoSIMEX.txt", "runscript_geoSIMEXd.txt","runscript_noMPI.txt","runscript_noMPI2.txt", "runscript_opt", "runscript_test.txt")

par(mar = rep(2, 4))
par(mfrow = c( 6, 3 ))
for(i in 1:(length(names))){
  new = names
  times1 <- alltimes$walltime[alltimes$jobname==alltimes$jobname[new[i]]]
  hist(times1, xlim=c(0,max(times1)),xlab="Time", main=alltimes$jobname[new[i]], col="gray", border="white", breaks=max(times1)/200)
}

i=1750
times1 <- alltimes$walltime[alltimes$jobname==alltimes$jobname[i]]
hist(times1, xlim=c(0,max(times1)),xlab="Time", main=alltimes$jobname[i], col="gray", border="white", breaks=max(times1)/2000)


hist(times[jobnames=="SRAD_SRAD"], xlim=c(0,max(times[jobnames=="SRAD_SRAD"])), type="l",xlab="Time", main="SRAD_SRAD", probability=TRUE,col="gray", border="white")
hist(times[jobnames=="SCP_MUM"], xlim=c(0,max(times[jobnames=="SCP_MUM"])), type="l",xlab="Time", main="SRAD_SRAD", probability=TRUE,col="gray", border="white")
hist(times[jobnames=="TRA"], xlim=c(0,max(times[jobnames=="TRA"])), type="l",xlab="Time", main="SRAD_SRAD", probability=TRUE,col="gray", border="white")



library("fitdistrplus")
library("ggplot2")
library("randomForest")

BH.rf <- randomForest(walltime~username+group, data=alltimes)
print(BH.rf)

randomForest.formula(formula = medv ~ .,
                       data = Boston)

ggplot(walltimes, aes(walltimes$X1, fill = walltimes$jobname)) +
  geom_density(position = "stack")

ggplot(data = walltimes,aes(x=walltimes$time,fill=as.factor(walltimes$jobname))) + geom_histogram(position = "dodge")+xlim(0,1000)

hist(alltimes$walltime, breaks=max(alltimes$walltime), ylim=c(0,100), xlim=c(0,200000), main="Histogram of All user Job Lengths", xlab = "Length of Job (seconds)")

hist(robtimes$time[robtimes$time>0], breaks=max(robtimes$time), ylim=c(0,120), xlim=c(1,1000), main="Histogram of User RAMARTY Job Lengths", xlab = "Length of Job (seconds)")

par(mfrow=c(1,2))
hist(walltimes$time, breaks=max(walltimes$time), ylim=c(0,200), xlim=c(0,1000), main="Histogram of User FLOU Job Lengths", xlab = "Length of Job (seconds)")
plot(density(walltimes$time), xlim=c(0,40000), main="PDF of User FLOU Job Lengths", xlab = "Length of Job (seconds)")


alltimes2 <-head(alltimes,2000)
lm.fit=lm(walltime ~ username+ group, data = alltimes)
summary(lm.fit)
rmse=sqrt(sum(lm.fit$residuals*lm.fit$residuals)/length(lm.fit$residuals))

var <- walltimes$walltime_used

walltimes$var2 <- var[var>0]
  
plot(density(var2), main="PDF of User Job Length", xlab="Job Length")

var2 <- var[var>0]

ggplot(walltimes$time, aes(walltimes$time)) +
  geom_density() + xlim(0,75000)

hist(cputimes$job_length_seconds, breaks=359630, ylim=c(0,120), xlim=c(0,2000000), main="Histogram of User FLOU Job Lengths", xlab = "Length of Job (seconds)")


par(mfrow=c(1,2))
plot(density(var), main="PDF of User Job Length", xlab="Job Length")
plot(density(quants_list), main="PDF of User Job Length \n Using Trace Approximation", xlab="Job Length")


root_times <- read.csv("root_walltimes2.csv")
hist(root_times$X1, breaks=max(root_times$X1), xlim=c(0,175), ylim=c(0,4500), main="Histogram of Root Job Lengths", xlab = "Length of Job (seconds)")
#P= ecdf(root_times$X1) # P is a function giving the empirical CDF of X
#plot.ecdf(P, main="CDF", xlab="Degrees", ylab="F(x)")
var <- root_times$X1
hist(var, breaks=359630, ylim=c(0,120), xlim=c(0,800000), main="Histogram of User Job Lengths", xlab = "Length of Job (seconds)")
plot(density(var), )

par(mfrow=c(1,2))

ggplot(walltimes, aes(walltimes$time)) +
  geom_density()+xlim(0,75000)

ggplot(data = walltimes,aes(x=walltimes$time)) + geom_histogram(position = "dodge")+xlim(0,75000)



par(mfrow=c(1,2))
qplot(var, data=walltimes, geom="histogram",binwidth=10)

quants_list = matrix(0,nrow=100,ncol=1)
for(i in 0:(100)){
  quant = i/100
  quants_list[i+1] = quantile(alltimes$walltime, quant)
  print(quant)
  print(quants_list[i+1])
}

par(mfrow=c(1,2))
plot(density(var), main="PDF of Root Job Length", xlab="Job Length", xlim=c(0,1000))
plot(density(quants_list), main="PDF of Root Job Length \n Using Trace Approximation", xlab="Job Length", xlim=c(0,1000))

regular <- read.csv("regular_arrival_times2.csv")

var <- regular$inter_arrival_time
hist(var, breaks=max(var), ylim=c(0,120), xlim=c(0,1000), main="Histogram of User Interarrival Times", xlab = "Interarrival Time (seconds)")

quants_list = matrix(0,nrow=100,ncol=1)
quants_list_print = matrix(0,nrow=100,ncol=1)
for(i in 0:(100)){
  quant = i/100
  print(quant)
  quants_list[i+1] = quantile(var, quant)
  quants_list_print[i+1]=quant
  print(quants_list[i+1])
}

par(mfrow=c(1,2))
plot(density(var), main="PDF of User Interarrival Times", xlab="Interarrival Time (seconds)", xlim=c(0,10000))
plot(density(quants_list), main="PDF of User Interarrival Times \n Using Trace Approximation", xlab="Interarrival Time (seconds)", xlim=c(0,10000))

count_list = matrix(0,nrow=10713,ncol=1)
jobCount <- as.numeric(as.factor(alltimes$jobname))
for(i in 1:max(jobCount)){
  index = which(jobCount == i)
  count_list[i] = length(index)
}
  
