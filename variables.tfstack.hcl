variable "starter_locations" {
  type        = list(string)
  description = "The default for Azure resources. (e.g 'uksouth')|azure_location"
}

variable "client_id" {
  type        = string
  description = "The client id of the service principal used to deploy the resources|azure_client_id"
}

variable "tenant_id" {
  type        = string
  description = "The tenant id of the service principal used to deploy the resources|azure_tenant_id"
}

variable "identity_token" {
  type        = string
  description = "The identity token to use for the deployment"
  ephemeral   = true
}

variable "subscription_id_main" {
  type        = string
  description = "value of the subscription id for the primary subscription|azure_subscription_id"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "value of the subscription id for the Connectivity subscription|azure_subscription_id"
}

variable "subscription_id_identity" {
  type        = string
  description = "value of the subscription id for the Identity subscription|azure_subscription_id"
}

variable "subscription_id_management" {
  type        = string
  description = "value of the subscription id for the Management subscription|azure_subscription_id"
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "This is the id of the management group that the ALZ hierarchy will be nested under, will default to the Tenant Root Group|azure_name"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Flag to enable/disable telemetry"
}

variable "custom_replacements" {
  type = object({
    names                      = optional(map(string), {})
    resource_group_identifiers = optional(map(string), {})
    resource_identifiers       = optional(map(string), {})
  })
  default = {
    names                      = {}
    resource_group_identifiers = {}
    resource_identifiers       = {}
  }
  description = "Custom replacements"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
