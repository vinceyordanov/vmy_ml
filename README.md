# Introduction

This repository contains the source code for the containerization and automated deployment of a Machine Learning model to Google's CloudRun service. Deployments and re-deployments are triggered automatically upon changes to soure code. The goal here is to have a system that requires minimal manual work when it comes to serving this model to the public. The project consists of four core components: 
- ```Source code```: R scripts to train, evaluate, save the ML model, and create API endpoints to accept new inputs for trained model.
- ```Docker```: Used for wrangling and packaging all R dependencies used by our model into a container image. 
- ```Terraform```: Used to automate the provisioning and management of necessary GCP infrastructure to deploy the model to GCP.
- ```CI/CD Pipeline```: A sequence of steps for auto deployment of our model, triggered upon a push to the main branch of this repository.

Collectively, these four parts define our Machine Learning pipeline. 

_________________________________________________________________________________________________________________________________________________________

## Prerequesites

In order to fully reproduce this repository and successfully deploy a ML pipeline, a few things will be needed:
  
  - A GCP Account with: 
    - Billing properly configured.
    - A new project under this GCP account.
    - The following cloud APIs enabled: CloudRun, Artifact Registry, Compute Engine, Cloud Storage. 
  - A GitHub reposiory where all of your code will live. 
  - An interpreter for R (i.e., RStudio, VSCode).



_________________________________________________________________________________________________________________________________________________________

# Project Structure

```
  ├── .github
  │   ├── workflows
  │       └── ci_cd.yml
  │
  ├── src
  │   ├── Dockerfile
  |   ├── backend.R
  │   └── iris_rf.rds
  │
  ├── terraform
  │   ├── main.tf
  │   ├── cloudrun.tf
  │   ├── terraform.tfvars
  │   └── variables.tf
  │
  └── README.md
  ```