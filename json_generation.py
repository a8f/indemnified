import json

def generate(string: str, use_btype: bool = True):#, manufacturer: str, btype: str):
    global manufacturer, btype
    items = [i.rstrip().lstrip() for i in string.split(',')]
    objects = '{"manufacturer": "%s"%s, "model": "%s"}, ' % (manufacturer, ', "type": "' + btype + '"' if use_btype else '', items[0])
    for i in items[:-1]:
        objects += '{"manufacturer": "%s"%s, "model": "%s"}, ' % (manufacturer, ', "type": "' + btype + '"' if use_btype else '', i)
    return objects
