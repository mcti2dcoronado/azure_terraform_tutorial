variable "subscription_id"{
  type=string
}
variable "client_id"{
  type=string
}
variable "client_secret"{
  type=string
}
variable "tenant_id"{
  type=string
}

variable "prefix"{
  type=string
  default="batcha06"
}
variable "env"{
  type =string
  default="dev"
}
variable "account_tier"{
type =string
default="Standard"
}

variable "admin_username"{
 type = string
}

variable "admin_password"{
  type = string
}
