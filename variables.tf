variable "access_token" {
  description = "SignalFx Access Token"
}

variable "realm" {
  description = "SignalFx Realm"
}

variable "sfx_prefix" {
  type        = string
  description = "Detector Prefix"
  default     = "[SFx]"
}