#=====================================================================#
#   CONFIG                                                            #
#=====================================================================#
# You may configure these options as indicated.
Banner_Designer_Config:
  type: data
  # Cooldown: Adjusts how long the machine will wait for confirmation before         #
  #           cancelling the save/exit sequence.                                     #
  Cooldown: 50t
  # Max_Placed: Configure how many of each banner type may be placed in the world.
  #     Base = Default amount (per plot, or per player for Personal).                #
  #     Per_Upgrade = Added to Base value per plot when an upgrade is purchased.     #
  #     Max_Upgrades = How many upgrades a Town/Nation is allowed to purchase.       #
  Max_Placed:
    Personal:
      Base: 3
    Town:
      Base: 10
      Per_Upgrade: 2
      Max_Upgrades: 10
    Nation:
      Base: 5
      Per_Upgrade: 1
      Max_Upgrades: 20
  # Token_Cost: Sets the prices of Banner_Token items at the vendor.
  #     Single = Single Use token, which produces one custom banner when saved.      #
  #     Personal = Personal Emblem token, which changes the player's custom emblem   #
  #                and updates existing personal flags around the world.             #
  #     Town = Town Flag token, which changes the player's town flag and updates     #
  #            existing town flags around the world.                                 #
  #     Nation = National Flag token, which changes the player's national flag and   #
  #              updates existing national flags around the world.                   #
  Token_Cost:
    Single: 0
    Personal: 0
    Town: 0
    Nation: 0
  # Token_Produces_Banner: If false, saving will only update existing and future     #
  #                        placed flags. If true, saving a Personal/Town/Nation      #
  #                        banner will also give the player the corresponding        #
  #                        banner item, as if purchased from the vendor.             #
  Token_Produces_Banner: false
  # Item_Cost: Sets the prices of Banner items at the vendor.                        #
  #     Blank = A blank banner of a given color.                                     #
  #     Premade = A custom, dev-made banner, for single-use.                         #
  #     Personal = A banner displaying the player's custom personal emblem.          #
  #                A limited amount can be placed in the world (see Config option).  #
  #     Town = A banner displaying the player's town's flag. Limited by Config.      #
  #     Nation = A banner displaying the player's national flag. Limited by Config.  #
  Item_Cost:
    Blank: 0
    Premade: 0
    Personal: 0
    Town: 0
    Nation: 0
  # Banner_Item_Load: If true, right clicking the display with a held banner        #
  #                   while using the banner machine will upload its contents,      #
  #                   replacing the current design.                                 #
  Banner_Item_Load: true
  # Compress_Empty_Layers: If true, empty layers on machine-created banners will    #
  #                        be removed when the design is saved, storing the banner  #
  #                        in the most efficient way. If false, blank layers will   #
  #                        be preserved, storing the banner exactly as designed.    #
  Compress_Empty_Layers: true
  # Enemies_Break_(Type): If false, only players who have ownership rights to a     #
  #                       placed banner can break it. If true, anyone who has       #
  #                       build/break permissions in the location can break these   #
  #                       banners and retrieve the associated item.                 #
  Enemies_Break_Personal: false
  Enemies_Break_Town: false
  Enemies_Break_Nation: false