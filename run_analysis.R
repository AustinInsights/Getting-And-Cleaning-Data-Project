# AUTHOR: Austin Insights
# https://class.coursera.org/getdata-006/human_grading/view/courses/972584/assessments/3/submissions
#
# FUNCTION: DOALL
#  0. Load "plyr" library for averages
#  1. Read Activity Labels and Features
#  2. a. Read X Values of Training Data
#     b. Create Header Row with Features Names as column names
#  3. a. Read y Values of Training Data
#     b. Create Header Row with "Activity" as column names
#     c. Map Acivity Labels to Activity Values
#  4. a. Read subject Values of Training Data
#     b. Create Header Row with "SubjectID" as column names
#  5. Merge y Values, subject values, and X values into 1 "Train" Data Frame
#  6. a. Read X Values of Test Data
#     b. Create Header Row with Features Names as column names
#  7. a. Read y Values of Test Data
#     b. Create Header Row with "Activity" as column names
#     c. Map Acivity Labels to Activity Values
#  8. a. Read subject Values of Test Data
#     b. Create Header Row with "SubjectID" as column names
#  9. Merge y Values, subject values, and X values into 1 "Test" Data Frame
# 10. Merge "Train" Data Frame and "Test" Data Frame to "MergedSet"
# 11. Extract Activity, SubjectID, and all Mean and Std columns from "MergedSet" to "TidySet1"
# 12. Remove Parantheses and from Mean and Std column names from "TidySet1"
# 13. Substitute Hyphen with Underscore from Mean and Std column names from "TidySet1" 
#     so that R functions do not interpret hyphen as a minus sign
# 14. Write TidySet1.csv to disc which corresponds to step number 4 of the assignment
# 15. Create a new DataFrame TidySet2 from TidySet1 
#     by computing average for each acitivity and each subject
# 16. Write TidySet2.csv to disc which corresponds to step number 5 of the assignment
#
doall <- function() {
    #  0. Load "plyr" library for averages
    library(plyr)

	#  1. Read Activity Labels and Features

	# Read activity_labels
	activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",sep = " ", header = FALSE)
	
    # Read features
	features <- read.table("./UCI HAR Dataset/features.txt",sep = " ",header = FALSE)
	features$V1 <- NULL

	#  2. a. Read X Values of Training Data
	X_trainlines <- readLines("./UCI HAR Dataset/train/X_train.txt")
	X_trainlines <- trim(X_trainlines)
	X_train <- do.call(rbind.data.frame, strsplit(X_trainlines, " "))

	#  2. b. Create Header Row with Features Names as column names
	for (i in 1:nrow(features)) {
		colnames(X_train)[i] = toString(features$V2[i])
	}
	
	#  3. a. Read y Values of Training Data
    y_trainlines <- readLines("./UCI HAR Dataset/train/y_train.txt")
	y_trainlines <- trim(y_trainlines)
	y_train <- do.call(rbind.data.frame, strsplit(y_trainlines, ""))

	#  3. b. Create Header Row with "Activity" as column names
	colnames(y_train) = "Activity"

	#  3. c. Map Acivity Labels to Activity Values
	y_train$Activity <- activity_labels[match(y_train$Activity, activity_labels$V1),2]
	
	#  4. a. Read subject Values of Training Data
    subject_trainlines <- readLines("./UCI HAR Dataset/train/subject_train.txt")
	subject_trainlines <- trim(subject_trainlines)
	subject_train <- do.call(rbind.data.frame, strsplit(subject_trainlines, ""))

	#  4. b. Create Header Row with "SubjectID" as column names
	colnames(subject_train) = "SubjectID"
	
	#  5. Merge y Values, subject values, and X values into 1 "train" Data Frame
	# merge training data
	train <- cbind(y_train, subject_train, X_train)

	#  6. a. Read X Values of Test Data
	# Read test data
	X_testlines <- readLines("./UCI HAR Dataset/test/X_test.txt")
	X_testlines <- trim(X_testlines)
	X_test <- do.call(rbind.data.frame, strsplit(X_testlines, " "))

	#  6. b. Create Header Row with Features Names as column names
	for (i in 1:nrow(features)) {
		colnames(X_test)[i] = toString(features$V2[i])
	}

	#  7. a. Read y Values of Test Data
    y_testlines <- readLines("./UCI HAR Dataset/test/y_test.txt")
	y_testlines <- trim(y_testlines)
	y_test <- do.call(rbind.data.frame, strsplit(y_testlines, ""))

	#  7. b. Create Header Row with "Activity" as column names
	colnames(y_test) = "Activity"

	#  7. c. Map Acivity Labels to Activity Values
	y_test$Activity <- activity_labels[match(y_test$Activity, activity_labels$V1),2]
	
	#  8. a. Read subject Values of Test Data
    subject_testlines <- readLines("./UCI HAR Dataset/test/subject_test.txt")
	subject_testlines <- trim(subject_testlines)
	subject_test <- do.call(rbind.data.frame, strsplit(subject_testlines, ""))

	#  8. b. Create Header Row with "SubjectID" as column names
	colnames(subject_test) = "SubjectID"

	#  9. Merge y Values, subject values, and X values into 1 "test" Data Frame

	# merge test data
	test <- cbind(y_test, subject_test, X_test)
	
	# 10. Merge "train" Data Frame and "test" Data Frame to "merged_Set"
	merged_Set <- rbind(train, test)

	# 11. Extract Activity, SubjectID, and all Mean and Std columns from "merged_Set" to "TidySet1"
	Tidy_Data_Set1 <- extract_mean_and_std(merged_Set)
	
	# 12. Remove Parantheses and from Mean and Std column names from "TidySet1"
	# 13. Substitute Hyphen with Underscore from Mean and Std column names from "TidySet1" 
	#     so that R functions do not interpret hyphen as a minus sign
	for (i in 3:ncol(Tidy_Data_Set1)) {
		colnames(Tidy_Data_Set1)[i] = removeparantheses(colnames(Tidy_Data_Set1)[i])
		colnames(Tidy_Data_Set1)[i] = substituteunderscore(colnames(Tidy_Data_Set1)[i])
	}
	# 14. Write TidySet1.txt to disc which corresponds to step number 4 of the assignment
	write.table(Tidy_Data_Set1, file = "TidyDataSet1.txt", row.names = FALSE, sep=",")
	
	# 15. Create a new DataFrame TidySet2 from TidySet1 
	#     by computing average for each acitivity and each subject
	Tidy_Data_Set2 <- average_for_each_activity_and_each_subject(Tidy_Data_Set1)

	# 16. Write TidySet2.txt to disc which corresponds to step number 5 of the assignment
	write.table(Tidy_Data_Set2, file = "TidyDataSet2.txt", row.names = FALSE, sep=",")
}

