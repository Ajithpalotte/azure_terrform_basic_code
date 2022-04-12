resource "random_string" "ramdom_assignment" {
  count   = 4
  lower   = true
  upper   = false
  number  = false
  special = false
}