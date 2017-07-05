
## The main data directory
ds_dir <- 'C:/Users/james/Downloads/R_data/epa_data'
dest_file <- "Dataset.zip"
full_path <- paste(ds_dir,dest_file,sep="/")

## Download and extract a zip file with datasets
if (!file.exists(full_path)) {
  source_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(source_url, destfile = full_path)
  unzip(full_path, exdir=ds_dir )
  if (!file.exists(full_path)) 
    stop("The downloaded dataset doesn't have the expected structure!")
}

#clean up files
file.remove(full_path)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS(paste(ds_dir,"summarySCC_PM25.rds",sep='/'))
SCC <- readRDS(paste(ds_dir,"Source_Classification_Code.rds",sep='/'))

library(ggplot2)

################
###### Q3 ######
################

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999 2008 for Baltimore City? 
# Which have seen increases in emissions from 1999 2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

# 24510 is Baltimore
subsetNEI  <- NEI[NEI$fips=="24510", ]

aggregatedTotalByYearAndType <- aggregate(Emissions ~ year + type, subsetNEI, sum)

png("plot3.png", width=640, height=480)
g <- ggplot(aggregatedTotalByYearAndType, aes(year, Emissions, color = type))
g <- g + geom_line() +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions in Baltimore City, Maryland (fips == "24510") from 1999 to 2008')
print(g)
dev.off()