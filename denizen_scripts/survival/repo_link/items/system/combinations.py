#!/usr/bin/env python3
"""Calculates list/length of combination, if every entry was unique."""

# Initialization
de_buffs = ["melee_damage", "ranged_damage",
            "speed", "armor",
            "attack_speed", "health"]

# CALCULATIONS
"""Calculate total number of combinations, including duplicates."""
total = len(de_buffs) ** 3
print ("Total no. of combinations, including duplicates: %d" % total)
"""6^3 buffs, 216 buffs."""

"""Calculate number of combinations if length = 1, if every entry was unique. (COMMON)"""
common_total = len(de_buffs)
print("Number of combinations if length = 1: %d" % common_total)
"""6 buffs x 1 = 6."""

"""Calculate number of combinations if length = 2, if every entry was unique. (RARE)"""
rare_total = len(de_buffs) * (len(de_buffs) - 1)
print("Number of combinations if length = 2: %d" % rare_total)
"""6 buffs x 5 buffs = 30."""

"""Calculate total number of combinations, including duplicates, if every entry was unique. (UNCOMMON)"""
uncommon_total = len(de_buffs) * (len(de_buffs) - 1) * (len(de_buffs) - 2)
print ("Number of combinations if length = 3: %d" % uncommon_total)
"""6 buffs x 5 buffs x 4 debuffs = 120."""

# RARE (2)
print()
"""Create a list of duplicates if length = 2. (RARE)"""
rare_input = []
for i in de_buffs:
    l = ["melee_damage", "ranged_damage", "speed", "armor", "attack_speed", "health"]
    l.remove(i)
    for j in l:
        t = [i, j]
        rare_input.append(t)
print("List with duplicates if length = 2:")
print(rare_input)
print("Length of rare_input: %d" % len(rare_input))
"""Length of rare_input = 30."""

"""Create a de-duplicated set from the input list (of lists) above."""
rare_deduplicated = set(tuple(sorted(x)) for x in rare_input)

print("Deduplicated list of rare souls:")
print(rare_deduplicated)
print("Length of rare_deduplicated: %d" % len(rare_deduplicated))
"""Length of rare_deduplicated = 15."""

# UNCOMMON (3)
print()
"""Create a list of duplicates if length = 3. (UNCOMMON)"""
uncommon_input = []
for i in de_buffs:
    l = ["melee_damage", "ranged_damage", "speed", "armor", "attack_speed", "health"]
    l.remove(i)
    for j in l:
        l.remove(j)
        for k in l:
            t = [i, j, k]
            uncommon_input.append(t)
print("List with duplicates if length = 3:")
print(uncommon_input)
print("Length of uncommon_input: %d" % len(uncommon_input))
"""Length of uncommon_input = 54."""

"""Create a de-duplicated set from the input list (of lists) above."""
uncommon_deduplicated = set(tuple(sorted(x)) for x in uncommon_input)
print("Deduplicated list of uncommon souls:")
print(uncommon_deduplicated)
print("Length of uncommon_deduplicated: %d" % len(uncommon_deduplicated))
"""Length of uncommon_deduplicated = 20."""

with open("output.txt", "w") as f:
    # Rare
    f.write("RARE (2):\n")
    for i in sorted(rare_deduplicated):
        f.write(", ".join(i) + "\n")
    # Uncommon
    f.write("UNCOMMON (3):\n")
    for j in sorted(uncommon_deduplicated):
        f.write(", ".join(j) + "\n")

print("File output to output.txt")
