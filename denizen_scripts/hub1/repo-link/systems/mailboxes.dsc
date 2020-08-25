# ========================================== #
# ||               MAILBOXES              || #
# ========================================== #

Blue_Mailbox:
  type: item
  material: player_head
  display name: <dark_blue>Blue Mailbox
  post: birch_fence
  mechanisms:
    skull_skin: 9287f1f0-817a-457c-9a92-cb6959cb304c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjZhNDllZmFhYWI1MzI1NTlmZmY5YWY3NWRhNmFjNGRkNzlkMTk5ZGNmMmZkNDk3Yzg1NDM4MDM4NTY0In19fQ==

Green_Mailbox:
  type: item
  material: player_head
  display name: <dark_green>Green Mailbox
  post: dark_oak_fence
  mechanisms:
    skull_skin: fd0879d9-fb75-422c-8343-adeb816183e1|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTVmYmJjNjI1ZmE0ZWI2NDk2YmU4ZGJiZjBhYTJiMjhmMTAyOTdjZmZiY2Y1ZTBhYWY2Y2IxMWU4ZjI2MTZlZCJ9fX0=

Iron_Mailbox:
  type: item
  material: player_head
  display name: <dark_gray>Iron Mailbox
  post: iron_bars
  mechanisms:
    skull_skin: fe3576bd-28c3-47d9-a9a7-2d4dc46a5106|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDZhYWVmMDEyMGFmNzFiYTNiODNmYmRkYWJjMzM0YmM2M2YyMzExNTk5Njk4YTMxODI0M2JlNjlmMDYwN2RhMyJ9fX0=

Mailbox_Physics:
  type: world
  debug: false
  events:
    # Always keeps the Mailboxes.yml file loaded.
    on server prestart:
      - yaml id:mailboxes load:mailboxes.yml
      - if !<server.has_flag[mailbox_locations]>:
        - flag server mailbox_locations:->:<empty>
    # Handles the placement of a mailbox on the ground or a wall. Forward compatible with
    # more mailbox designs.
    on player places *_mailbox:
      - determine passively cancelled
      - if <context.material.name> == player_wall_head:
        - define location <context.location>
        - wait 1t
        - modifyblock <[location]> player_wall_head[direction=<context.material.direction>]
      - else:
        - define location <context.location.above>
        - wait 1t
        - modifyblock <[location]> player_head[direction=<context.material.direction>]
        - modifyblock <[location].below> <script[<player.item_in_hand.scriptname>].data_key[post]>
      - adjust <[location]> skull_skin:<script[<player.item_in_hand.scriptname>].data_key[mechanisms.skull_skin]>
      - flag server mailbox_locations:->:<[location]>
      - if !<player.has_flag[acting_op]>:
        - take iteminhand quantity:1
    # The next three events destroy the mailbox if the player breaks any block that is part
    # of its construction.
    on player breaks *_fence|iron_bars:
      - if <server.flag[mailbox_locations].contains[<context.location.above>]>:
        - determine passively cancelled
        - wait 1t
        - modifyblock <context.location> air
        - if <player.has_flag[acting_op]>:
          - modifyblock <context.location.above> air
        - else:
          - modifyblock <context.location.above> air naturally
        - flag server mailbox_locations:<-:<context.location.above>
    on player breaks player_head:
      - if <server.flag[mailbox_locations].contains[<context.location>]>:
        - determine passively cancelled
        - wait 1t
        - if <player.has_flag[acting_op]>:
          - modifyblock <context.location> air
        - else:
          - modifyblock <context.location> air naturally
        - modifyblock <context.location.below> air
        - flag server mailbox_locations:<-:<context.location>
    on player breaks player_wall_head:
      - if <server.flag[mailbox_locations].contains[<context.location>]>:
        - determine passively cancelled
        - wait 1t
        - if <player.has_flag[acting_op]>:
          - modifyblock <context.location> air
        - else:
          - modifyblock <context.location> air naturally
        - flag server mailbox_locations:<-:<context.location>
    # When player interacts with a mailbox, runs the script that will handle mailbox
    # functionality. Supports the shift-right-click behavior of other interactive blocks.
    on player right clicks player_head|player_wall_head:
      - if <server.flag[mailbox_locations].contains[<context.location>]> && !<player.is_sneaking>:
        - determine passively cancelled
        - inject Mailbox_Task_Open

Mailbox_Task_Open:
  type: task
  debug: false
  script:
  # If the player doesn't yet have a Mailbox Inventory stored in the YAML file, creates
  # a default inventory for them.
  - if !<yaml[mailboxes].contains[inventories.<player.uuid>]>:
    - yaml id:mailboxes set inventories.<player.uuid>:->:<item[air].repeat_as_list[17]>
    - yaml id:mailboxes set inventories.<player.uuid>:->:<item[New_Mail_Item]>
    - yaml id:mailboxes savefile:mailboxes.yml
  - inventory open d:<inventory[generic[size=18;title=Mailbox;contents=<yaml[mailboxes].read[inventories.<player.uuid>]>]]>


# ========================================== #
# ||                 MAIL                 || #
# ========================================== #

