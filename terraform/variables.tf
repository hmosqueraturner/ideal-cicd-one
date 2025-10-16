variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "acid-cicd-one"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-acid-cicd"
}

variable "container_image" {
  description = "Docker container image"
  type        = string
  default     = "acidregistry.azurecr.io/ideal-cicd-one:latest"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "container_cpu" {
  description = "CPU cores for container"
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "Memory in GB for container"
  type        = number
  default     = 1
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "ACiD Suite"
    ManagedBy   = "Terraform"
    Environment = "Development"
  }
}
