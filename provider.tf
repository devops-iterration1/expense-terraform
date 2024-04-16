provider "vault" {
  address = "https://vault-int.izypsy.cloud:8200"
  skip_tls_verify = true
  token = var.vault_token
}