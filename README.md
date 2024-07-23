# Kestra Configuration
This is all the kestra related configuration for the CVops Research project.

## Description
This repository contains all the configuration files for the Kestra project. The Kestra project is a research project that aims to automate the process of creating a CV using a CI/CD pipeline. 

## Prerequisites
- An Activated Azure Subscription
- Terraform
- Docker
- Docker-compose

## Project Structure
1. .flows: Contains all the flows that are used in the project :
    1. download_data: This flow is used to download the data from a specific url and save it in azure Blob Storage.
    2. train_model: This flow is used to train the model using the data that was downloaded in the previous flow.
    3. test_model: This flow is used to test the model using the data that was downloaded in the previous flow.

2. host.tf: This file contains the terraform configuration to create a VM in Azure.
3. docker-compose.yml: This file contains the configuration to run the Kestra server and the Kestra worker.
4. prometheus.yml: This file contains the configuration for the Prometheus server.

## Installation
1. Clone the repository
2. Start by linking terraform to your Azure account by running the following command:
    ```bash
    az login
    ```
3. Create an Azure VM with azure and apply the docker compose file in it:
    ```bash
    terraform init
    terraform apply
    ```
4. Consult Your Kestra server in the browser by going to the following url:
    ```bash
    http://<your_vm_ip>:8080
    ```
5. Test the flows by coping eac flow in your kestra instance

## Used tools
- [Kestra](https://kestra.io/)
- [Terraform](https://www.terraform.io/)
- [Prometheus](https://prometheus.io/)
- [Docker](https://www.docker.com/)
- [Azure](https://azure.microsoft.com/en-us/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)