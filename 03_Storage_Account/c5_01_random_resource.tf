resource "random_string" "myrandom" {
  length  = 6
  upper   = false
  special = false
  number  = true
  lower   = true
}