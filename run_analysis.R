#!/usr/bin/env Rscript

library(plyr)

if (!file.info('UCI HAR Dataset')$isdir) {
  url<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  dir.create('UCI HAR Dataset')
  download.file(url, 'UCI-HAR-dataset.zip', method='curl')
  unzip('./UCI-HAR-dataset.zip')
}

# load mappings
activity_labels<-read.csv("./UCI HAR Dataset/activity_labels.txt", header=F,  colClasses=c("integer", "factor"), sep="")
feature_names<-read.csv("./UCI HAR Dataset/features.txt", header=F, sep=" ")[,2]
# get ids of features with mean or std variables
ids<-grep("(mean|std)\\(\\)", feature_names)

# load measurements data
train.x <- read.csv("./UCI HAR Dataset/train/X_train.txt", header=F, colClasses=rep("numeric", length(feature_names)), col.names=feature_names, sep="")
test.x <- read.csv("./UCI HAR Dataset/test/X_test.txt", header=F, colClasses=rep("numeric", length(feature_names)), col.names=feature_names, sep="")
all.x <- rbind(train.x, test.x)

# load activiti ids
train.activity <- read.csv("./UCI HAR Dataset/train/y_train.txt", header=F, colClasses="integer")
test.activity <- read.csv("./UCI HAR Dataset/test/y_test.txt", header=F, colClasses="integer")
all.activity <- rbind(train.activity, test.activity)

# load subject ids
train.subject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header=F, colClasses="integer")
test.subject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header=F, colClasses="integer")
all.subject <- rbind(train.subject, test.subject)

# combine all data
all.combined <- cbind(subject=all.subject[,1], activity=all.activity[,1], all.x[,ids])

#set activity names from activity mapping
all.combined <- merge(all.combined, activity_labels, by.x = "activity", by.y = "V1")
all.combined$activity <- all.combined$V2
all.combined<-subset(all.combined, , -c(V2))

# calculate avereges for each variable in groups
all.avereges <- ddply(all.combined, c("subject","activity"), function(df) colMeans(df[-seq(2)], na.rm=T))

# save averege variable values for each subject-activity pair
write.table(all.avereges, "all.avereges.txt", row.names=F)

