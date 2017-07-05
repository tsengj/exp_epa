
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

################
###### Q1 ######
################

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources 
# for each of the years 1999, 2002, 2005, and 2008.

aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI, sum)

png('plot1.png')
barplot(height=aggregatedTotalByYear$Emissions, names.arg=aggregatedTotalByYear$year, xlab="years", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions at various years'))
dev.off()