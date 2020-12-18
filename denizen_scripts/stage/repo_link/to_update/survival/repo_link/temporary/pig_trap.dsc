its_a_trap:
  type: command
  debug: false
  name: pig_trap
  permission: adriftus.admin
  usage: /pig_trap <&l>player<&gt>
  description: Pig Trap!
  script:
    - adjust <queue> linked_player:<server.match_player[<context.args.first>]>
    - adjust <player> noclip:true
    - define loc <player.location.with_pitch[0].with_yaw[<player.location.yaw.round_to_precision[90]>]>
    - showfake air <cuboid[<[loc].backward.left>|<[loc].forward.right.below[35]>].blocks> duration:15s
    - wait 15s
    - adjust <player> noclip:false
