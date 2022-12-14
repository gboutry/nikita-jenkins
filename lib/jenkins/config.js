// Generated by CoffeeScript 2.7.0
var path;

path = require("path");

module.exports = async function({config}) {
  await this.file({
    $header: "Templating jenkins configuration",
    target: "/etc/sysconfig/jenkins",
    match: /(JENKINS_JAVA_OPTIONS)="(.*)"/,
    replace: [`$1='$2 ${config.java_options}'`]
  });
  await this.file({
    target: config.jenkins_user.home + "/jenkins.install.UpgradeWizard.state",
    content: "2.0"
  });
  await this.fs.base.mkdir({
    $unless_exists: config.jenkins_user.home + "/init.groovy.d/",
    target: config.jenkins_user.home + "/init.groovy.d/",
    uid: config.jenkins_user.uid,
    gid: config.jenkins_user.uid
  });
  await this.file.render({
    local: true,
    mode: "550",
    uid: config.jenkins_user.uid,
    gid: config.jenkins_user.uid,
    source: path.resolve(__dirname, "../../templates/init-script.groovy.hbs"),
    target: config.jenkins_user.home + "/init.groovy.d/init-script.groovy",
    context: {
      username: config.admin.username,
      password: config.admin.password
    }
  });
  await this.jenkins.start();
  await this.wait({
    time: 5000
  });
  // await @jenkins.stop()
  await this.execute({
    $if_exists: config.jenkins_user.home + "/init.groovy.d/init-script.groovy",
    command: "rm " + config.jenkins_user.home + "/init.groovy.d/init-script.groovy"
  });
};
