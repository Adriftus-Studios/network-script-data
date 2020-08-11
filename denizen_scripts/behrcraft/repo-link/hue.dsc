actionbartest:
    type: task
    script:
        - define 1 "hello world"
        - define color <color[255,0,0]>
        - repeat 100:
            - actionbar <[1].color[<[color]>]>
            - wait .02t
            - define color <proc[cycle_hue].context[<[color]>]>
        - repeat 100:
            - actionbar <[1].color[<[color]>]>
            - wait .02t
            - define color <proc[cycle_hue].context[<[color]>]>

#@cycle_hue:
#@    type: procedure
#@    definitions: color
#@    script:
#^        - define r <[color].red>
#^        - define g <[color].green>
#^        - define b <[color].blue>
#^        - if <[r]> == 255 && <[b]> == 0 && <[g]> != 255:
#^            - define g <[g].add[15].min[255]>
#^        - else if <[g]> == 255 && <[b]> == 0 && <[r]> != 0:
#^            - define r <[r].sub[15].max[0]>
#^        - else if <[r]> == 0 && <[g]> == 255 && <[b]> != 255:
#^            - define b <[b].add[15].min[255]>
#^        - else if <[r]> == 0 && <[b]> == 255 && <[g]> != 0:
#^            - define g <[g].sub[15].max[0]>
#^        - else if <[b]> == 255 && <[g]> == 0 && <[r]> != 255:
#^            - define r <[r].add[15].min[255]>
#^        - else if <[r]> == 255 && <[g]> == 0 && <[b]> != 0:
#^            - define b <[b].sub[15].max[0]>
#^        - determine <color[<[r]>,<[g]>,<[b]>]>

#@cycle_hue:
#@    type: procedure
#@    definitions: color|int|sat
#@    script:
#^        - define r <[color].red>
#^        - define g <[color].green>
#^        - define b <[color].blue>
#^        - if <[Int]||null> != null:
#^            - define i <element[1530].div[<[int]>].round_up>
#^        - else:
#^            - define i 45
#^        - if <[r]> == 255 && <[b]> == 0 && <[g]> != 255:
#^            - define g <[g].add[<[i]>].min[255]>
#^        - else if <[g]> == 255 && <[b]> == 0 && <[r]> != 0:
#^            - define r <[r].sub[<[i]>].max[0]>
#^        - else if <[r]> == 0 && <[g]> == 255 && <[b]> != 255:
#^            - define b <[b].add[<[i]>].min[255]>
#^        - else if <[r]> == 0 && <[b]> == 255 && <[g]> != 0:
#^            - define g <[g].sub[<[i]>].max[0]>
#^        - else if <[b]> == 255 && <[g]> == 0 && <[r]> != 255:
#^            - define r <[r].add[<[i]>].min[255]>
#^        - else if <[r]> == 255 && <[g]> == 0 && <[b]> != 0:
#^            - define b <[b].sub[<[i]>].max[0]>
#^        - determine <color[<[r]>,<[g]>,<[b]>]>
