Player_Death_Message:
  type: task
  debug: false
  definitions: server|name|uuid|message
  data:
    username: <[name]>
    avatar_url: https://mc-heads.net/head/<[uuid]>
    embeds:
      embed:
        type: rich
        title: Player Death
        description: <[message]>
        color: 0xff0000
        thumbnail:
          url: https://icons.iconarchive.com/icons/google/noto-emoji-smileys/128/10099-skull-and-crossbones-icon.png
          height: 16
          width: 16
        footer:
          text: <util.time_now.format>
  script:
    - define channel <yaml[chat_config].read[channels.server.integrations.Discord.<[server]>.channel]>
    - ~run discord_get_or_create_webhook def:<[channel]> save:webhook
    - define Hook <entry[webhook].created_queue.determination.get[1]>
    - define Data <script.parsed_key[data].to_json>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]> save:webget