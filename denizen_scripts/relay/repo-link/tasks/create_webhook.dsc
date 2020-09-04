create_webhook:
    type: task
    debug: true
    definitions: channel_id|channel_name
    script:
        - define url https://discord.com/api/channels/<[channel_id]>/webhooks
        - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>
        - define channel_data <map.with[name].as[#<[channel_name]>].to_json>
        - ~webget <[url]> headers:<[headers]> data:<[channel_data]> save:response
        - if <entry[response].failed>:
            - stop
        - define result <entry[response].result>
        - define hook https://discordapp.com/api/webhooks/<[result].get[id]>/<[result].get[token]>

    #| Response is a Map object

    #|{
    #|  "type": 1,
    #|  "id": "750745265232674888",
    #|  "name": "#vip-chat",
    #|  "avatar": null,
    #|  "channel_id": "749061087240126524",
    #|  "guild_id": "626078288556851230",
    #|  "application_id": "716381772610273430",
    #|  "token": "TOKEN HERETOKEN HERETOKEN HERE",
    #|  "user": {
    #|    "id": "716381772610273430",
    #|    "username": "Adriftus Server Bot",
    #|    "avatar": "c4811bb153b7ec5375c19e00cfe62495",
    #|    "discriminator": "5834",
    #|    "public_flags": 0,
    #|    "bot": true
    #|  }

    #| https://discordapp.com/api/webhooks/<[id]>/<[token]> is the webhook url
