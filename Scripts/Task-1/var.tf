variable "region" {
	default = "us-east-1"
}

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "TagName" {
	default = "Ashwin-Bharadwaj"
}

variable "publicsub_1" {       
	default = "10.0.10.0/24"
}

variable "publicsub_2" {       
	default = "10.0.20.0/24"
}

variable "privatesub_1" {       
	default = "10.0.30.0/24"
}

variable "privatesub_2" {       
	default = "10.0.40.0/24"
}

variable "key_name" {       
	default = "Ashwin-Bharadwaj-CapstoneProject"
}
