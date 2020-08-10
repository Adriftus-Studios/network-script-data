import os

inputdir = os.getcwd()
showfiles = "False"
outputdir = "TOC_Draft.md"

if showfiles == "Y":
    showfiles = True
else:
    showfiles = False

i = 0
length = len(tuple(os.walk(inputdir)))

def recursive(directory, string='', level=0, sf=False):
    global i
    i = i + 1
    if os.listdir(directory).count("readme.md") == 1:
        with open(directory + '\\readme.md') as readmefile:
            split = readmefile.read().split('\n')
            if len(split) > 0:
                print('haha')
                string = string + '\n' + '  ' * level + '- [' + directory.split("\\")[-1] + '](' + directory.replace(' ', '%20') + ')' + ' | ' + split[1]
            else:
                string = string + '\n' + '  ' * level + '- [' + directory.split("\\")[-1] + '](' + directory.replace(' ', '%20') + ')'
    else:
        string = string + '\n' + '  ' * level + '- [' + directory.split("\\")[-1] + '](' + directory.replace(' ', '%20') + ')'
    for d in os.listdir(directory):
        try:
            if os.path.isfile(directory + '\\' + d):
                if sf:
                    string = string + '\n' + '  ' * level + '- [' + d.split("\\")[-1] + '](' + (directory + '\\' + d).replace(' ', '%20') + ')'
            else:
                string = recursive(directory + '\\' + d, string, level+1, sf=sf)
        except:
            pass
    if (i+1) % 100 == 0:
        print("%s / %s" % (i, length))
    return string

with open(outputdir, 'w+') as txtfile:
    txtfile.write(recursive(inputdir, sf=showfiles)[1:])
