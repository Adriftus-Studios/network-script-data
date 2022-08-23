is_halloween:
    type: procedure
    definitions: time
    script:
    - if <[time].object_type> != Time:
        - determine ERROR_INVALID_OBJECT
    - else if <[time].is_after[<util.time_now.year>/10/30]> && <[time].is_before[<util.time_now.year>/11/1]>:
        - determine true
    - else:
        - determine false

is_christmas:
    type: procedure
    definitions: time
    script:
    - if <[time].object_type> != Time:
        - determine ERROR_INVALID_OBJECT
    - else if <[time].is_after[<util.time_now.year>/12/24]> && <[time].is_before[<util.time_now.year>/12/26]>:
        - determine true
    - else:
        - determine false

is_new_year:
    type: procedure
    definitions: time
    script:
    - if <[time].object_type> != Time:
        - determine ERROR_INVALID_OBJECT
    - else if <[time].is_after[<util.time_now.year>/12/30]> && <[time].is_before[<util.time_now.year.add[1]>/1/2]>:
        - determine true
    - else:
        - determine false

is_fourth_of_july:
    type: procedure
    definitions: time
    script:
    - if <[time].object_type> != Time:
        - determine ERROR_INVALID_OBJECT
    - else if <[time].is_after[<util.time_now.year>/7/3]> && <[time].is_before[<util.time_now.year>/7/5]>:
        - determine true
    - else:
        - determine false

is_valentines_day:
    type: procedure
    definitions: time
    script:
    - if <[time].object_type> != Time:
        - determine ERROR_INVALID_OBJECT
    - else if <[time].is_after[<util.time_now.year>/2/13]> && <[time].is_before[<util.time_now.year>/2/15]>:
        - determine true
    - else:
        - determine false