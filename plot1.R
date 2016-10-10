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

## Get total emission sum, by year
totalEmissionsByYear <- tapply(NEI$Emissions, NEI$year, sum)

## Convert to data frame for easy plotting
totalEmissionsByYearDF <-
    data.frame(key = names(totalEmissionsByYear), value = totalEmissionsByYear)

## plot total emissions (Y axis) by year (X axis)
png('plot1.png')
plot(
    totalEmissionsByYearDF$key,
    totalEmissionsByYearDF$value,
    type = "l",
    xlab = "Year",
    ylab = "Total Emissions in tons",
    main = "PM2.5 Emissions in USA"
)
dev.off()