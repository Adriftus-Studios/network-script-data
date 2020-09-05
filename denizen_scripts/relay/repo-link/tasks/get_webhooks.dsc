get_webhooks:
    type: task
    debug: false
    definitions: channel_id
    script:
        - define url https://discord.com/api/channels/<[channel_id]>/webhooks
        - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>
        - ~webget <[url]> headers:<[headers]> save:response
        - if <entry[response].failed>:
            - stop
        - inject web_debug.webget_response
        - define result <util.parse_yaml[{"data":<entry[response].result>}].get[data]>

        - if <[result].is_empty>:
            - inject get_channel
            - inject create_webhook
        - else:
            - define hook https://discordapp.com/api/webhooks/<[result].first.get[id]>/<[result].first.get[token]>
    
    #| Response is an arrayList object needed converted from a Map object

    #|[
    #|  {
    #|    "type": 1,
    #|    "id": "732737040441016417",
    #|    "name": "#design-chat",
    #|    "avatar": null,
    #|    "channel_id": "669922990435336216",
    #|    "guild_id": "626078288556851230",
    #|    "application_id": null,
    #|    "token": "TOKEN HERETOKEN HERETOKEN HERE",
    #|    "user": {
    #|      "id": "194619362223718400",
    #|      "username": "Behr",
    #|      "avatar": "a_dee7262dd67443aec6bb90920625b2ba",
    #|      "discriminator": "5305",
    #|      "public_flags": 0
    #|    }
    #|  }
    #|]

    #| https://discordapp.com/api/webhooks/<[id]>/<[token]> is the webhook url
