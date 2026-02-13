# Deploy simple Python web app via Docker and Terraform on Azure.

## Plan

1. Create a very simple Python app
2. Write Dockerfile for packaging it
3. Local testing with with Docker Compose
4. Terraform
5. Build image and push to ACR
6. Deploy container

## Bonus ideas:

- GitHub actions? ✅
- Releases? with tags ✅
- CI/CD pipelines? simple GitHub Actions workflow ✅

## Time budget

Estimate was 10 h but completed in ~8 h

## Biggest learnings

### Terraform Shared Remote State

- This should be the default way of working
- You could let GitHub Actions use the remote state but you could also locally modify the infrastructure at the same time

#### Add empty backend

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }

  backend "azurerm" {}
}
```

- Make sure backend is empty, since we pass the backend configs

#### Create Backends

```hcl
# prod.tfbackend
resource_group_name  = "rg-terraform"
storage_account_name = "mytfstateacc"
container_name       = "tfstate"
key                  = "prod.tfstate"
```

- Create `prod.tfbackend` and `dev.tfbackend` for example

#### Create Resource Group

```bash
az group create --name rg-terraform --location switzerlandnorth
```

- Resource group for the storage account that will store the remote state

#### Create Storage Account and Container

```bash
az storage account create \
  --name mytfstateacc \
  --resource-group rg-terraform \
  --location switzerlandnorth \
  --sku Standard_LRS

az storage container create \
  --name tfstate \
  --account-name mytfstateacc
```

#### Initialize Terraform with a Backend

```bash
terraform init -backend-config="prod.tfbackend"
```

### Working with Tags

- Very useful for simple CI/CD pipeline using GitHub actions
- Tags are a simple way of tracking software version (releases)

#### Create Tag

```bash
git tag v1.0.2
```

- You can tag a specific commit on any branch

#### Push Tag

```bash
git push origin v1.0.2
```

- This pushes the code marked by your tag to GitHub

#### Delete Tag

```bash
git tag -d v1.0.2

git push -d origin v1.0.2
```

### Local Development Bind Mounts

```bash
docker run -it --rm --name mercury-api -p 8000:8000 -v $(pwd):/app mercury-app
```

- `-v $(pwd):/app` mounts the current working directory in the container's app directory
- This allows us to comment out the `COPY . .` in the Dockerfile during development
- Command already pretty verbose, Docker Compose cleaner
