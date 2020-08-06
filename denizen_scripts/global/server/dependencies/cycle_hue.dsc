cycle_hue:
    type: procedure
    definitions: color|int
    script:
        - define r <[color].red>
        - define g <[color].green>
        - define b <[color].blue>
        
        - if <[Int].exists>:
            - define i <element[1530].div[<[int]>].round_up>
        - else:
            - define i 45
        - if <[r]> == 255 && <[b]> == 0 && <[g]> != 255:
            - define g <[g].add[<[i]>].min[255]>
        - else if <[g]> == 255 && <[b]> == 0 && <[r]> != 0:
            - define r <[r].sub[<[i]>].max[0]>
        - else if <[r]> == 0 && <[g]> == 255 && <[b]> != 255:
            - define b <[b].add[<[i]>].min[255]>
        - else if <[r]> == 0 && <[b]> == 255 && <[g]> != 0:
            - define g <[g].sub[<[i]>].max[0]>
        - else if <[b]> == 255 && <[g]> == 0 && <[r]> != 255:
            - define r <[r].add[<[i]>].min[255]>
        - else if <[r]> == 255 && <[g]> == 0 && <[b]> != 0:
            - define b <[b].sub[<[i]>].max[0]>
        
        - determine <color[<[r]>,<[g]>,<[b]>]>
