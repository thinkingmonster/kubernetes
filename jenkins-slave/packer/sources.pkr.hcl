source "docker" "jenkinsci-jnlp" {
  image   = "jenins_slave:centos"
  commit  = true
  pull = false
  changes= [
    "ENTRYPOINT jenkins-agent",
  ]
}