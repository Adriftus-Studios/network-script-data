Player_Join_Message:
  type: task
  debug: false
  definitions: server|name|uuid|message
  data:
    webhook_content:
      username: <[name]>
      avatar_url: https://mc-heads.net/head/<[uuid]>
      embeds: <list[<script[Player_Join_Message].parsed_key[data.embed]>]>
      content: ""
    embed:
      type: rich
      title: Player Join
      description: <[message]>
      color: 39484
      thumbnail:
        url: https://github.com/Adriftus-Studios/resource-pack/blob/main/assets/adriftus/textures/custom_chat/join_icon.png
        height: 8
        width: 8
  script:
    - define channel <yaml[chat_config].read[channels.server.integrations.Discord.<[server]>.channel]>
    - ~run discord_get_or_create_webhook def:<[channel]> save:webhook
    - define Hook <entry[webhook].created_queue.determination.get[1]>
    - define Data <script.parsed_key[data.webhook_content].to_json>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]> save:webget
