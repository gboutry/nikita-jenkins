pluginsToJenkinsParameters = (plugins) ->
  console.info plugins
  params = new URLSearchParams()
  #params.append "dynamicLoad", "true"
  for plugin in plugins
    params.append "plugin.#{plugin}.default", "on"
  return params

module.exports = ({ config }) ->
  # await @execute.wait
  #   command: "test $(curl --silent --output /dev/null --write-out '%{http_code}' http://#{
  #     config.ssh.host
  #   }:8080/) -eq 403"
  await @network.tcp.wait
    host: config.ssh.host
    port: 8080
  await @jenkins.http
    address: "http://#{config.ssh.host}:8080"
    route: "/pluginManager/install"
    method: "POST"
    contentType: "application/x-www-form-urlencoded"
    body: pluginsToJenkinsParameters config.jenkinsPlugins
    username: config.admin.username
    password: config.admin.password
  return
