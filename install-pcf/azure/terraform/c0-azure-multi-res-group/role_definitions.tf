
resource "azurerm_role_definition" "network_readonly" {
//  role_definition_id = "00000000-0000-0000-0000-000000000000"
  name               = "PCF Read Network Resource Group (custom) ${var.env_name}"
  scope              = "/subscriptions/${var.subscription_id}"

  permissions {
    actions     = [
      "Microsoft.Network/networkSecurityGroups/read",
      "Microsoft.Network/networkSecurityGroups/join/action",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/publicIPAddresses/join/action",
      "Microsoft.Network/loadBalancers/read",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}",
  ]
}

resource "azurerm_role_definition" "network_deploy" {
  //  role_definition_id = "00000000-0000-0000-0000-000000000000"
  name               = "PCF Deploy Min Perms (custom) ${var.env_name}"
  scope              = "/subscriptions/${var.subscription_id}"

  permissions {
    actions     = [
      "Microsoft.Compute/register/action"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}",
  ]
}

resource "azurerm_role_assignment" "network_readonly_to_pcf_principal" {
//  name               = "00000000-0000-0000-0000-000000000000"
  scope              = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.network_resource_group.id}"
  role_definition_id = "${azurerm_role_definition.network_readonly.id}"
  principal_id       = "${var.pcf_service_principal_client_id}"
}

resource "azurerm_role_assignment" "network_deploy_to_pcf_principal" {
  //  name               = "00000000-0000-0000-0000-000000000000"
  scope              = "/subscriptions/${var.subscription_id}"
  role_definition_id = "${azurerm_role_definition.network_deploy.id}"
  principal_id       = "${var.pcf_service_principal_client_id}"
}

resource "azurerm_role_assignment" "pcf_contributor_to_pcf_principal" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.pcf_resource_group.id}"
  role_definition_name = "Contributor"
  principal_id         = "${var.pcf_service_principal_client_id}"
}