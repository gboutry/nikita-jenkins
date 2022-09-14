module.exports = () ->
  await @service
    name: "jenkins"
    state: "stopped"
  return
