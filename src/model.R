# -- Load Dependencies -- # 

library(caret)
library(randomForest)
library(mlr)


# -- Load data -- # 

data(iris)
dataset = iris


# --- Split data into training / testing / validation sets --- #

validation_index = createDataPartition(dataset$Species, p=0.80, list=FALSE)
validation = dataset[-validation_index,]
dataset = dataset[validation_index,]


# --- Specify 10-fold cross-validation algorithm for model training --- #

control = trainControl(method="cv", number=10)
metric = "Accuracy"


# -- Train model -- # 

model.rf <- caret::train(Species~., data=dataset, method="rf", metric=metric, trControl=control)


# -- Get model performance -- # 

predictions = predict(model.rf, validation)
confusionMatrix(predictions, validation$Species)


saveRDS(model.rf, file = "iris_rf.rds")