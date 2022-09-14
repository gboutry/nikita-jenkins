module.exports = ({ config }) ->
  # await @file.download
  #   $header: "Download jenkins repo"
  #   $unless_exists: "/etc/yum.repos.d/jenkins.repo"
  #   source: "https://pkg.jenkins.io/redhat-stable/jenkins.repo"
  #   target: "/etc/yum.repos.d/jenkins.repo"
  # await @file.download
  #   $header: "Download jenkins repo's signing key"
  #   $unless_exists: "/tmp/jenkins.io.key"
  #   source: "https://pkg.jenkins.io/redhat/jenkins.io.key"
  #   target: "/tmp/jenkins.io.key"
  await @tools.repo
    $header: "Setup jenkins repo"
    source: "https://pkg.jenkins.io/redhat-stable/jenkins.repo"
    gpg_key: "https://pkg.jenkins.io/redhat/jenkins.io.key"
    target: "/etc/yum.repos.d/jenkins.repo"
    verify: yes
  await @execute
    $header: "Yum upgrade"
    command: "yum upgrade -y"
  await @execute
    $header: "Install epel repo and JDK11"
    command: "yum install -y epel-release java-11-openjdk-devel unzip"
  await @fs.mkdir "/usr/share/jenkins/ref"
  await @execute
    $header: "Install Jenkins"
    command: "yum install -y jenkins"
  return
