
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
###### Q4 ######
################

# merge the two data sets 
if(!exists("NEISCC")){
  NEISCC <- merge(NEI, SCC, by="SCC")
}

library(ggplot2)

################
###### Q5 ######
################

# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

# 24510 is Baltimore, see plot2.R
# ON-ROAD type in NEI being the most relevant

subsetNEI <- NEI[NEI$fips=="24510" & NEI$type=="ON-ROAD",  ]

aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEI, sum)

png("plot5.png", width=840, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from motor vehicle (type = ON-ROAD) in Baltimore City, Maryland (fips = "24510") from 1999 to 2008')
print(g)
dev.off()