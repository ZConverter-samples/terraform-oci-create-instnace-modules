
output "result" {
  value = local.result
}

resource "local_file" "output_result" {
  filename = "${path.cwd}/${var.vm_name}_result.json"

  content = jsonencode(local.result)
}