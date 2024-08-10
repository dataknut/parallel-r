# use furrr to parallel download

path = "~/Dropbox/data/NZ_ElecAuth/tests/" # default
years = "2021" # default
months = seq(1,12,1)
gridDataURL = "https://www.emi.ea.govt.nz/Wholesale/Datasets/Generation/Generation_MD/"

if(!dir.exists(path)){
  dir.create(path)
}

files <- list()

for(y in years){
  for(month in months){
    if(nchar(month) == 1){
      # need to add 0 as prefix
      m <- paste0("0", month)
    } else {
      m <- month
    }
    if(lubridate::today() < as.Date(paste0(y, "-",m,"-", "01"))){
      break # clearly there won't be any data for future dates
    }
    l <- length(files)
    files[[l + 1]] <- paste0(y, m,"_Generation_MD.csv") # what we see on the EA EMI
  }
}

get_file <- function(f){
  rFile <- paste0(gridDataURL,f)
  dt <- data.table::fread(rFile)
  return(dt)
}

# test the function
library(data.table)
dt <- get_file(files[1])

# furrr it
library(future)
library(furrr)
future::plan(sequential, workers = length(files))
tic()
# sleeps for 2 seconds in sequence
results <- future_map(files,~get_file(.x)) # get datas
toc()

library(parallelly)
coresToUse <- parallelly::availableCores()[[1]] - 2 # be safe

future::plan(multisession, workers = coresToUse)
tic()
results <- future_map(files,~get_file(.x)) # get data
toc()

