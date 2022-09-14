fetch = require "node-fetch-commonjs"

module.exports = ({ config, tools: { log } }) ->
  throw Error "Missing address" unless config.address
  throw Error "Missing route" unless config.route

  auth = "#{config.username}:#{config.password}"
  auth = Buffer.from(auth).toString "base64"

  response =
    await fetch "#{config.address}/crumbIssuer/api/json",
      # credentials: "include"
      headers:
        Accept: "application/json"
        "Content-Type": "application/json"
        Authorization: "Basic " + auth
  cookies = response.headers.get "set-cookie"
  { crumbRequestField, crumb } = await response.json()
  log
    message: "Send request to #{config.address}/#{config.route}", level: "DEBUG"
  response =
    await fetch "#{config.address}/#{config.route}",
      credentials: "include"
      method: config.method ? "GET"
      headers:
        Accept: "application/json"
        "Content-Type": config.contentType ? "application/json"
        Authorization: "Basic " + auth
        cookie: cookies
        "#{crumbRequestField}": crumb
      body: config.body

  return response.text()
