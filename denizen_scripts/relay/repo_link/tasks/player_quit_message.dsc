Player_Leave_Message:
  type: task
  debug: false
  definitions: server|name|uuid|message
  data:
    webhook_content:
      username: <[name]>
      avatar_url: https://mc-heads.net/head/<[uuid]>
      embeds: <list[<script[Player_Leave_Message].parsed_key[data.embed]>]>
      content: ""
    embed:
      type: rich
      title: Player Leave
      description: <[message]>
      color: 15548997
      thumbnail:
        url: https://icons.iconarchive.com/icons/gakuseisean/ivista-2/128/Alarm-Minus-icon.png
        height: 8
        width: 8
  script:
    - define channel <yaml[chat_config].read[channels.server.integrations.Discord.<[server]>.channel]>
    - ~run discord_get_or_create_webhook def:<[channel]> save:webhook
    - define Hook <entry[webhook].created_queue.determination.get[1]>
    - define Data <script.parsed_key[data.webhook_content].to_json>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]> save:webget
    - announce to_console <entry[webget].results>