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
