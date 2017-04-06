## Working directory is ~/UCI HAR Dataset (or wherever you unpacked the files)

##Step 1 read in and merge the two data sets, with subject ids and activity labels:
test_data <- read.table("test/X_test.txt")
test_subjects <- read.table("test/subject_test.txt")
test_activities <- read.table("test/y_test.txt")

train_data <- read.table("train/X_train.txt")
train_subjects <- read.table("train/subject_train.txt")
train_activities <- read.table("train/y_train.txt")

test <- cbind(test_subjects, test_activities, test_data)
train <- cbind(train_subjects, train_activities, train_data)
data<-rbind(test,train)

##Step 2 label the variables
features<-read.table("features.txt")
colnames(data)<-c("subject", "activity", as.character(features[,2]))

##Step 3 Insert descriptive activity labels
labels <- read.table("activity_labels.txt")
data[,2] <- as.factor(data[,2])
levels(data[,2]) <- as.character(labels[,2])

##Step 4 select only the columns with means and SDs of measurements
keep<-grep("mean\\(|std", colnames(data)) #the parenthesis is needed to exclude 'meanFreq'
core_data<-data[,c(1,2,keep)]

##Step 5 create new df with averages of each variable by subject and activity
#install.packages("dplyr") ##this is easier with dplyr
library(dplyr)
new_data <- core_data %>% group_by(subject, activity) %>% summarise_each(funs(mean))