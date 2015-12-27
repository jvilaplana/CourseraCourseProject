library(reshape2)

# Load general datasets
features <- read.table("./UCI HAR Dataset/features.txt")
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
# Load test datasets
testData.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testData.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
testData.y <- read.table("./UCI HAR Dataset/test/y_test.txt")
# Load train datasets
trainData.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainData.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainData.y <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Merge both datasets - subject
subject <- rbind(testData.subject, trainData.subject)
colnames(subject) <- "subject"

# Merge both labels
label <- rbind(testData.y, trainData.y)
label <- merge(label, activity.labels, by=1)[,2]

# Merge both datasets - x
mergedData <- rbind(testData.x, trainData.x)
colnames(mergedData) <- features[, 2]

# Final merging of the datasets including the labels
mergedData <- cbind(subject, label, mergedData)

# Filter the dataset to keep the mean and standard deviation fields only
search <- grep("-mean|-std", colnames(mergedData))
mergedData.mean.std <- mergedData[,c(1,2,search)]

# Get the mean values
meanVals <- melt(mergedData.mean.std, id.var = c("subject", "label"))
result <- dcast(meanVals , subject + label ~ variable, mean)

# Save it to a file called tidyData.txt
write.table(result, file = "./tidyData.txt", row.names = FALSE)

# Print the result
result
