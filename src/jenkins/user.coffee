module.exports = ({ config }) ->
  await @system.group
    $header: "Create Jenkins group"
    gid: config.jenkins_user.gid
    name: config.jenkins_user.name
    system: yes
  await @system.user
    $header: "Create Jenkins service account"
    comment: "Jenkins service account"
    gid: config.jenkins_user.gid
    home: config.jenkins_user.home
    name: config.jenkins_user.name
    system: yes
    uid: config.jenkins_user.uid
  return
