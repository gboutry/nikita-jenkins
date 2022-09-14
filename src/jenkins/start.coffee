module.exports = () ->
  await @service
    name: "jenkins"
    state: "started"
    startup: yes
  return
