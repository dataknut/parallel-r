# https://cran.r-project.org/web/packages/future/vignettes/future-1-overview.html


v <- { # use future assignment
  cat("Hello world!\n") # gets printed out now
  3.14
}

v # prints 3.14

library(future)
v %<-% { # use future assignment
  cat("Hello world!\n") # doesn't get printed yet
  3.14
  }

library(tictoc)
tic()
v # prints everything but sequentially (by default)
toc()

# now try a parallel session
future::plan(multisession)
v %<-% { # use future assignment
  cat("Hello world!\n") # doesn't get printed yet
  3.14
}

tic()
v
toc()

# tests
plan(sequential)
tic()
demo("mandelbrot", package = "future", ask = FALSE)
toc()

tic()
plan(multisession)
demo("mandelbrot", package = "future", ask = FALSE)
toc()

# can we set set up a multicore? Not supported on windows
plan(multicore)
# not within RStudio apparently

# can set set up a cluster?
tic()
cl <- parallel::makeCluster(2, timeout = 60)
plan(cluster, workers = cl)
# yep - on localhost
demo("mandelbrot", package = "future", ask = FALSE)
toc()


