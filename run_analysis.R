# JHU Coursera Data Cleaning project
# Data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

###########################################
# You should create one R script called run_analysis.R that does the following. 
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###########################################

# Setting Working directory

setwd("/Users/turanello/Desktop/Coursera JHU/UCI HAR Dataset")

# 1) Merging training and test data

features <- read.table("./features.txt", header=FALSE)
activityLabel <- read.table(".activity_labels.txt", header=FALSE)
subjectTrain <- read.table("./train/subject_train.txt", header=FALSE)
xTrain <- read.table("./train/X_train.txt", header=FALSE)
yTrain <- read.table(".train/y_train.txt", header=FALSE)

#Column names

colnames(activityLable) <- c("activityId", "activityType")
colnames(subjectTrain) <- "subId"
colnames(xTrain) <- features[,2]
colnames(yTrain) <- "activityId"

#Merging training data

trainData <- cbind(yTrain, subjectTrain, xTrain)

#Reading test data

subjectTest <- read.table("./test/subject_test.txt", header=FALSE)
xTest <- read.table("./test/X_test.txt", header=FALSE)
yTest <- read.table("./test/y_test.txt", header=FALSE)

#column names

colnames(subjectTest) <- "subId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"

#merging test data

testData <- cbind(yTest, subjectTest, xTest)

#merged data final

finalData <- rbind(trainData, testData)

#vector for column names to be used further

colNames <- colnames(finalData)

# 2) Extract only measurements on mean and std for each measurement

data_mean_std <- finalData[,grepl("mean|std|subject|activityId", colnames(finalData))]

# 3) use descriptive activity names

library(plyr)
data_mean_std <- join(data_mean_std, activityLable, by = "activityId", match = "first")
data_mean_std <- data_mean_std[,-1]

# 4) Appropriately label data with descriptive variable names

names(data_mean_std) <- make.names(names(data_mean_std))

#descriptive names

names(data_mean_std) <- gsub("Acc", "Acceleration", names(data_mean_std))
names(data_mean_std) <- gsub("^t", "Time", names(data_mean_std))
names(data_mean_std) <- gsub("^f", "Frequency", names(data_mean_std))
names(data_mean_std) <- gsub("BodyBody", "Body", names(data_mean_std))
names(data_mean_std) <- gsub("mean", "Mean", names(data_mean_std))
names(data_mean_std) <- gsub("std", "Std", names(data_mean_std))
names(data_mean_std) <- gsub("Freq", "Frequency", names(data_mean_std))
names(data_mean_std) <- gsub("Mag", "Magnitude", names(data_mean_std))

# 5) create second, independent tidy set with average of each variable

tidydata_average_sub <- ddply(data_mean_std, c("subject", "activity"), numcolwise(mean))

write.table(tidydata_average_sub, file = "tidydata.txt")