# Getting and Cleaning Data Course Project
# Peer Assessments
# Here are the data for the project: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.

train_s <- read.table("train/subject_train.txt")
test_s <- read.table("test/subject_test.txt")
str(train_s)
str(test_s)

train_y <- read.table("train/y_train.txt")
test_y <- read.table("test/y_test.txt")
str(train_y)
str(test_y)

train_x <- read.table("train/X_train.txt")
test_x <- read.table("test/X_test.txt")
str(train_x)
str(test_x)

dataSubject <- rbind(train_s, test_s)
dataActivity<- rbind(train_y, test_y)
dataFeatures<- rbind(train_x, test_x)

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table("features.txt")
names(dataFeatures)<- dataFeaturesNames$V2
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

# Extracts only the measurements on the mean and standard deviation for each measurement. 

subdataFNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)

# Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] = gsub("_","",tolower(as.character(activityLabels[,2])))
dataActivity[,1] = activityLabels[dataActivity[,1],2]
names(dataActivity) <- "activity"

# Appropriately labels the data set with descriptive variable names.

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt", row.name=FALSE)
str(Data2)