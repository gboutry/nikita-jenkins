path = require "path"
module.exports = ({ config }) ->
  await @file
    $header: "Templating jenkins configuration"
    target: "/etc/sysconfig/jenkins"
    match: /(JENKINS_JAVA_OPTIONS)="(.*)"/
    replace: ["$1='$2 #{config.java_options}'"]
  await @file
    target: config.jenkins_user.home + "/jenkins.install.UpgradeWizard.state"
    content: "2.0"
  await @fs.base.mkdir
    $unless_exists: config.jenkins_user.home + "/init.groovy.d/"
    target: config.jenkins_user.home + "/init.groovy.d/"
    uid: config.jenkins_user.uid
    gid: config.jenkins_user.uid
  await @file.render
    local: yes
    mode: "550"
    uid: config.jenkins_user.uid
    gid: config.jenkins_user.uid
    source: path.resolve __dirname, "../../templates/init-script.groovy.hbs"
    target: config.jenkins_user.home + "/init.groovy.d/init-script.groovy"
    context:
      username: config.admin.username
      password: config.admin.password
  await @jenkins.start()
  await @wait time: 5000
  # await @jenkins.stop()
  await @execute
    $if_exists: config.jenkins_user.home + "/init.groovy.d/init-script.groovy"
    command:
      "rm " + config.jenkins_user.home + "/init.groovy.d/init-script.groovy"
  return
