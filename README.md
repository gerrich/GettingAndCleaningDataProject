# Course project for Getting and Cleaning data

### Download data:
At first - check if the data available. Otherwise download the zip file and unpack it.

### Load mapping data
There are files with feature-variable mapping and activity mapping availavle. Load them.
Calculate ids of desired feature variables using grep function.

### Load train/test data
Use read.csv function to load measurement data. Use feature variable mapping to set appropriate column names.
Read activity ids list from y_(test|train).txt files.
Read subject ids lists from subject_(test|train).txt files.
Merge test/train parts togather.
 
### Prepare data
Combine subject_is, activity_is and subset of desired features from measurement data togather.
Replace activity ids with theis actual names using series of merge, subsep operations.

### Avereges
Use ddply function from plyr package to calculate avereges inside groups. Data.frame is grouped by columns c("subject","activity")

### Save final result 
Use write.table to save data
 
