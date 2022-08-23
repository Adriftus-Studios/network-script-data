
quaternion_from_euler:
  type: procedure
  # locationtag
  definitions: euler
  debug: false
  script:
  - define var1 <[euler].x.mul[0.5].cos>
  - define var3 <[euler].y.mul[-0.5].cos>
  - define var5 <[euler].z.mul[0.5].cos>
  - define var7 <[euler].x.mul[0.5].sin>
  - define var9 <[euler].y.mul[-0.5].sin>
  - define var11 <[euler].z.mul[0.5].sin>
  - define var13 <[var1].mul[<[var3]>].mul[<[var5]>].mul[<[var7]>].mul[<[var9]>].mul[<[var11]>]>
  - define x <[var7].mul[<[var3]>].mul[<[var5]>].add[<[var1].mul[<[var9]>].mul[<[var11]>]>]>
  - define y <[var1].mul[<[var9]>].mul[<[var5]>].sub[<[var7].mul[<[var3]>].mul[<[var11]>]>]>
  - define z <[var1].mul[<[var3]>].mul[<[var11]>].add[<[var7].mul[<[var9]>].mul[<[var5]>]>]>
  # determine scalar | vector
  - determine <list[<[var13]>|<location[<[x]>,<[y]>,<[z]>]>]>

quaternion_to_euler:
  type: procedure
  # double | locationtag
  definitions: scalar|vector
  debug: false
  script:
  - define var1 <[vector].x>
  - define var3 <[vector].y>
  - define var5 <[vector].z>
  - define var7 <[scalar]>
  - define var9 <[var1].mul[2]>
  - define var11 <[var3].mul[2]>
  - define var13 <[var5].mul[2]>
  - define var15 <[var1].mul[<[var9]>]>
  - define var17 <[var1].mul[<[var11]>]>
  - define var19 <[var1].mul[<[var13]>]>
  - define var21 <[var3].mul[<[var11]>]>
  - define var23 <[var3].mul[<[var13]>]>
  - define var25 <[var5].mul[<[var13]>]>
  - define var27 <[var7].mul[<[var9]>]>
  - define var29 <[var7].mul[<[var11]>]>
  - define var31 <[var7].mul[<[var13]>]>
  - define var39 <element[1.0].sub[<[var21].add[<[var25]>]>]>
  - define var41 <[var17].sub[<[var31]>]>
  - define var43 <[var19].add[<[var29]>]>
  - define var45 <element[1.0].sub[<[var15].add[<[var25]>]>]>
  - define var47 <[var23].sub[<[var27]>]>
  - define var49 <[var23].add[<[var27]>]>
  - define var51 <element[1.0].sub[<[var15].add[<[var21]>]>]>
  - define var35 <[var43].max[1].min[-1].asin>
  - if <[var43].abs> < 0.99999:
    - define var33 <[var47].mul[-1].atan2[<[var51]>]>
    - define var37 <[var41].mul[-1].atan2[<[var39]>]>
  - else:
    - define var33 <[var49].atan2[<[var45]>]>
    - define var37 0
  # determine euler
  - determine <location[<[var33]>,<[var35].mul[-1]>,<[var37]>]>

quaternion_multiply:
  type: procedure
  # double | locationtag | double | locationtag
  definitions: q1_scalar|q1_vector|q2_scalar|q2_vector
  debug: false
  script:
  - define var2 <[q1_vector].x>
  - define var4 <[q1_vector].y>
  - define var6 <[q1_vector].z>
  - define var8 <[q1_scalar]>
  - define var10 <[q2_vector].x>
  - define var12 <[q2_vector].y>
  - define var14 <[q2_vector].z>
  - define var16 <[q2_scalar]>
  - define var18 <[var8].mul[<[var16]>].sub[<[var2].mul[<[var10]>]>].sub[<[var4].mul[<[var12]>]>].sub[<[var6].mul[<[var14]>]>]>
  - define x <[var2].mul[<[var16]>].add[<[var8].mul[<[var10]>]>].add[<[var4].mul[<[var14]>]>].sub[<[var6].mul[<[var12]>]>]>
  - define y <[var4].mul[<[var16]>].add[<[var8].mul[<[var12]>]>].add[<[var6].mul[<[var10]>]>].sub[<[var2].mul[<[var14]>]>]>
  - define z <[var6].mul[<[var16]>].add[<[var8].mul[<[var14]>]>].add[<[var2].mul[<[var12]>]>].sub[<[var4].mul[<[var10]>]>]>
  # determine scalar | vector
  - determine <list[<[var18]>|<location[<[x]>,<[y]>,<[z]>]>]>

