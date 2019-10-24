def Remove_Whitespace(instring):
    return instring.strip()

def Replace(text,old,new):
    return text.replace(old,new)

def Contains(complete,partial):
    if ( complete.find(partial) ) != -1:
        return "True"
    else:
        return "False"