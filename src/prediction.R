model = readRDS("iris_rf.rds")

get_prediction = function(arg_1, arg_2, arg_3, arg_4) {
  
  df = data.frame(
    'Sepal.Length' = as.numeric(arg_1),
    'Sepal.Width' = as.numeric(arg_2),
    'Petal.Length' = as.numeric(arg_3),
    'Petal.Width' = as.numeric(arg_4)
  )
  
  # calculate prediction for the observed startup
  pred = predict(model, newdata = df)
  
  # return the prediction
  return((paste0("The predicted class of this plant is: ", pred)))
  
}

