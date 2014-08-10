# function to read data for each plot
# param character directory: the directory location of the file
# param character file: the file name
# result: a dataframe that fits the project specifications will be loaded in the global environment
read.project1.data <- function(directory = "", file = "household_power_consumption.txt") {
    # load the data
    full.path <- paste(directory, file, sep="")
    proj1 <<- read.table("household_power_consumption.txt", sep=";", header=T, na.strings="?")
    # convert the date column to Date type
    proj1$Date <<- as.Date(proj1$Date, "%d/%m/%Y")
    # subset for Feb 1-2, 2007
    proj1 <<- proj1[proj1$Date >= "2007-02-01" & proj1$Date <= "2007-02-02",]
    # concatenate Date and Time
    proj1$DateTime <<- strptime(paste(as.character(proj1$Date), as.character(proj1$Time)), 
                                format = "%Y-%m-%d %H:%M:%S")
    # convert other columns to numeric
    proj1[,3:9] <<- sapply(proj1[,3:9], as.numeric)
}

# this will load the proj1 dataset, appropriately formatted, into the global env
read.project1.data()

# construct a time series plot for the two days, 1 Feb 2007 to 2 Feb 2007
# response: global active power
windows()
par(mfrow=c(2, 2))
plot(proj1$DateTime, proj1$Global_active_power, type="l",
     xlab="", ylab="Global Active Power")

# construct a time series plot for the two days, 1 Feb 2007 to 2 Feb 2007
# response: voltage
plot(proj1$DateTime, proj1$Voltage, type="l",
     xlab="datetime", ylab="Voltage")

# construct multiple time series plots for the two days, 1 Feb 2007 to 2 Feb 2007
# dependent variables: Sub_metering_1, Sub_metering_2, Sub_metering_3
plot(proj1$DateTime, proj1$Sub_metering_1, type="l",
     xlab="", ylab="Energy sub metering")
lines(proj1$DateTime, proj1$Sub_metering_2, type="l", col="red")
lines(proj1$DateTime, proj1$Sub_metering_3, type="l", col="blue")
# add a legend to the plot
leg.lab <- paste0("Sub_metering_", 1:3)
legend("topright", lty=1, col=c("black", "red", "blue"), legend=leg.lab)

# construct a time series plot for the two days, 1 Feb 2007 to 2 Feb 2007
# response: global reactive power
plot(proj1$DateTime, proj1$Global_reactive_power, type="l",
     xlab="datetime", ylab="Global_reactive_power")

# copy to png
dev.copy(png, file = "plot4.png")
dev.off(); dev.off()
par(mfrow=c(1,1))
