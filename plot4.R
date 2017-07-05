
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

# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
# search string Coal in short.name
coalMatches  <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
subsetNEISCC <- NEISCC[coalMatches, ]

aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEISCC, sum)

png("plot4.png", width=640, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from coal sources from 1999 to 2008')
print(g)
dev.off()