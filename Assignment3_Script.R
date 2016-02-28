#
#  This file is created for assignment3 for the
#  Getting and Cleaning Data course.
#
#  The original data used for this course was dervied from:
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones



#====================DOWNLOAD FILE========================
if (!file.exists("working")) {
    dir.create("working")
}

setwd("./working")

if (!file.exists("data")) {
    dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "data/data.zip"
download.file(fileUrl, destfile = destFile, method="curl")
dateDL <- date()
unzip("data/data.zip", exdir = "data/")
unlink("data/data.zip")
rm("destFile", "fileUrl")
#=================END FILE DOWNLOAD=========================

#Combine the 3 test files
testData <- read.csv("data/UCI HAR Dataset/test/X_test.txt", head=FALSE, sep = "")
testID <- read.csv("data/UCI HAR Dataset/test/subject_test.txt", head=FALSE, sep = "")
testActivity <- read.csv("data/UCI HAR Dataset/test/y_test.txt", head=FALSE, sep = "")
testFrame <- cbind(testID,testActivity, testData)
rm("testID", "testActivity", "testData")
gc()

#Combine the 3 train files
trainData <- read.csv("data/UCI HAR Dataset/train/X_train.txt", head=FALSE, sep="")
trainID <- read.csv("data/UCI HAR Dataset/train/subject_train.txt", head=FALSE, sep = "")
trainActivity <- read.csv("data/UCI HAR Dataset/train/y_train.txt", head=FALSE, sep="")
trainFrame <- cbind(trainID, trainActivity, trainData)

#Include feature names with data
varVect <- as.character(read.csv("data/UCI HAR Dataset/features.txt", header = FALSE, sep="")[["V2"]])
varVect <- c("PersonID", "Activity", varVect)
names(testFrame) <- varVect
names(trainFrame) <- varVect
rm("trainData", "trainID", "trainActivity")
gc()

#Provide descriptive activity names
activities <- read.csv("data/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep="")
activities$V2 <- as.character(activities$V2)
descriptiveActivityName <- function(a) {
    activities[activities[[1]] == a,][["V2"]]
}
testFrame$Activity <- sapply(testFrame$Activity, descriptiveActivityName)
trainFrame$Activity <- sapply(trainFrame$Activity, descriptiveActivityName)

#Combine test and training data into one set
allDataFrame <- rbind(testFrame,trainFrame)
rm("activities", "testFrame", "trainFrame")
gc()

#Reshape data
shapedFrame <- NULL
for (i in 3:563) {
    #Extracts only measurements on the mean for each measurement. 
    temp <- with(allDataFrame, 
                 tapply(
                     allDataFrame[[i]], 
                     list(allDataFrame$PersonID, allDataFrame$Activity), 
                     mean
                )
            )
    temp <- data.frame(temp)
    
    #inner functions to help provide descriptive names
    modifyM <- function(x) {
        paste(x, "_MEAN", sep = "")
    }
    modifyS <- function(x) {
        paste(x, "_SD", sep = "")
    }
    names(temp) <- sapply(names(temp), modifyM) 
    
    
    #Extract SD
    temp2 <- with(allDataFrame, 
                 tapply(
                     allDataFrame[[i]], 
                     list(allDataFrame$PersonID, allDataFrame$Activity), 
                     sd
                 )
    )
    temp2 <- data.frame(temp2)
    names(temp2) <- sapply(names(temp2), modifyS)
    #finish providing descriptive variable names, combine the mean & sd measurements
    temp2 <- cbind(PersonID=1:30, Features=rep(varVect[i], 30), temp, temp2)
    #create new dataset
    shapedFrame <- rbind(shapedFrame, temp2)
}
rm("allDataFrame", "varVect")
gc()

#create text file
shapedFrame <- tbl_df(shapedFrame)
shapedFrame <- arrange(shapedFrame, PersonID)
write.table(shapedFrame, file="ActivityMeans.txt", row.names = FALSE, sep="   ")
rm("shapedFrame", "temp", "temp2", "i", "descriptiveActivityName", 
   "modifyM", "modifyS")
gc()
#remove original data when clean up is complete.
unlink("data/", recursive = TRUE)