quaternion_dot:
  type: procedure
  # double | locationtag | double | locationtag
  definitions: q1_scalar|q1_vector|q2_scalar|q2_vector
  debug: false
  script:
  - determine <[q1_scalar].mul[<[q2_scalar]>].add[<[q1_vector].x.mul[<[q2_vector].x>].add[<[q1_vector].y.mul[<[q2_vector].y>]>].add[<[q1_vector].z.mul[<[q2_vector].z>]>]>]>

quaternion_add:
  type: procedure
  # double | locationtag | double | locationtag
  definitions: q1_scalar|q1_vector|q2_scalar|q2_vector
  debug: false
  script:
  - define var2 <[q1_vector].x>
  - define var4 <[q1_vector].y>
  - define var6 <[q1_vector].z>
  - define var8 <[q1_scalar]>
  - define var10 <[q2_vector].x>
  - define var12 <[q2_vector].y>
  - define var14 <[q2_vector].z>
  - define var16 <[q2_scalar]>
  - define x <[var2].add[<[var10]>]>
  - define y <[var4].add[<[var12]>]>
  - define z <[var6].add[<[var14]>]>
  - define scalar <[var8].add[<[var16]>]>
  - determine <list[<[scalar]>|<location[<[x]>,<[y]>,<[z]>]>]>

quaternion_subtract:
  type: procedure
  # double | locationtag | double | locationtag
  definitions: q1_scalar|q1_vector|q2_scalar|q2_vector
  debug: false
  script:
  - define var2 <[q1_vector].x>
  - define var4 <[q1_vector].y>
  - define var6 <[q1_vector].z>
  - define var8 <[q1_scalar]>
  - define var10 <[q2_vector].x>
  - define var12 <[q2_vector].y>
  - define var14 <[q2_vector].z>
  - define var16 <[q2_scalar]>
  - define x <[var2].sub[<[var10]>]>
  - define y <[var4].sub[<[var12]>]>
  - define z <[var6].sub[<[var14]>]>
  - define scalar <[var8].sub[<[var16]>]>
  
  - determine <list[<[scalar]>|<location[<[x]>,<[y]>,<[z]>]>]>

euler_combine:
  type: procedure
  definitions: euler1|euler2
  debug: false
  script:
  - determine <proc[quaternion_to_euler].context[<proc[quaternion_multiply].context[<proc[quaternion_from_euler].context[<[euler1]>]>|<proc[quaternion_from_euler].context[<[euler2]>]>]>]>

euler_lerp:
  type: procedure
  definitions: euler1|euler2|scalar
  debug: false
  script:
  - define x <proc[internal_lerp].context[<[euler1].x>|<[euler2].x>|<[scalar]>]>
  - define y <proc[internal_lerp].context[<[euler1].y>|<[euler2].y>|<[scalar]>]>
  - define z <proc[internal_lerp].context[<[euler1].z>|<[euler2].z>|<[scalar]>]>
  - determine <location[<[x]>,<[y]>,<[z]>]>

internal_lerp:
  type: procedure
  definitions: var0|var2|var4
  debug: false
  script:
  - determine <element[<element[1.0].sub[<[var4]>]>].mul[<[var0]>].add[<[var4].mul[<[var2]>]>]>

