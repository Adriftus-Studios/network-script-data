hex:
    type: procedure
    definitions: rgb
    script:
        - define hexgraph <map[0/0|1/1|2/2|3/3|4/4|5/5|6/6|7/7|8/8|9/9|10/a|11/b|12/c|13/d|14/e|15/f]>
        - foreach <[rgb].split[,]> as:c:
            - define hex:->:<[hexgraph].get[<[c].div[16].round_down>]><[hexgraph].get[<[c].mod[16]>]>
        - determine #<[hex].unseparated>
