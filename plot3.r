#########Download data
if(!file.exists("project1")) {
    dir.create("project1")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "household_power_consumption.txt", method = "curl")
dateDownloaded <- date()

#########Read data for 2017-02-01 and 2017-02-02
hpcdata <- read.table("./project1/household_power_consumption.txt", skip = 66637, nrows = 2880, sep = ";")

#head(hpcdata)
#        V1       V2    V3    V4     V5  V6 V7 V8 V9
#1 1/2/2007 00:00:00 0.326 0.128 243.15 1.4  0  0  0
#2 1/2/2007 00:01:00 0.326 0.130 243.32 1.4  0  0  0
#3 1/2/2007 00:02:00 0.324 0.132 243.51 1.4  0  0  0
#4 1/2/2007 00:03:00 0.324 0.134 243.90 1.4  0  0  0
#5 1/2/2007 00:04:00 0.322 0.130 243.16 1.4  0  0  0
#6 1/2/2007 00:05:00 0.320 0.126 242.29 1.4  0  0  0

#tail(hpcdata)
#           V1       V2    V3    V4     V5   V6 V7 V8 V9
#2875 2/2/2007 23:54:00 3.696 0.226 240.71 15.2  0  1 17
#2876 2/2/2007 23:55:00 3.696 0.226 240.90 15.2  0  1 18
#2877 2/2/2007 23:56:00 3.698 0.226 241.02 15.2  0  2 18
#2878 2/2/2007 23:57:00 3.684 0.224 240.48 15.2  0  1 18
#2879 2/2/2007 23:58:00 3.658 0.220 239.61 15.2  0  1 17
#2880 2/2/2007 23:59:00 3.680 0.224 240.37 15.2  0  2 18

names(hpcdata) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

########### update dataset

library(dplyr)
library(lubridate)

DateTime <- paste(hpcdata$Date, hpcdata$Time)
hpc <- cbind(hpcdata, DateTime)
hpc_time <- mutate(hpc, Date = dmy(Date), Time = hms(Time), DateTime = dmy_hms(DateTime), weekday = weekdays(Date))

########### plot 3
with(hpc_time, plot(DateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black"))
lines(Sub_metering_2 ~ DateTime, data=hpc_time, type = "l", col = "red")
lines(Sub_metering_3 ~ DateTime, data=hpc_time, type = "l", col = "blue")
legend("topright", lty=1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, file = "plot3.png", width=480, height=480)
dev.off()