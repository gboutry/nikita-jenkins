const nikita = require("nikita");
const yaml = require("js-yaml");
const fs = require("fs");
const path = require("path");
require("@nikitajs/tools/lib/register");

(async () => {
  await nikita(
    {
      $debug: true,
    },
    async function () {
      await this.registry.register({
        jenkins: {
          "": require("./lib/jenkins/index"),
          config: require("./lib/jenkins/config"),
          http: require("./lib/jenkins/http"),
          install: require("./lib/jenkins/install"),
          installPlugins: require("./lib/jenkins/installPlugins"),
          start: require("./lib/jenkins/start"),
          stop: require("./lib/jenkins/stop"),
          user: require("./lib/jenkins/user"),
        },
      });
      await this.log.cli();
      await this.log.md({ basedir: "log/" });
      config = yaml.load(
        fs.readFileSync(path.resolve(__dirname, "conf/config.yaml"))
      );
      switch (process.argv[2]) {
        case "create":
          await this.lxc.cluster({ $sudo: true }, config.cluster);
          break;
        case "delete":
          await this.lxc.cluster.stop(config.cluster);
          await this.lxc.cluster.delete(config.cluster);
          break;
        case "jenkins":
          await this.jenkins(
            { $header: "Install Jenkins", $sudo: true },
            config.jenkins
          );
          break;
        case "plugin":
          await this.ssh
            .open(config.jenkins.ssh)
            .jenkins.installPlugins({ $sudo: true }, config.jenkins)
            .ssh.close();
          break;
        default:
          await this.lxc.cluster({ $sudo: true }, config.cluster);
          await this.jenkins(
            { $header: "Install Jenkins", $sudo: true },
            config.jenkins
          );
          break;
      }
    }
  );
})()
  .then(() => console.log("Jenkins successfully installed"))
  .catch((error) => console.log("Failed to install jenkins\n" + error));
