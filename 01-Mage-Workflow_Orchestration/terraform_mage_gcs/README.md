## Deploying Mage to Google Cloud using Terraform

### Prerequisites
- Terraform
- Google Cloud SDK (`gcloud` CLI)
- Google Cloud permissions
- Mage Terraform templates

### Terraform Setup

1. **Service Account Setup**:
   - Make sure you have a service account created for Google Cloud.
   - Generate JSON credentials for the service account.

2. **Directory Setup**:
   - Create a directory named `terraform` for your Terraform files.
   - Inside the `terraform` directory:
     - Create a subdirectory named `keys`.
     - Navigate into the `keys` directory.
     - Create a JSON file, e.g., `my-creds.json`, to store your Google Cloud credentials.
     - Open `my-creds.json` and paste the contents of your JSON credentials.
     - Save and close the file.

3. **Terraform Configuration**:
   - Return to the `terraform` directory.
   - Optionally, open the directory in your preferred code editor.
   - Create a new Terraform configuration file named `main.tf` to define your infrastructure.


## Terraform Configuration

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.23.0"
    }
  }
}

provider "google" {
  # credentials = "./keys/my-creds.json"
  project = "majestic-legend-419120"
  region  = "us-central1"
}

```
## Using Credentials in Git Bash

I prefer not to store my credentials directly in my code, i can utilize environment variables or Git Bash configurations. Here's how to do it:


