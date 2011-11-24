import c4d

def main():
    # Which frame to sample. Grab this from the userattr of the tag!
    obj = op.GetObject()
    pytag = obj.GetFirstTag()
    
    # Gotcha - when rendering tags get reordered and coffee tag might not come first,
    # so walk the fucking linked list until we arrive at the tag
    # while(pytag):
    #     if(instanceof(pytag, c4d.PythonTag)):
    #         break 
    #     pytag = pytag.GetNext()
    
    # Float attr ID_USERDATA:1
    at = 5 #pytag[c4d.ID_USERDATA, 1]
    
    # Sample FPS once 
    fps = doc.GetFps()
    
    # We need to pass a BaseTime object to the track sampler
    # and we create it with the SECONDS
    seconds = at / fps
    atTime = c4d.BaseTime(seconds)
    
    # Positions
    myT = obj.GetFirstCTrack()
    posX = myT.GetValue(doc, atTime, fps)
    
    myT = myT.GetNext()
    posY = myT.GetValue(doc, atTime, fps)
    
    myT = myT.GetNext() 
    posZ = myT.GetValue(doc, atTime, fps)
    
    # Then rotations
    myT = myT.GetNext() 
    rotH = myT.GetValue(doc, atTime, fps)
    
    myT = myT.GetNext()
    rotP = myT.GetValue(doc, atTime, fps)
    
    myT = myT.GetNext() 
    rotB = myT.GetValue(doc, atTime, fps)
    
    posVec = c4d.Vector(posX, posY, posZ)
    rotVec = c4d.Vector(rotH, rotP, rotB)
    
    obj.SetRelPos(posVec)
    obj.SetRelRot(rotVec)