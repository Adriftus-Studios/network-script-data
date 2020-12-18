Elevator_Command:
  type: command
  name: elevator
  debug: false
  description: Make a set of blocks go up and down
  #permission: What would the permission node be?
  usage: /elevator
  aliases:
  - elevate
  - elev
  - evator
  script:
  - if <context.args.is_empty> && <player.we_selection||null> == null || <player.we_selection.blocks.filter[material.name.is[!=].to[air]].size> == 0:
    - narrate "<&c>You've not selected a valid area to set as an elevator!"
    - stop
  - if <context.args.size> > 1:
    - narrate "<&c>Incorrect command usage!<&nl>Valid Commands:<&nl>/elevator<&nl>/elevator remove<&nl>/elevator help "
    - stop
  - choose <context.args.get[1]||empty>:
    #make a check if the elev already exists? nah
    - case Remove:
      #it's made for single elevators per server for now, but later on i was thinking players would stand on the elevator and
      #it would get the block below them to match the location to a block that's part of the elevator, finding which elevator to remove
      - if !<player.has_flag[Adriftus.HubElements.ElevatorConfirm]>:
        - narrate "<&c>Are you sure you would like to remove the elevator? You have 10 seconds to retype the command to confirm."
        - flag player Adriftus.HubElements.ElevatorConfirm duration:10s
      - else:
        - flag server Adriftus.HubElements.Elevator:!
        - narrate "<&a>Removed the hub's elevator."
    - case Help:
      - narrate "<&8><&l>-----------| <&e><&l>Elevator Command Info <&8><&l>|------------"
      - narrate "<&8>/<&e>elevator<&7> - Make the blocks selected float up and down."
      - narrate "<&8>/<&e>elevator <&b>remove<&7> - Remove the elevator you're standing on."
      - narrate "<&8>/<&e>elevator <&b>help<&7> - Open this help section."
      - narrate <&8><&l>--------------------------------------------
    - default:
      #make an extra check if block locations are overlapping and ask if they would like to override?
      #future options: when creating the elevator, set it as a name so that it can be called on later? (for having multiple elevators in a server)
      #my thoughts on ^: I dont think it'll be used that much, so although it'd be cool, i wouldnt think it's necessary
      - if <context.args.is_empty>:
        #you can change this flag if u want
        - define Blocks <player.we_selection.blocks.filter[material.name.is[!=].to[air]]>
        - if !<server.has_flag[Adriftus.HubElements.Elevator]>:
          - flag server Adriftus.HubElements.Elevator:<[Blocks]>/<[Blocks].parse[material.name]>
          - run Elevator_Command path:Elevator
        - else:
          - flag server Adriftus.HubElements.Elevator:<[Blocks]>/<[Blocks].parse[material.name]>
        - narrate "<&a>Elevator Set!"
      - else:
        - narrate "<&c>Incorrect command usage!<&nl>Valid Commands:<&nl>/elevator<&nl>/elevator remove<&nl>/elevator help "
  Elevator:
  - define BLocs <server.flag[Adriftus.HubElements.Elevator].before[/]>
  - define Mats <server.flag[Adriftus.HubElements.Elevator].after[/]>
  - define Distance 5
  - define Length <[BLocs].parse[y].numerical.reverse.first.sub[<[BLocs].parse[y].numerical.first>].add[1]>
  - while <server.has_flag[Adriftus.HubElements.Elevator]>:
    - repeat <[Distance].mul[2]> as:No:
      - foreach <[BLocs]> as:Loc:
        - define i <[Loop_Index]>
        - if <[No].is[OR_LESS].than[<[Distance]>]>:
          - define YData <[No]>/Up
        - else:
          - define YData <[Distance].mul[2].sub[<[No]>]>/Down
        - define Y <[YData].before[/]>
        - define NewLoc <[Loc].add[0,<[Y]>,0]>
        - modifyblock <[Loc].add[0,<[Y].add[<map.with[Up].as[-<[Length]>].with[Down].as[1].get[<[YData].after[/]>]>]>,0]> air
        - if <[YData].after[/]> == Up:
          - foreach <[NewLoc].find.entities.within[0.5]> as:Entity:
            - adjust <[Entity]> velocity:0,0.55,0
        - modifyblock <[NewLoc]> <[Mats].get[<[i]>]>
      - if <list[<[Distance]>|<[Distance].mul[2]>].contains[<[No]>]>:
        - wait 5s
      - wait 5t

Elevator_Start:
  type: world
  debug: false
  events:
    on server start:
    - if <server.has_flag[Adriftus.HubElements.Elevator]>:
      - run Elevator_Command path:Elevator
