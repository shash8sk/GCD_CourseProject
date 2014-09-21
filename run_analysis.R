## Ensure the datsets from the unzipped files are in your working directory

Xtrain <-read.table("X_train.txt")
Xtest <-read.table("X_test.txt")

MergedData<-rbind(Xtrain, Xtest)

subtrainX <- read.table("subject_train.txt")
subtestX <- read.table("subject_test.txt")

##Merge and assign xolnames, Xtrain has 561 vars labelled V1-V561

Mergedsubj<-rbind(subtrainX, subtestX)
colnames(Mergedsubj) <- c("V562")

Act_train <- read.table("Y_train.txt")
Act_test <- read.table("Y_test.txt")

MergedAct<-rbind(Act_train, Act_test)
colnames(MergedAct) <- c("V563")

ActData <- cbind(MergedData,Mergedsubj,MergedAct)

features <- read.table("features.txt",as.is = T)
str(features)
vecnames <- c(features$V2, "Subject", "Activity")
colnames(ActData) <- vecnames

## extract the mean. std deviation vars and subject and activity columns
cols <-grep("mean|std|Subject|Activity", vecnames, value = TRUE) 

Data_subset <- ActData[,c(cols)]

## recode activity variables to have meaningful names
library(car)
Data_subset$Activity <- recode(Data_subset$Activity,"1= 'WALKING' ;2='WALKING_UPSTAIRS';
3='WALKING_DOWNSTAIRS';
4='SITTING';
5='STANDING';
6='LAYING'")

## Calculate average of all the mean and std dev variables
library(dplyr)
result<-group_by(Data_subset, Subject, Activity) %>% summarise_each(funs(mean))
str(result)
summary(result)

## export tidy dataset
## modify the path to your destination folder as needed
write.table(result, "samsung_tidy_data.txt", sep="\t") 

