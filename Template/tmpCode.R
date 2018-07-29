# Check if the data are available or the run_all flag exists.
# If not, prepare the tidy data
if ( !exists("activity") || exists("run_all") ) {
        destfile <- "./activity.zip" 
        # Check if the raw data file are there, otherwise download from te source
        if (!file.exists(destfile) || exists("run_all")) {
                fileURL  <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"   
                download.file(fileURL ,destfile,method="auto") 
                rm("fileURL")
        }
        # Create a dataset with raw data
        activity <- read.table(unz(destfile, "activity.csv"), sep = ",", header = TRUE, na.strings = "NA")
        rm("destfile")
}

# Prepare the analysis dataset
activity <- as.data.frame(activity)
activity$date <- as.POSIXct(activity$date, tz="GMT", "%Y-%m-%d")

## What is mean total number of steps taken per day?
## For this part of the assignment, you can ignore the missing values in the dataset.

# 1. Calculate the total number of steps taken per day
total_steps_day <- aggregate(activity$steps,activity[2], sum)
#total_steps_day$date <- as.factor(total_steps_day$date)

# 2. Plot a histogram of steps per day
hist(total_steps_day$x,main = "Histogram of Steps Per Day", labels = TRUE,xlab = "Steps")

# 3. Calculate and report the mean and median of the total number of steps taken per day
mean(total_steps_day$x,na.rm = TRUE)
median(total_steps_day$x,na.rm = TRUE)

## What is the average daily activity pattern?
# 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
mean_steps_day <- aggregate(activity$steps,by=list(activity$interval), FUN=mean, na.rm=TRUE)
plot(mean_steps_day, type="l", main="Mean Steps per Interval", xlab = "Interval", ylab="Mean Steps")

# 2.Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
mean_steps_day[which.max(mean_steps_day$x),1]

## Imputing missing values
# Note that there are a number of days/intervals where there are missing values (coded as NA). 
# The presence of missing days may introduce bias into some calculations or summaries of the data.

# 1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
table(is.na(activity))[2]

# 2. Devise a strategy for filling in all of the missing values in the dataset. 
# The strategy does not need to be sophisticated. 
# For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
names(mean_steps_day) <- c("interval","steps")
activity_no_na <- merge(activity, mean_steps_day, by="interval")
# 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
activity_no_na$steps.x <- ifelse(is.na(activity_no_na$steps.x),activity_no_na$steps.y, activity_no_na$steps.x)
activity_no_na <- activity_no_na[c("steps.x","date","interval")]
names(activity_no_na) <- c("steps","date","interval")
# 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 
# Do these values differ from the estimates from the first part of the assignment? 
# What is the impact of imputing missing data on the estimates of the total daily number of steps?
total_steps_day_no_na <- aggregate(activity_no_na$steps,activity_no_na[2], sum)
hist(total_steps_day_no_na$x, main = "Histogram of Steps Per Day\nNA changed to means", labels = TRUE,xlab = "Steps")

## Are there differences in activity patterns between weekdays and weekends?
## For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

# 1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.
# weekdays() return values according to operating system locale, using a numeric approach instead
activity$wday <- ifelse(as.POSIXlt(activity$date)$wday %in% c(1,5), 'weekday', 'weekend')
activity$wday <- as.factor(activity$wday)
mean_steps_wday <- aggregate(activity$steps,by=list(activity$interval,activity$wday), FUN=mean, na.rm=TRUE)

# 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.
xyplot(mean_steps_wday$x~Group.1|Group.2, type="l", data=mean_steps_wday, layout=c(1,2), ylab = "Mean Steps", xlab = "5-minute Interval")
