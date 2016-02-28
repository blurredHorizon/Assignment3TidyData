# Assignment 3: Cleaning Movement Data

This assignment is based on data available from:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The assignment parameters were not as clear to me as I would've liked but
I performed clean up based on what I believed it was asking.

A detailed breakdown of what was done to process the data is available, as code,
in the script: Assignment3_Script.R.  This README is only an overview of the
procedures used in that file.  Since this is made to be more understandable than
the code it may not follow the same order as the code, but it is still consistent with the code.

The original data was located in 6 different files: 3 for the test data 
and 3 for the training data.  There was also 2 additional files: (1) a
file for the features and (2) a file that indicated the meaning behind
the activities being recorded.  

The 3 files for both test and train lined up correctly for each row so each were
added as columns to their respective dataset.  Then the features were added as
variable names to their appropriate columns.  The codes for the activities 
were then replaced by the description for the activities.

At this point, both the test and train data sets mirror each other in terms of structure
so the train data set was appended to the test data set to combine them into
a single dataset. 

Then for each person and feature the mean and standard deviation was 
calculated for each activity.  There were 6 activities: laying, sitting,
standing, walking, walking upstairs and walking downstairs.  In total this 
dataset has 14 columns each of which is described in CODEBOOK.txt.  
(CODEBOOK.txt is a modified version of the README.txt included with the
original data.)

The directory "working" and file "ActivityMeans.txt" is the output of the 
R script.  The "ActivityMeans.txt" in this repository is the unmodified
output of the R script.

 
