# Install R-version 3.6.3 as image
FROM rocker/r-ver:3.6.3

# Install required ubuntu libraries for 'mlr'
RUN apt-get update -qq && apt-get install -y \
  libgdal-dev libgeos-dev libproj-dev r-cran-udunits2 libgsl-dev libgmp-dev libglu-dev  r-cran-rjags libmpfr-dev libopenmpi-dev

# Install required libraries
RUN R -e "install.packages('beakr')"
RUN R -e "install.packages('mlr')"
RUN R -e "install.packages('randomForest')"
RUN R -e "install.packages('caret')"

# Expose the used port from beakr
EXPOSE 8080

# Change to the directory containing R script 
# RUN ["/bin/sh" , "-c" , "cd ../src" ] 
# RUN [ "cp", "/src/backend.R", "/terraform" ]
# RUN [ "cp", "/src/iris_rf.rds", "/terraform" ]


# Add script
ADD . /app

# Set current working directory to the directory where the Model & App live.
WORKDIR /app

# Run the R script that contains the application
CMD ["Rscript", "./backend.R"]
