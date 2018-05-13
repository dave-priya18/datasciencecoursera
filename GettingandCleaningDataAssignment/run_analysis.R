# 0. Downloading dataset
if(!file.exists("./File")){dir.create("./File")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./File/UCI_HAR_Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./File/UCI_HAR_Dataset.zip",exdir="./File")

# 1. Merging the training and the test sets to create one data set:

# 1.1 Reading files

# 1.1.1 Reading trainings tables:
x_train <- read.table("./File/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./File/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./File/UCI HAR Dataset/train/subject_train.txt")

# 1.1.2 Reading testing tables:
x_test <- read.table("./File/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./File/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./File/UCI HAR Dataset/test/subject_test.txt")

# 1.1.3 Reading feature vector:
feature <- read.table('./File/UCI HAR Dataset/features.txt')

# 1.1.4 Reading activity labels:
activityLabels = read.table('./File/UCI HAR Dataset/activity_labels.txt')

# 1.2 Assigning column names:
colnames(x_train) <- feature[,2] 
colnames(y_train) <-"activity_id"
colnames(subject_train) <- "subject_id"

colnames(x_test) <- feature[,2] 
colnames(y_test) <- "activity_id"
colnames(subject_test) <- "subject_id"

colnames(activityLabels) <- c('activity_id','activityType')

# 1.3 Merging all data in one set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# 2. Extracting only the measurements on the mean and standard deviation for each measurement

# 2.1 Reading column names:
colNames <- colnames(setAllInOne)

# 2.2 Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("activity_id" , colNames) | 
                   grepl("subject_id" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# 2.3 Making nessesary subset from setAllInOne:
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# 3. Using descriptive activity names to name the activities in the data set:
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activity_id',
                              all.x=TRUE)

# 4. Appropriately labeling the data set with descriptive variable names.
# This step was made in previos steps =) See 1.3, 2.2, 2.3.

# 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject:

# 5.1 Making second tidy data set 
Tidy_set <- aggregate(. ~subject_id + activity_id, setWithActivityNames, mean)
Tidy_set <- Tidy_set[order(Tidy_set$subject_id, Tidy_set$activity_id),]

# 5.2 Writing second tidy data set in txt file
write.table(Tidy_set, "Tidy_set.txt", row.name=FALSE)

