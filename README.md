# hashitalks-alz

Example repository for my HashiTalks 2025 Azure Landing Zones presentation

## Overview

This repository is meant to work with HCP Terraform Stacks and the newly released Azure Verified Modules for Azure Landing Zones (ALZ) to deploy a basic landing zone setup. If you want to follow along, you will need at least two Azure subscriptions and owner level permissions on those subscriptions.

## Presentation Outline

* What are Azure Landing Zones?
  * Blueprint for common deployment patterns
  * Meant to set up governance and framework for enterprise consumption
  * Two kinds of landing zones
    * Platform: creates the shared resources and structure for applications
    * Application: Builds out a substrate for a single application
  * Key Platform Components:
    * Identity, Connectivity, and Management
    * Organized using Management groups and delegated permissions
    * Each category uses an Azure Subscription
    * Azure Policies are applied to check and report on best practices
    * Automation accounts and Log Analytics are centralized in the management subscription
    * Virtual networks and connectivity are centralized in the connectivity sub
    * Identity sub is for Entra ID Domain Services and is optional
  * Application LZs connect to the Platform LZ for all these shared services
* Deployment options
  * Bicep or Terraform
  * We're going with Terraform
* What are Azure Verified Modules?
  * The original CAF module is being retired
  * It was a beast of a module that required a phased roll-out approach
  * AVM are modules designed using specific principles Microsoft created
  * AVM modules have consistent structure, inputs, outputs, and a dedicated maintainer
  * AVM for ALZ uses AVM to compose a platform LZ
* Challenges of Deploying ALZ
  * Sequencing challenges in the LZ deployment process
  * Need to create log analytics stuff first
  * Deferred apply would be nice
  * Oh hey, terraform Stacks
* Terraform Stacks Overview
  * Stacks is an enhanced approach to managing a complex environment
  * Built from components that are similar in nature to modules
  * A deployment is an instance of the components
  * Easier to work with multiple subscriptions dynamically
  * TF Stacks uses the tfstack and tfdeploy files to define a stack
* Using the Accelerator PowerShell Module
  * You can build the whole LZ configuration yourself from these AVM for ALZ modules
    * Resource group
    * Regions
    * Hub networking
    * Vnet Gateway
    * DNS Resolver
    * Private Link for Private DNS
    * Private DNS
    * DDoS protection
    * Public IP address
    * Bastion host
    * ALZ Pattern
    * ALZ Management
    * Firewall
    * Virtual WAN
  * Or you can use the Accelerator module to help you
  * Either way, do not undertake this lightly, you're building a serious thing!
  * Accelerator steps
    * 0-Plan: before you do anything, answer the questions
    * 1-Fulfill prerequisites (mgmt groups, subs, accounts)
    * 2-Build out the file structure and copy contents from example files
    * 3-Customize the example files to match your desired environment
    * 4-Generate the accelerator configuration (local file creation)
    * 5-Refactor for HCP Terraform Stacks (this will take a while!)
* Adapting for Stacks
  * The initial structure uses a combination of local and remote modules
  * There is a lot of naming happening from inputs
  * Inputs are included in the terraform.tfvars.json and platform-landing-zone.auto.tfvars
  * Why are we using JSON? No idea, doesn't seem useful.
  * Bootstrapping/naming stuff goes in it's own module, results are exposed using outputs
  * Each main file invokes modules, each module is now a component
  * Variables need to live in the top-level of the stack and be passed to the components
  * Also need to catalog all the providers being used by the stack (hint, there's a lot)
  * Going to use OIDC auth for Azure: so you need a FID credential
  * Sequencing (order of components)
* Is it worth it?
  * Yes, I think in the long-term this is worth your investment
  * Also will be super useful when deploying Application landing zones (make use of multiple deployments in the stacks for each app)
* Should you use the accelerator?
  * Maybe? I think it gives a good starting point, but you're going to have to refactor a lot. I like that b/c it helps me understand what's actually happening. But the more you diverge from the accelerator, the more you have to maintain.

## Analysis

### avm-utl-regions

This module is not actually used at all. Can be safely removed

### avm-res-resources-resourcegroups

Creates resource groups in the connectivity subscription. Uses the contents of local `connectivity_resource_groups`. Defined in local.resource_groups and dependent on var.conenctivity_resource_groups.

Dependencies? None, as far as I can tell. This should be its own component.

### avm-ptn-alz-management

Inside the management_resources module. What does this module actually do? It creates the log analytics workspace, automation account, and user assigned identity in the management subscription. No pre-requisites as far as I can tell. This can be its own component and doesn't have to be in a module.

### avm-ptn-alz

This one is what actually sets up the management group structure and assigns subscriptions. It also applies policies. It has a list of possible dependencies, which I don't really understand. So basically all the objects need to exist prior to this module running a plan due to the need for computed values. We can avoid using the dependency argument through the use of stacks.


small change