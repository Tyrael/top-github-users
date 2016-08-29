#!/usr/bin/env coffee
fs = require 'fs'
utils = require './utils'

BANNED = [
  'gugod'         # 7K commits in 4 days.
  'sindresorhus'  # Asked to remove himself from the list.
  'funkenstein'   # Appears in the list even though he has 30 followers (bug).
  'beberlei'      # 1.7K contribs every day
  'IonicaBizau'   # Contribution graffiti.
  'scottgonzalez' # Graffiti.
  'AutumnsWind'   # Graffiti.
  'hintjens'      # Graffiti.
]

saveTopLogins = ->
  MIN_FOLLOWERS = 20
  MAX_PAGES = 10
  LOCATION = 'Hungary'
  TOKEN = ''
  urls = utils.range(1, MAX_PAGES + 1).map (page) -> [
      "https://api.github.com/search/users?q=followers:%3E#{MIN_FOLLOWERS}+location:#{LOCATION}+sort:followers&per_page=100&access_token=#{TOKEN}"
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
