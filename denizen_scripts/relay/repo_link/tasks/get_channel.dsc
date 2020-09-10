get_channel:
    type: task
    debug: false
    definitions: channel_id
    script:
        - define url https://discord.com/api/channels/<[channel_id]>
        - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>
        - ~webget <[url]> headers:<[headers]> save:response
        - if <entry[response].failed>:
            - stop
        - inject web_debug.webget_response
        - define channel_map <util.parse_yaml[<entry[response].result>]>
        - define channel_id <[channel_map].get[id]>
        - define channel_name <[channel_map].get[name]>

    #| Response is a Map object

    #|{
    #|  "id": "647120672476233752",
    #|  "last_message_id": "731578362996195449",
    #|  "last_pin_timestamp": "2020-01-12T02:50:08.539000+00:00",
    #|  "type": 0,
    #|  "name": "📰resource-pack",
    #|  "position": 20,
    #|  "parent_id": "730895726254620792",
    #|  "topic": "",
    #|  "guild_id": "626078288556851230",
    #|  "permission_overwrites": [
    #|    {
    #|      "id": "626078288556851230",
    #|      "type": "role",
    #|      "allow": 0,
    #|      "deny": 1049600,
    #|      "allow_new": "0",
    #|      "deny_new": "1049600"
    #|    }
    #|  ],
    #|  "nsfw": false,
    #|  "rate_limit_per_user": 0
    #|}
