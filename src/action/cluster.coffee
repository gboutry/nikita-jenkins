module.exports = ({ config }) ->
  await @log.cli()
  { $status } = await @lxc.cluster config
  console.info "Cluster was created: #{$status}"
  return
