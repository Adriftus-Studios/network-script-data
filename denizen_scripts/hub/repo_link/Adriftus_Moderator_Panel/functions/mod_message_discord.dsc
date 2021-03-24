mod_message_discord:
  type: task
  debug: false
  definitions: moderator|player|level|infraction|action|length
  script:
    - inject mod_get_incidents_task
    - define moderator <tern[<[moderator].is[!=].to[Server]>].pass[<[moderator].as_player.name>].fail[Server]>
    # -- Messages #action-log on the Adriftus Staff server. (626078288556851230/715731482978812014).
    - define group 626078288556851230
    - define channel 715731482978812014

    - define webhook_username Moderation<&sp>Report
    - define webhook_icon_url https://img.icons8.com/nolan/64/warning-shield.png
    - define embeds <list>

    - define fields <list>
    - define color 8781824

    - define title User<&co><&sp><[player]>
    - define title_icon_url https://minotar.net/helm/<[player]>
    - define author <map.with[name].as[<[title]>].with[icon_url].as[<[title_icon_url]>]>

    - define footer_text <script[mod_action_past_tense].data_key[<[action]>].to_titlecase><&sp>by<&co><&sp><[moderator]>
    - define footer_icon_url <tern[<[moderator].is[!=].to[Server]>].pass[https://minotar.net/helm/<[moderator]>].fail[https://raw.githubusercontent.com/AuroraInteractive/network-script-data/master/images/logos/icon2.png]>
    - define footer <map.with[text].as[<[footer_text]>].with[icon_url].as[<[footer_icon_url]>]>

    - define field1_name Reason<&co>
    - define field1_value <[infraction]>
    - define field1_inline false
    - define fields:->:<map.with[name].as[<[field1_name]>].with[value].as[<[field1_value]>].with[inline].as[<[field1_inline]>]>

    - define field2_name Action<&co>
    - define field2_value <[action]>
    - define field2_inline true
    - define fields:->:<map.with[name].as[<[field2_name]>].with[value].as[<[field2_value]>].with[inline].as[<[field2_inline]>]>

    - if <[length]||null> != null:
      - define fieldD_name Duration<&co>
      - define fieldD_value <[length].as_duration.formatted>
      - define fieldD_inline true
      - define fields:->:<map.with[name].as[<[fieldD_name]>].with[value].as[<[fieldD_value]>].with[inline].as[<[fieldD_inline]>]>

    - define field3_name Incident<&sp>#<&co>
    - define field3_value <[incidents]>
    - define field3_inline true
    - define fields:->:<map.with[name].as[<[field3_name]>].with[value].as[<[field3_value]>].with[inline].as[<[field3_inline]>]>

    - define timestamp <util.time_now.format[yyyy-MM-dd]>T<util.time_now.format[HH:mm:ss.SS]>Z

    - define embeds <[embeds].include[<map.with[color].as[<[color]>].with[fields].as[<[fields]>].with[author].as[<[author]>].with[footer].as[<[footer]>].with[timestamp].as[<[timestamp]>]>]>

    - define data <map.with[username].as[<[webhook_username]>].with[avatar_url].as[<[webhook_icon_url]>].with[embeds].as[<[embeds]>].to_json>
    - define context <list[<[channel]>].include[<[data]>]>
    - bungeerun relay embedded_discord_message_new def:<[context]>

    # -- Localhost testing on Adriftus Staff #bot-spam
    #- define hook https://discordapp.com/api/webhooks/713089103276802058/91jFTo9mwSdCvxl9gE6lnG4YJXe9r3ZBfxpk5ZOzxuShcgCsyPqF4IC2TE4R5MaheUh_
    #- define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    #- ~webget <[hook]> data:<[data]> headers:<[Headers]>

mod_get_incidents_task:
  type: task
  debug: false
  script:
    # Define directory and YAML ID
    - define dir data/players/<server.match_offline_player[<[player]>].uuid>.yml
    - define id amp.get.<server.match_offline_player[<[player]>].uuid>
    # Load yaml data
    - ~yaml id:<[id]> load:<[dir]>
    - define incidents <yaml[<[id]>].read[incidents]||0>
    - yaml unload id:<[id]>
