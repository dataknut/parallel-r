# https://furrr.futureverse.org/

# Mapping (purrr) for futures
library(purrr)
map(c("hello", "world"), ~.x)


library(furrr)
future_map(c("hello", "world"), ~.x)

# make it parallel
plan(multisession, workers = 2)
future_map(c("hello", "world"), ~.x)

library(tictoc)
future::plan(sequential)

tic()
# sleeps for 2 seconds in sequence
nothingness <- future_map(c(2, 2, 2),
                          ~Sys.sleep(.x)) # sleep for 2 seconds
toc()

future::plan(multisession, workers = 3)
tic()
# sleeps for 2 seconds in parallel
nothingness <- future_map(c(2, 2, 2),
                          ~Sys.sleep(.x))
toc()
