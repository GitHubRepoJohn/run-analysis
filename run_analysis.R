# run_analysis.R script

library(dplyr)

# 0. read in inter-related data sets - data downloaded 21/12/2014
xtrain <- tbl_df(read.table("X_train.txt", stringsAsFactors = FALSE))             # [7,352 x 561]
xtest <- tbl_df(read.table("X_test.txt", stringsAsFactors = FALSE))               # [2,947 x 561]
subjecttrain <- tbl_df(read.table("subject_train.txt", stringsAsFactors = FALSE)) # [7,352 x 1]
subjecttest <- tbl_df(read.table("subject_test.txt", stringsAsFactors = FALSE))   # [2,947 x 1]
ytrain <- tbl_df(read.table("Y_train.txt", stringsAsFactors = FALSE))             # [7,352 x 1]
ytest <- tbl_df(read.table("Y_test.txt", stringsAsFactors = FALSE))               # [2,947 x 1]
features <- tbl_df(read.table("features.txt", stringsAsFactors = FALSE))

# 1. Merge the training and the test sets to create one data set
mergex <- tbl_df(rbind (xtrain, xtest))                                            # [10,299 x 561]

# Add column headings to the merged data
col.names <- (t(features)[2,])
names(mergex) <- col.names                                        				  # [10,299 x 561]

# 2. Extract only the measurements on the mean and standard deviation for each measurement
data <- tbl_df(mergex[,grepl("std|mean",colnames(mergex))])                       # [10,299 x 79]

# get rid of temporary table mergex
rm(mergex)

# 3. Use descriptive activity names to name the activities in the data set
activity <- tbl_df(rbind(tbl_df(rbind (ytrain, ytest))))
# Give the column a name
colnames(activity)[1] <- "Activity"
activity$Activity <- gsub ("1", "WALKING",activity$Activity)
activity$Activity <- gsub ("2", "WALKING_UPSTAIRS", activity$Activity)
activity$Activity <- gsub ("3", "WALKING_DOWNSTAIRS", activity$Activity)
activity$Activity <- gsub ("4", "SITTING", activity$Activity)
activity$Activity <- gsub ("5", "STANDING", activity$Activity)
activity$Activity <- gsub (6, "LAYING", activity$Activity)
                   
#4. Appropriately label the data set with descriptive variable names.
names(data) <- gsub("-mean", "Mean",names(data))
names(data) <- gsub("-std", "Std",names(data))
names(data) <- gsub("fBody", "frequencyBody",names(data))
names(data) <- gsub("tBody", "timeBody",names(data))
names(data) <- gsub("BodyBody", "Body",names(data))
names(data) <- gsub("\\()","",names(data))
names(data) <- gsub("-", "",names(data))
                   
#5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
data <- mutate(data, average = rowMeans(data))
                   
subject <- tbl_df(rbind (subjecttrain, subjecttest)) 
# Give the column a name
colnames(subject)[1] <- "Subject"
                   
# Merge all data
data <- tbl_df(cbind(cbind(subject,activity),data))                          #[10,299 x 81]
        
# Write out the data
write.table(data,"tidydata")


