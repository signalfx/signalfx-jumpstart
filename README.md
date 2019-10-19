# POC in a Box

Clone this repository:

`git clone https://github.com/signalfx/poc-in-a-box.git`

Define your realm in `terraform.tfvars`

Create `secret.tfvars` and add your SignalFx Access Token e.g.

```
access_token = "abc123"
```

Initialise Terraform:

```
$ terraform init
```

Review the execution plan:

```
$ terraform plan -var-file="secrets.tfvar" -var-file="terraform.tfvar"
```

Apply the changes:

```
$ terraform apply -var-file="secrets.tfvar" -var-file="terraform.tfvar"
```

Destory all detectors

```
$ terraform destroy -var-file="secrets.tfvar" -var-file="terraform.tfvar"
```
