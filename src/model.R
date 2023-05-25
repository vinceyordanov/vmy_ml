# This script should only be executed locally and if you have not yet trained your model. 
# In general it should not exist in the repository, it is only here for demonstration purposes. 
# IF you wanted to re-train the model with every deployment, you would leave it here and uncomment
# the source("model.R") line in the backend.R script. 

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

model.rf = caret::train(Species~., data=dataset, method="rf", metric=metric, trControl=control)


# -- Get model performance -- # 

# predictions = predict(model.rf, validation)
# confusionMatrix(predictions, validation$Species)


saveRDS(model.rf, file = "iris_rf.rds")