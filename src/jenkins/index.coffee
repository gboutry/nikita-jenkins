module.exports = ({ config }) ->
  await @ssh.open { $header: "Open SSH connection" }, config.ssh
  await @jenkins.user config
  await @jenkins.install config
  await @jenkins.config config
  await @jenkins.start()
  await @jenkins.installPlugins config
  await @ssh.close $header: "Closing SSH connection"

  return