euler_spline_lerp:
  type: procedure
  definitions: euler1|euler2|euler3|euler4|scalar
  debug: false
  script:
  - define var6 0
  - define var8 1
  - define var10 2
  - define var12 3
  - define var14 <[scalar].add[1]>
  - define var16a <[euler1].mul[<element[<[var8].sub[<[var14]>]>].div[<[var8].sub[<[var6]>]>]>]>
  - define var16b <[euler2].mul[<element[<[var14].sub[<[var6]>]>].div[<[var8].sub[<[var6]>]>]>]>
  - define var16 <[var16a].add[<[var16b]>]>
  - define var17a <[euler1].mul[<element[<[var10].sub[<[var14]>]>].div[<[var10].sub[<[var8]>]>]>]>
  - define var17b <[euler2].mul[<element[<[var14].sub[<[var8]>]>].div[<[var10].sub[<[var8]>]>]>]>
  - define var17 <[var17a].add[<[var17b]>]>
  - define var18a <[euler1].mul[<element[<[var12].sub[<[var14]>]>].div[<[var12].sub[<[var10]>]>]>]>
  - define var18b <[euler2].mul[<element[<[var14].sub[<[var10]>]>].div[<[var12].sub[<[var10]>]>]>]>
  - define var18 <[var18a].add[<[var18b]>]>
  - define var19a <[euler1].mul[<element[<[var10].sub[<[var14]>]>].div[<[var10].sub[<[var6]>]>]>]>
  - define var19b <[euler2].mul[<element[<[var14].sub[<[var6]>]>].div[<[var10].sub[<[var6]>]>]>]>
  - define var19 <[var19a].add[<[var19b]>]>
  - define var20a <[euler1].mul[<element[<[var12].sub[<[var14]>]>].div[<[var12].sub[<[var8]>]>]>]>
  - define var20b <[euler2].mul[<element[<[var14].sub[<[var8]>]>].div[<[var12].sub[<[var8]>]>]>]>
  - define var20 <[var20a].add[<[var20b]>]>
  - define var21 <element[<[var10].sub[<[var14]>]>].div[<[var10].sub[<[var8]>]>]>
  - define var22 <element[<[var14].sub[<[var8]>]>].div[<[var10].sub[<[var8]>]>]>
  - determine <[var19].mul[<[var21]>].add[<[var20].mul[<[var22]>]>]>

quaternion_slerp:
  type: procedure
  # double | locationtag | double | locationtag
  definitions: q1_scalar|q1_vector|q2_scalar|q2_vector|scalar
  debug: false
  script:
  - define var6 <proc[quaternion_dot].context[<[q1_scalar]>|<[q1_vector]>|<[q2_scalar]>|<[q2_vector]>]>
  - if <[var6]> < 0:
    - define q2_scalar <[q2_scalar].mul[-1]>
    - define q2_vector <[q2_vector].mul[-1]>
    - define var6 <[var6].mul[-1]>
  - if <[var6]> > 0.9995:
    - define m <element[1].sub[<[scalar]>]>
    - define q1_scalar <[q1_scalar].mul[<[m]>]>
    - define q1_vector <[q1_vector].mul[<[m]>]>
    - define q2_scalar <[q2_scalar].mul[<[scalar]>]>
    - define q2_vector <[q2_vector].mul[<[scalar]>]>
  - else:
    - define var8 <[var6].acos>
    - define var10 <[var8].sin>
    - define var12 <element[<element[1].sub[<[scalar]>]>].mul[<[var8]>]>
    - define var14 <[scalar].mul[<[var8]>].sin>
    - define m <[var12].div[<[var10]>]>
    - define q1_scalar <[q1_scalar].mul[<[m]>]>
    - define q1_vector <[q1_vector].mul[<[m]>]>
    - define m <[var14].div[<[var10]>]>
    - define q2_scalar <[q2_scalar].mul[<[m]>]>
    - define q2_vector <[q2_vector].mul[<[m]>]>
  - define var16 <proc[quaternion_add].context[<[q1_scalar]>|<[q1_vector]>|<[q2_scalar]>|<[q2_vector]>]>
  - define var16 <proc[quaternion_normalize].context[<[var16]>]>
  - determine <[var16]>

quaternion_normalize:
  type: procedure
  # double | locationtag
  definitions: scalar|vector
  debug: false
  script:
  - define var1 <element[<[scalar].mul[2]>].add[<[vector].x.mul[2]>].add[<[vector].y.mul[2]>].add[<[vector].z.mul[2]>]>
  - define scalar <[scalar].div[<[var1]>]>
  - define vector <[vector].mul[<element[1.0].div[<[var1]>]>]>
  - determine <list[<[scalar]>|<[vector]>]>

quaternion:
    type: custom
    x: 0
    y: 0
    z: 0
    scalar: 1
    tags:
        normalize:
        - define scalar <context.this.scalar>
        - define vector <context.this.as_location>
        - define result <proc[quaternion_normalize].context[<[scalar]>|<[vector]>]>
        - determine <custom_object[quaternion[x=<[result].get[2].x>;y=<[result].get[2].y>;z=<[result].get[2].z>;scalar=<[result].get[1]>]]>
        as_location:
        - determine <location[<context.this.x>,<context.this.y>,<context.this.z>]>