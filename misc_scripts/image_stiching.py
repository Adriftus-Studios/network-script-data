import os, itertools
from PIL import Image

arr = []
for x in os.listdir("images"):
    subdir = []
    for y in os.listdir("images/" + x):
        subdir.append(Image.open("images/" + x + '/' + y))
    arr.append(subdir)

for n, combo in enumerate(list(itertools.product(*arr))):
    im = Image.new('RGBA', (64, 64))
    for i in combo:
        im = Image.alpha_composite(im, i)
    im.save("output/%s.png" % n)
