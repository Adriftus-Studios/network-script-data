Embedded_Time_Formatting:
    type: task
    debug: false
    script:
        #- define Hour <util.date.time.hour.add[4].pad_left[2].with[0]>
        #- if <[Hour]> < 24:
        #    - define HH <[Hour]>
        #- else:
        #    - define HH <element[24].sub[<[Hour]>]>
        - define HH <util.date.time.hour>

        - define Time <util.date.time.year>-<util.date.time.month.pad_left[2].with[0]>-<util.date.time.day.pad_left[2].with[0]>T<[HH]>:<util.date.time.minute.pad_left[2].with[0]>:<util.date.time.second.pad_left[2].with[0]>.000Z
