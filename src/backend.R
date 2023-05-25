# source("prediction.R")
library(beakr)
library(caret)
library(mlr)



# -- Load the locally trained model -- # 

model = readRDS("iris_rf.rds")



# --- This function receives the 4 input values for the model that were sent in through the GET request 
# --- And then formats them into a dataform which can be passed into the model for prediction 

get_prediction = function(arg_1, arg_2, arg_3, arg_4) {
  
  df = data.frame(
    'Sepal.Length' = as.numeric(arg_1),
    'Sepal.Width' = as.numeric(arg_2),
    'Petal.Length' = as.numeric(arg_3),
    'Petal.Width' = as.numeric(arg_4)
  )
  
  pred = predict(model, newdata = df)
  return((paste0("The predicted class of this plant is: ", pred)))
  
}


# -- Create API endpoint to feed new data to model -- #  

newBeakr() %>% 
  httpGET(path = "/predict", decorate(get_prediction)) %>%    # Respond to GET requests at the "/predict" route
  handleErrors() %>%                                          # Handle any errors with a JSON response
  listen(host = "0.0.0.0", port = 8001)                       # Start the server on port 8001

