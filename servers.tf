module "" {
  for_each = var.components
  source = "./module"
  component_name = each.value["name"]
  instance_type = each.value["instance_type"]
  env = var.env
  password = lookup(each.value, "password", "null" )

}