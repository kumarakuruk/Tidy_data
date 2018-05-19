library(data.table)

getwd()

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file<-"./Data/UCI HAR Dataset.zip"

IF(!file.exists(zip_file))
{
        download.file(url, zip_file, mode="wb")
        unzip(zip_file, exdir="./data")
}

features_file<-read.csv("./Data/UCI HAR Dataset/features.txt", header=FALSE, sep=' ')
features <- as.character(features_file[,2])

data_train_X<-read.table("./Data/UCI HAR Dataset/train/X_train.txt")

data_train_activity<-read.csv("./Data/UCI HAR Dataset/train/y_train.txt", header=FALSE, sep=' ')
data_train_subject<-read.csv("./Data/UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep=' ')

data_train <-  data.frame(data_train_subject, data_train_activity, data_train_X)
names(data_train) <- c(c('subject', 'activity'), features)


data_test_X<-read.table("./Data/UCI HAR Dataset/test/X_test.txt")

data_test_activity<-read.csv("./Data/UCI HAR Dataset/test/y_test.txt", header=FALSE, sep=' ')
data_test_subject<-read.csv("./Data/UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep=' ')

data_test <-  data.frame(data_test_subject, data_test_activity, data_test_X)
names(data_test) <- c(c('subject', 'activity'), features)

data_all<-rbind(data_train, data_test)


mean_std_filter<- grep('mean|std', features)

data_partial<-data_all[,c(1,2,mean_std_filter+2)]


activity_labels<-read.csv("./Data/UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=' ')
activity_labels <- as.character(activity_labels[,2])

data_partial$activity<-activity_labels[data_partial$activity]

name_new<-names(data_partial)
name_new<-gsub("[(][)]", "", name_new)
name_new<-gsub("^t", "TimeDomain_", name_new)
name_new <- gsub("^f", "FrequencyDomain_", name_new)
name_new <- gsub("Acc", "Accelerometer", name_new)
name_new <- gsub("Gyro", "Gyroscope", name_new)
name_new <- gsub("Mag", "Magnitude", name_new)
name_new <- gsub("-mean-", "_Mean_", name_new)
name_new <- gsub("-std-", "_StandardDeviation_", name_new)
name_new <- gsub("-", "_", name_new)
names(data_partial) <- name_new

data_tidy<-aggregate(data_partial[, 3:81], by=list(activity=data_partial$activity, subject=data_partial$subject), FUN=mean)
write.table(x=data_tidy, file="./Data/data_tidy.txt", row.names=FALSE)



data_tidy

dim(features_file)
class(data_train_X)

head(data_partial)

head(activity_labels)




