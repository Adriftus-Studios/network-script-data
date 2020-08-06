Embedded_Color_Formatting:
    type: task
    debug: false
    speed: 0
    script:
        - if <[Color].exists>:
            - define Color <script[DDTBCTY].data_key[Colors.<[Color]>]||0>
