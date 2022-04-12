resource "random_string" "myrandom" {
  length  = 4
  upper   = false
  special = false
  number  = true
  lower   = false
}