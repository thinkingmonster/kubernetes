build {
  sources = [
    "source.docker.jenkinsci-jnlp",
  ]



  provisioner "shell" {
    script = "../install_package.sh"
  }

  post-processor "docker-tag" {
    repository = "jenkinsci-prod"
    tag        = ["1.0"]
  }

}