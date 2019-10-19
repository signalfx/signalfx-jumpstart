# POC in a Box

Clone this repository:

`git clone https://github.com/signalfx/poc-in-a-box.git`

Define your realm in `terraform.tfvars`

Create `secret.tfvars` and add your SignalFx Access Token e.g.

```
access_token = "abc123"
```

**Initialise Terraform:**

```
$ terraform init
```

**Create a workspace for the POC customer:**

```
$ terraform workspace new bar
```

Where `bar` is the company name of the customer

**Review the execution plan:**

```
$ terraform plan -var-file="secrets.tfvar" -var-file="terraform.tfvar"
```

**Apply the changes:**

```
$ terraform apply -var-file="secrets.tfvar" -var-file="terraform.tfvar"
```

**Destory all detectors**
You will first need to ensure you are in the correct workspace for the customer e.g.

```
$ terraform workspace select bar
```
Where `bar` is the company name of the customer

```
$ terraform destroy -var-file="secrets.tfvar" -var-file="terraform.tfvar"
```

**NOTE:** The SignalFx Access Token and Realm can be passed via the command line e.g.

```
$ terraform plan -var="access_token=abc123" -var="realm=eu0"
```