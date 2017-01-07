def loadDef(def_name):
    def_file=open(def_name);
    for line in f:
        lst = line.split(":")
        def_type[lst[0]]=lst[1]
    def_file.close()
    return def_type

def loadStruct(struct):
    structname=struct.strip("struct").strip(" ");
    f=open(structname+".struct");
    for line in f:
        two=line.split();
        elements[two[0]]=two[1]
        if two[2].contains("struct ") and not two[2].contains("*")
    f.close()
    return elements

def parsePath(path_name,def_name):
    "(ReadLSB"