# FUNCTION: average_for_each_activity_and_each_subject
# Uses plyr package and ddply function to compute mean (average) 
# of all mean() and std() varaibles by activity by subject ID
#
average_for_each_activity_and_each_subject <- function(Tidy_Data_Set1) {
	df <- data.frame()
	df <- ddply(Tidy_Data_Set1, c("Activity", "SubjectID"), function(df)mean(as.numeric(as.character(df[[3]]))))
	colnames(df)[3] = paste("Avg_",names(Tidy_Data_Set1)[3],sep="")
	for (i in 4:ncol(Tidy_Data_Set1)) {
		df2 <- ddply(Tidy_Data_Set1, c("Activity", "SubjectID"), function(df)mean(as.numeric(as.character(df[[i]]))))
		colnames(df2)[3] = paste("Avg_",names(Tidy_Data_Set1)[i],sep="")
		df <- merge(df,df2,by.y=c("Activity","SubjectID"))
	}
	df
}

# FUNCTION: extract_mean_and_std
# Extracts columns with mean() and std() in feature names
#
extract_mean_and_std <- function(merged_Set) {
	Tidy_Data_Set1 <- subset(merged_Set, select=c("Activity", "SubjectID",
	                            "tBodyAcc-mean()-X",
								"tBodyAcc-mean()-Y",
								"tBodyAcc-mean()-Z",
								"tBodyAcc-std()-X",
								"tBodyAcc-std()-Y",
								"tBodyAcc-std()-Z",
								"tGravityAcc-mean()-X",
								"tGravityAcc-mean()-Y",
								"tGravityAcc-mean()-Z",
								"tGravityAcc-std()-X",
								"tGravityAcc-std()-Y",
								"tGravityAcc-std()-Z",
								"tBodyAccJerk-mean()-X",
								"tBodyAccJerk-mean()-Y",
								"tBodyAccJerk-mean()-Z",
								"tBodyAccJerk-std()-X",
								"tBodyAccJerk-std()-Y",
								"tBodyAccJerk-std()-Z",
								"tBodyGyro-mean()-X",
								"tBodyGyro-mean()-Y",
								"tBodyGyro-mean()-Z",
								"tBodyGyro-std()-X",
								"tBodyGyro-std()-Y",
								"tBodyGyro-std()-Z",
								"tBodyGyroJerk-mean()-X",
								"tBodyGyroJerk-mean()-Y",
								"tBodyGyroJerk-mean()-Z",
								"tBodyGyroJerk-std()-X",
								"tBodyGyroJerk-std()-Y",
								"tBodyGyroJerk-std()-Z",
								"tBodyAccMag-mean()",
								"tBodyAccMag-std()",
								"tGravityAccMag-mean()",
								"tGravityAccMag-std()",
								"tBodyAccJerkMag-mean()",
								"tBodyAccJerkMag-std()",
								"tBodyGyroMag-mean()",
								"tBodyGyroMag-std()",
								"tBodyGyroJerkMag-mean()",
								"tBodyGyroJerkMag-std()",
								"fBodyAcc-mean()-X",
								"fBodyAcc-mean()-Y",
								"fBodyAcc-mean()-Z",
								"fBodyAcc-std()-X",
								"fBodyAcc-std()-Y",
								"fBodyAcc-std()-Z",
								"fBodyAccJerk-mean()-X",
								"fBodyAccJerk-mean()-Y",
								"fBodyAccJerk-mean()-Z",
								"fBodyAccJerk-std()-X",
								"fBodyAccJerk-std()-Y",
								"fBodyAccJerk-std()-Z",
								"fBodyGyro-mean()-X",
								"fBodyGyro-mean()-Y",
								"fBodyGyro-mean()-Z",
								"fBodyGyro-std()-X",
								"fBodyGyro-std()-Y",
								"fBodyGyro-std()-Z",
								"fBodyAccMag-mean()",
								"fBodyAccMag-std()",
								"fBodyBodyAccJerkMag-mean()",
								"fBodyBodyAccJerkMag-std()",
								"fBodyBodyGyroMag-mean()",
								"fBodyBodyGyroMag-std()",
								"fBodyBodyGyroJerkMag-mean()",
								"fBodyBodyGyroJerkMag-std()"))
}

###  UTILITY FUNCTIONS  ###

# FUNCTION: trim
# Removes leading and trailing spaces in a given string x
#
trim <- function(x) return(gsub("^ *|(?<= ) | *$", "", x, perl=T))

# FUNCTION: removeparantheses
# Removes parantheses in a given string x
#
removeparantheses <- function(x) return(gsub("\\(\\)", "",x))

# FUNCTION: substituteunderscore
# Substritute hyphen with an underscore in a given string x
#
substituteunderscore <- function(x) return(gsub("-", "_", x))

