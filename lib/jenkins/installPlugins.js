// Generated by CoffeeScript 2.7.0
var pluginsToJenkinsParameters;

pluginsToJenkinsParameters = function(plugins) {
  var i, len, params, plugin;
  console.info(plugins);
  params = new URLSearchParams();
//params.append "dynamicLoad", "true"
  for (i = 0, len = plugins.length; i < len; i++) {
    plugin = plugins[i];
    params.append(`plugin.${plugin}.default`, "on");
  }
  return params;
};

module.exports = async function({config}) {
  // await @execute.wait
  //   command: "test $(curl --silent --output /dev/null --write-out '%{http_code}' http://#{
  //     config.ssh.host
  //   }:8080/) -eq 403"
  await this.network.tcp.wait({
    host: config.ssh.host,
    port: 8080
  });
  await this.jenkins.http({
    address: `http://${config.ssh.host}:8080`,
    route: "/pluginManager/install",
    method: "POST",
    contentType: "application/x-www-form-urlencoded",
    body: pluginsToJenkinsParameters(config.jenkinsPlugins),
    username: config.admin.username,
    password: config.admin.password
  });
};