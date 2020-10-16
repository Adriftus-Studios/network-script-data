World_Edit_Selector:
    type: item
    debug: false
    material: golden_axe
    display name: <&6>C<&e>onstructor <&6>A<&e>xe
    mechanisms:
        hides: all
    unbreakable: true
    lore:
        - <&3>M<&b>ode<&3>: <&2>[<&a>Selection<&2>]
    

BehrEdit_Wand:
    type: command
    name: behreditwand
    usage: /behreditwand
    description: Gives you the BehrEdit wand
    permission: Behrry.Constructor.BehreditWand
    script:
    - give World_Edit_Selector
