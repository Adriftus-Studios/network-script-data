Yayap_DCommand:
    type: task
    definitions: Channel
    debug: false
    script:
        - define Rando <util.random.int[2].to[8]>
        - define string <element[].pad_left[<[Rando]>].with[<&chr[6969]>].replace[<&chr[6969]>].with[<&lt>a:dancey:623960605300228122<&gt>]>
        - discord id:AdriftusBot message channel:<[Channel]> "<[String]> YAY! <[String]>"
