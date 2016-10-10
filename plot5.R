url <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
currWd <- getwd()
tempFile <- paste0(currWd, '/NEI_data.zip')
download.file(url, destfile = tempFile, method = "curl")
unzip(tempFile)
file.remove(tempFile)

## Read the data frames
NEI <- readRDS("summarySCC_PM25.rds")
SCC <-
    readRDS("Source_Classification_Code.rds")

library(ggplot2)

## grep for data for motor vehicle
index1 <- with(SCC, grepl("motor", Short.Name, ignore.case = TRUE))
index2 <-
    with(SCC, grepl("vehicle", Short.Name, ignore.case = TRUE))

## get valid SCCs
motorVehicle <- SCC[index1 & index2, ]

## filter NEI set on these SCCs
motorVehicleData <-
    filter(NEI, SCC %in% motorVehicle$SCC)

## subset on Baltimore data
motorVehicleDataSub <- filter(motorVehicleData, fips == '24510')

png('plot5.png')
print(
    qplot(
        year,
        Emissions,
        data = motorVehicleDataSub,
        xlab = "Year",
        ylab = "Emissions in tons",
        main = "PM2.5 Emissions in Baltimore (for motor vehicle emission sources)"
    ) + geom_smooth(method = "lm")
)
dev.off()