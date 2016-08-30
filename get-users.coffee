#!/usr/bin/env coffee
fs = require 'fs'
utils = require './utils'

BANNED = [
]

saveTopLogins = ->
  MAX_PAGES = 10
  LOCATION = 'Hungary'
  TOKEN = ''
  urls = utils.range(1, MAX_PAGES + 1).map (page) -> [
      "https://api.github.com/search/users?q=location:#{LOCATION}+sort:followers&per_page=100&access_token=#{TOKEN}"
      "&page=#{page}"
    ].join('')

  parse = (text) ->
    JSON.parse(text).items.map (_) -> _.login

  utils.batchGet urls, parse, (all) ->
    logins = [].concat.apply [], all
    filtered = logins.filter (name) ->
      name not in BANNED
    utils.writeStats './temp-logins.json', filtered

saveTopLogins()
