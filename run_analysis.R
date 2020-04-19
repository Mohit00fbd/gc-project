## Loading Libraries
library(dplyr)

## Constants
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Create data directory if it doesn't exist
if(!dir.exists("data")){
  dir.create("data")
}

## Download the zip file in data directory
download.file(file_url, destfile = "./data/human_activity_recognition_using_smartphones.zip")


## Unzip the downloaded file
unzip("./data/human_activity_recognition_using_smartphones.zip", exdir = "data")

## List files unzipped
list.files("./data/UCI HAR Dataset/")

## Reading train files
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
str(train_x)

train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE)
str(train_y)
train_y <- train_y %>% rename(V562 = V1)

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_train <- subject_train %>% rename(V563 = V1)
## Combine x and y variables
train <- cbind(train_x, train_y, subject_train)
str(train)


## Readin test files
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
str(test_x)

test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE)
str(test_y)
test_y <- test_y %>% rename(V562 = V1)

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject_test <- subject_test %>% rename(V563 = V1)
## Combine x and y variables
test <- cbind(test_x, test_y, subject_test)
str(test)

## Combining test and train datasets
activity_reco <- rbind(train, test)
str(activity_reco)


## Reading feature names from features.txt file
f_names <- read_lines("./data/UCI HAR Dataset/features.txt")
f_names <- sub("[0-9]+ ","", f_names)
str(f_names)
f_names <- append(f_names, c("activity", "subject"))

f_names <- make.names(f_names, unique = TRUE)
f_names

## Changing the column names to descriptive ones
colnames(activity_reco) <- f_names 
str(activity_reco)

names(activity_reco) <- gsub("Acc", "accelerometer", names(activity_reco))
names(activity_reco) <- gsub("Gyro", "gyroscope", names(activity_reco))
names(activity_reco) <- gsub("BodyBody", "body", names(activity_reco))
names(activity_reco) <- gsub("Mag", "magnitude", names(activity_reco))
names(activity_reco) <- gsub("^t", "time", names(activity_reco))
names(activity_reco) <- gsub("^f", "frequency", names(activity_reco))
names(activity_reco) <- gsub("tBody", "time_body", names(activity_reco))
names(activity_reco) <- gsub("-mean()", "mean", names(activity_reco))
names(activity_reco) <- gsub("-std()", "std", names(activity_reco))
names(activity_reco) <- gsub("-freq()", "freq", names(activity_reco))


## Selecting only mean and standard deviation of each measurement
activity_reco <- activity_reco %>%
  select( contains(c("mean", "std", "activity", "subject")) )
str(activity_reco)

## Labeling Activity Names
activity_names <- read_lines("./data/UCI HAR Dataset/activity_labels.txt")
activity_names <- sub("[0-9]+ ", "", activity_names)

activity_reco$activity <- factor(activity_reco$activity, labels = activity_names)
activity_reco$activity

## Another tidy dataset with the average of each variable for each activity and each subject
avg_data <- activity_reco %>% group_by(activity, subject) %>% 
  summarise_all(mean)
str(avg_data)

## Write data to resulting data file
write.table(avg_data, "./data/resulting_data.txt")

