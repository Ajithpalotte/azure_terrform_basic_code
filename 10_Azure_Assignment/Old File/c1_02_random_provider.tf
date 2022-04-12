resource "random_string" "ramdom_assignment" {
  length  = 4
  lower   = true
  upper   = false
  number  = false
  special = false
}