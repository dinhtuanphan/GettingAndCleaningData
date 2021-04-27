library(dplyr)

# Read train data
XTrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
YTrain <- read.table('./UCI HAR Dataset/train/Y_train.txt')
subTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt') 


# Read test data
XTest <- read.table('./UCI HAR Dataset/test/X_test.txt')
YTest <- read.table('./UCI HAR Dataset/test/Y_test.txt')
subTest <- read.table('./UCI HAR Dataset/test/subject_test.txt') 

# Read data description
varNames <- read.table('./UCI HAR Dataset/features.txt')
actLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')


# Merges the training and the test sets to create one data set
X <- rbind(XTrain,XTest)
Y <- rbind(YTrain, YTest)
sub <- rbind(subTrain,subTest)

# Extracts only the measurements on the mean and standard deviation for each measurement
meanStdVar <- varNames[grep('mean\\(\\)|std\\(\\)',varNames[,2]),]
NROW(meanStdVar)
X <- X[,meanStdVar[,1]]
  
# Uses descriptive activity names to name the activities in the data set
colnames(Y) <- 'activity'
Y$activityLabel <- factor(Y$activity,labels = as.character(actLabels[,2]))
activityLabel <- Y[,-1]

# Appropriately labels the data set with descriptive variable names
colnames(X) <- varNames[meanStdVar[,1],2]

# From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject

colnames(sub) <- "subject" 
total <- cbind(X,activityLabel,sub)
totalMean <- total %>% group_by(activityLabel,subject) %>% summarise_each(funs(mean))

# Final tidy data to submit
write.table(totalMean, file = './tidydata.txt',row.names = FALSE, col.names = TRUE)
