# Getting and Cleaning the Data
# Course Project

### 0 DOWNLOAD THE DATA
# download zip file containing data 
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

# check if it hasn't already been downloaded
if (!file.exists(zipFile)) {
        download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
        unzip(zipFile)
}


### UPLOAD THE DATA

# Set working directory
setwd("~/Desktop/Coursera R/UCI HAR Dataset/train")

# Upload the train data
train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")
train_sbj <- read.table ("subject_train.txt")

# Upload the test data
setwd("~/Desktop/Coursera R/UCI HAR Dataset/test")
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")
test_sbj <- read.table ("subject_test.txt")

# Read features
setwd("~/Desktop/Coursera R/UCI HAR Dataset")
features <- read.table("features.txt")

# Read activity labels
activities <- read.table ("activity_labels.txt")
activities[,2] <- as.character(activities[,2])

### 1 MERGE THE DATA to 3 sets 
x_data <- rbind(train_x, test_x)
y_data <- rbind(train_y, test_y)
s_data <- rbind(train_s, test_s)


### 2 Extract the measurements on the mean and standard deviation for each measurement

selectedCols <- grep("-(mean|std).*", as.character(features[,2]))
selectedColNames <- features[selectedCols, 2]


### 3 Use descriptive activity names to name the activities in the data set
selectedColNames <- gsub("^f", "frequencyDomain", selectedColNames)
selectedColNames <- gsub("^t", "timeDomain", selectedColNames)
selectedColNames <- gsub("Acc", "Accelerometer", selectedColNames)
selectedColNames <- gsub("Gyro", "Gyroscope", selectedColNames)
selectedColNames <- gsub("Mag", "Magnitude", selectedColNames)
selectedColNames <- gsub("Freq", "Frequency", selectedColNames)
selectedColNames <- gsub("BodyBody", "Body", selectedColNames)
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)



### 4 Label the data appropreately with descriptive variable names
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

# Replace activities in Activity column with the approapreate names
allData$Activity <- factor(allData$Activity, levels = activities[,1], labels = activities[,2])
allData$Subject <- as.factor(allData$Subject)


### 5  Create a second, independent tidy data set with the average of each variable for each activity and each subject.
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

str(tidyData)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)