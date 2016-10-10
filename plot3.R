url <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
currWd <- getwd()
tempFile <-
    paste0(currWd, '/NEI_data.zip')
download.file(url, destfile = tempFile, method = "curl")
unzip(tempFile)
file.remove(tempFile)

## Read the data frames
NEI <- readRDS("summarySCC_PM25.rds")
SCC <-
    readRDS("Source_Classification_Code.rds")

## Get data for Baltimore
baltimore <- filter(NEI, fips == '24510')

library(ggplot2)
png('plot3.png')
print(
    qplot(
        year,
        Emissions,
        data = baltimore,
        facets = . ~ type,
        xlab = "Year",
        ylab = "Emissions in tons",
        main = "PM2.5 Emissions in Baltimore City (grouped by type)"
    ) + geom_smooth(method = "lm")
)
dev.off()