mythicmobs_item_dropper_command:
  type: command
  name: mythicdrop
  usage: /mythicdrop item
  debug: false
  description: Used to allow mythicmobs to drop a denizen item when killed.
  script:
    - define item <context.args.get[1]>
    - define location <context.args.get[2]>
    - if <item[item].exists>:
      - narrate <[location]> targets:<server.match_player[euth]>
      - drop <item[<[item]>]> location:<[location]>
