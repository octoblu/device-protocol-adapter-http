debug = require('debug')('meshblu:device-protocol-adapter-http')
MeshbluHttp = require 'meshblu-http'
url = require 'url'
_ = require 'lodash'

class ManagementController
  constructor: ({@service}) ->

  authenticate: (req, res) =>
    octobluOauthUrl = url.format
      protocol: 'https'
      host: 'oauth.octoblu.com'
      pathname: '/authorize'
      query:
        client_id: '206597a2-0883-4b3b-9b7c-93c3e0c05d62'
        redirect_uri: 'http://localhost:1337/authenticated'
        response_type: 'code'

    res.redirect octobluOauthUrl

  authenticated: (req, res) =>

    auth = new Buffer(req.query.code, 'base64').toString().split(':')
    uuid = auth[1]
    token = auth[2]

    console.log({uuid, token})
    res.cookie 'meshblu_auth_uuid', uuid
    res.cookie 'meshblu_auth_token', token

    res.redirect '/authorize'

  authorize: (req, res) =>
    console.log cookies: req.cookies
    console.log('omg, I am authenticated')
    console.log req.meshbluAuth
    res.sendFile 'index.html', root: __dirname + '../../../public'

  authorized: (req, res) =>
    throw new Error('Implement authorized plz')

module.exports = ManagementController