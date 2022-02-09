>ℹ️&nbsp;&nbsp;SignalFx was acquired by Splunk in October 2019. See [Splunk SignalFx](https://www.splunk.com/en_us/investor-relations/acquisitions/signalfx.html) for more information.

# SignalFx Jumpstart
**Requires Terraform (minimum) v0.14**

## Introduction
This repository provides detectors, dashboard groups, and dashboards that can easily be deployed in a Splunk Observability Cloud org using Terraform. This can be useful for the assets themselves, but also as a construct for how prospects and customers can easily share assets across multiple parent/child orgs or with other customers.

Also included is an [export script](./export_script) which can be used to easily export dashboards, dashboard groups, and detectors.

These are complimentary to the out of the box content provided by Splunk.

This repository and its assets are provided "as-is" and are not supported by Splunk.

## Clone this repository:

`git clone https://github.com/signalfx/signalfx-jumpstart.git`

## Initialise Terraform

```
$ terraform init --upgrade
```

## Create a workspace for the prospect (Optional)

```
$ terraform workspace new my_prospect
```
Where `my_prospect` is the company name of the prospect

## Review the execution plan

```
$ terraform plan -var="access_token=abc123" -var="realm=eu0"
```

Where `access_token` is the Splunk Access Token and `realm` is either `eu0`, `us0`, `us1` or `us2`

## Apply the changes

```
$ terraform apply -var="access_token=abc123" -var="realm=eu0"
```

## Destroy everything!

If you created a workspace you will first need to ensure you are in the correct workspace e.g.

```
$ terraform workspace select my_prospect
```
Where `my_prospect` is the company name of the prospect

```
$ terraform destroy -var="access_token=abc123" -var="realm=eu0"
```

# Deploying a module

```
terraform apply -var="access_token=abc123" -var="realm=eu0" -target=module.aws
terraform apply -var="access_token=abc123" -var="realm=eu0" -target=module.dashboards
terraform apply -var="access_token=abc123" -var="realm=eu0" -target=module.gcp
```
