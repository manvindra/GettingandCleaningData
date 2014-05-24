# 1. Merges the training and the test sets to create one data set.
getwd()
setwd("C:/Users/manu/Documents/coursera/")

Xtrain <- read.table("./data/train/X_train.txt")
Xtest <- read.table("./data/test/X_test.txt")
X <- rbind(Xtrain, Xtest)
rm(Xtrain,Xtest)

Strain <- read.table("./data/train/subject_train.txt")
Stest <- read.table("./data/test/subject_test.txt")
s <- rbind(Strain, Stest)
rm(Strain,Stest)

Ytrain <- read.table("./data/train/y_train.txt")
Ytest <- read.table("./data/test/y_test.txt")
Y <- rbind(Ytrain, Ytest)
rm(Ytrain,Ytest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("./data/features.txt")
Mean_std <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, Mean_std]
names(X) <- features[Mean_std, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))
# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("./data/activity_labels.txt")
activities[, 2] = gsub("_", "",as.character(activities[, 2]))
Y[,1] = activities[Y[,1], 2]


# 4. Appropriately labels the data set with descriptive activity names.

names(s) <- "SubjectID"
names(Y) <- "ActivityName"
merged <- cbind(s, Y, X)

write.table(merged, "./data/merged_tidy_data.txt")


# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
    require(reshape2)
    melted_data <- melt(merged, id=c("SubjectID","ActivityName"))
    
    # cast the data back to the tidy_data format
    tidy_data <- dcast(melted_data, formula = SubjectID + ActivityName ~ variable, mean)
    
    #format the column names
    col_names_vector <- colnames(tidy_data)
    col_names_vector <- gsub("-mean()","Mean",col_names_vector,fixed=TRUE)
    col_names_vector <- gsub("-std()","Std",col_names_vector,fixed=TRUE)
    col_names_vector <- gsub("BodyBody","Body",col_names_vector,fixed=TRUE)
    colnames(tidy_data) <- col_names_vector
    
    ## write the output into a file
        write.table(tidy_data, file="./data/tidy_Data_with_averages.txt",sep="\t", row.names=FALSE)