New_Mail_Item:
  type: item
  material: writable_book[flags=HIDE_ENCHANTS]
  display name: <green>New Mail
  enchantments:
  - Luck
  lore:
  - <blue><bold>Click here to start writing...

Mail_Behavior:
  type: world
  debug: false
  events:
    on player clicks new_mail_item in inventory:
    # When a player clicks "New Mail" inside of a mailbox.
      - if <context.inventory.title> == Mailbox:
        - determine passively cancelled
        - narrate "<green>Click a recipient..."
        - title "subtitle:<green>Click a recipient..."
        - inject New_Mail_Task
    on player clicks letter in inventory:
    # When a player opens received mail.
      - if <context.inventory.title> == Mailbox:
        - determine passively cancelled
        - narrate "Opening letter from <context.item.lore.escaped.after[From ]>"
    on new_mail_command command:
    # When a player clicks a recipient.
      - if <context.args.is_empty>:
        - stop
      - define User <context.args.first>
      - inject Player_Verification_Offline
      - determine passively fulfilled
      - define Recipient <[User]>
      - if !<player.inventory.contains.nbt[<[Recipient].uuid>]>:
        - narrate "<red>You already have a letter to <[Recipient].name> in your inventory."
      - else:
        - if !<player.inventory.empty_slots.is_empty>:
          - give <player> "writable_book[book=<map.with[pages].as[Dear <[Recipient].name>,<p>]>;display_name=<aqua>New Letter to <[Recipient].name>;nbt=Player/<[Recipient].uuid>;lore=Letter to <[Recipient].name>]"
          - narrate "<aqua>Check your inventory for your new blank letter to <[Recipient].name>."
        - else:
          - narrate "<red>Your inventory is full!"
    on player signs book:
    # When a player finishes writing a letter.
      - if <context.book.has_nbt[Player]>:
        - narrate "<gold><&n><&hover[<aqua>Drag and drop an item from your inventory onto the letter to attach it.]>Attach items<&end_hover><&r> <aqua>if you wish, then place this letter in a mailbox to send it to <context.book.nbt[Player].as_player.name>!"
        - title subtitle "<aqua>Letter created with subject <white><context.title>"
        - define title <context.title>
        - wait 1t
        - inventory adjust display_name:<blue><[title]> origin:<player.inventory> slot:<player.held_item_slot>
    on player clicks written_book in inventory:
    # When a player attempts to attach an item to a letter.
      - if <context.item.has_nbt[Player]> && <context.item.nbt[Player]> != <player.uuid> && <context.click> == RIGHT:
        - determine passively cancelled
        - define Letter <context.item>
        - define Attachment <context.cursor_item>
        - adjust <player> item_on_cursor:air
#            - inventory adjust nbt:->:Attachment/<[Attachment]> origin:<[Letter]>
#      - else if <context.item.nbt[Player].is[==].to[<player.UUID>]||false>:
#        - if <context.click> == RIGHT:
#          - if <context.cursor_item.material.name> == air:
#            - determine passively cancelled
#            - define Gift:<context.item.nbt[Attachment]>
#            - adjust <player> item_on_cursor:<[Gift]>
#            - inventory adjust nbt:<-:Attachment/<[Gift]> origin:<[Letter]>

New_Mail_Task:
  type: task
  debug: false
  script:
  # Creates the "Choose a Recipient" list.
  - inventory close
  - wait 1t
  - define Author Mailbox
  - define Title "New Mail"
  - define MailList "<list_single[<dark_green><bold>Choose A Recipient<&r><p>]>"
  - foreach <server.list_players.exclude[<player>].parse[name].alphabetical> as:Player:
    - define Hover "Click to send <[Player]> a letter!"
    - define Text <[Player]>
    - define Command "new_mail_command <[Player]>"
    - define MailList <[MailList].include_single[<&hover[<[Hover]>]><&click[/<[Command]>]><&n><[Text]><&end_click><&end_hover><&nl>]>
  - adjust <player> show_book:written_book[book=<map.with[author].as[<[Author]>].with[title].as[<[Title]>].with[pages].as[<[MailList]>]>]

Mail_Delivery:
  type: world
  debug: false
  events:
    on player closes inventory:
      - if <context.inventory.title> == Mailbox:
        - define Outgoing <context.inventory.list_contents.filter[nbt[Player].is[!=].to[<player.UUID>]]>
        - if !<[Outgoing].is_empty>:
          - inject Mailbox_Task_Send
        - else:
          - yaml id:mailboxes set inventories.<player.UUID>:<context.inventory.list_contents>
          - yaml id:mailboxes savefile:mailboxes.yml

Mailbox_Task_Send:
  type: task
  debug: false
  script:
  - foreach <[Outgoing]> as:Letter:
    - define Recipient <[Letter].nbt[Player]>
    - define Inbox <yaml[mailboxes].read[inventories.<[Recipient]>]>
    - if !<[Inbox].empty_slots.is_empty>:
      - define Inbox <[Inbox].set[<[Letter]>].at[<[Inbox].find[air]>]>
      - yaml id:mailboxes set inventories.<[Recipient]>:<[Inbox]>
      - yaml id:mailboxes savefile:mailboxes.yml
    - narrate "<aqua>Sent <blue><[Letter].book_title><aqua> to <green><[Recipient].as_player.name>"
