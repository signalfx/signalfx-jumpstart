# SignalFx Jumpstart
#### Requires Terraform v0.12.18

Clone this repository:

`git clone https://github.com/signalfx/signalfx-jumpstart.git`

**Initialise Terraform:**

```
$ terraform init
```

**Create a workspace for the prospect:**

```
$ terraform workspace new my_prospect
```
Where `my_prospect` is the company name of the prospect

**Review the execution plan:**

```
$ terraform plan -var="access_token=abc123" -var="realm=eu0"
```

Where `access_token` is the SignalFx Access Token and `realm` is either `eu0`, `us1` or `ap0`

**Apply the changes:**

```
$ terraform apply -var="access_token=abc123" -var="realm=eu0"
```

**Destory all detectors**

You will first need to ensure you are in the correct workspace for the customer e.g.

```
$ terraform workspace select my_prospect
```
Where `my_prospect` is the company name of the prospect

```
$ terraform destroy -var="access_token=abc123" -var="realm=eu0"
```
