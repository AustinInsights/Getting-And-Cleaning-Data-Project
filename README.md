Getting-And-Cleaning-Data-Project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 

Script:

run_analysis.R

At R prompt, load above script and run doall()

In working directory two files are produced - TidySet1.txt and TidySet2.txt.

TidySet2.txt represents the independent tidy data set with the 
             average of each variable for each activity and each subject
             each value is comma-separated.


FUNCTION: DOALL
 0. Load "plyr" library for averages
 1. Read Activity Labels and Features
 2. a. Read X Values of Training Data
    b. Create Header Row with Features Names as column names
 3. a. Read y Values of Training Data
    b. Create Header Row with "Activity" as column names
    c. Map Acivity Labels to Activity Values
 4. a. Read subject Values of Training Data
    b. Create Header Row with "SubjectID" as column names
 5. Merge y Values, subject values, and X values into 1 "Train" Data Frame
 6. a. Read X Values of Test Data
    b. Create Header Row with Features Names as column names
 7. a. Read y Values of Test Data
    b. Create Header Row with "Activity" as column names
    c. Map Acivity Labels to Activity Values
 8. a. Read subject Values of Test Data
    b. Create Header Row with "SubjectID" as column names
 9. Merge y Values, subject values, and X values into 1 "Test" Data Frame
10. Merge "Train" Data Frame and "Test" Data Frame to "MergedSet"
11. Extract Activity, SubjectID, and all Mean and Std columns from "MergedSet" to "TidySet1"
12. Remove Parantheses and from Mean and Std column names from "TidySet1"
13. Substitute Hyphen with Underscore from Mean and Std column names from "TidySet1" 
    so that R functions do not interpret hyphen as a minus sign
14. Write TidySet1.txt to disc which corresponds to step number 4 of the assignment
15. Create a new DataFrame TidySet2 from TidySet1 
    by computing average for each acitivity and each subject
16. Write TidySet2.txt to disc which corresponds to step number 5 of the assignment


FUNCTION: average_for_each_activity_and_each_subject
Uses plyr package and ddply function to compute mean (average) 
of all mean() and std() varaibles by activity by subject ID


FUNCTION: extract_mean_and_std

Extracts columns with mean() and std() in feature names


UTILITY FUNCTIONS  ###

FUNCTION: trim

Removes leading and trailing spaces in a given string x


FUNCTION: removeparantheses

Removes parantheses in a given string x


FUNCTION: substituteunderscore

Substritute hyphen with an underscore in a given string x
