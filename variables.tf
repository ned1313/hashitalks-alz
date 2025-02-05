variable "location" {
  description = "The Azure location in which the resources will be deployed."
  type        = string
}

variable "region" {
  description = "The geographic region in which the resources will be deployed."
  type        = string
}

variable "environment" {
  description = "The environment name for the resources."
  type        = string
}