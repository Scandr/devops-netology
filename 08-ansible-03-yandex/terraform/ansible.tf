# time for manually ssh log in the created hosts to avoid stacking at
# "Are you sure you want to continue connecting (yes/no/[fingerprint])?"
resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 180"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../playbook/inventory/prod.yml ../playbook/site.yml "
  }

  depends_on = [
    null_resource.wait
  ]
}
