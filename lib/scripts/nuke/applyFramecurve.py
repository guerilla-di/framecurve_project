from __future__ import with_statement # Only needed in Python 2.5
import nuke, nukescripts, os, re

# On the current node, add a userknob for the framecurve
def add_framecurve(onNode):
    framecurveKnob = nuke.Double_Knob("framecurve",  "timewarp frame")
    framecurveKnob.setTooltip( "This contains the retiming framecurve animation")
    onNode.addKnob(framecurveKnob)
    onNode["framecurve"].setAnimated()
    onNode["framecurve"].setValueAt(1.0, 1)
    onNode["label"].setValue("TW to [value framecurve]")
    
def apply_framecurve(inNode, toKnobName):
    k = inNode.knob(toKnobName)
    if not k.visible() or not k.isAnimated():
        return
    # Apply the magic framecurve expr!
    k.setExpression("curve(framecurve(frame))")
    
def get_first_selected_node():
    selected = filter(lambda n: n.Class() != "Viewer" and n.name() != "VIEWER_INPUT", nuke.selectedNodes())
    if len(selected) == 0:
        raise Exception, "No nodes were selected"
    return selected[0]

def animate_framecurve_from_file(fc_path, to_node):
    with open(fc_path) as fc_file:
        for line in fc_file:
            if line.startswith("#"):
                pass
            else:
                at_and_v = line.split("\t")
                at_frame, use_frame = int(at_and_v[0]), float(at_and_v[1])
                # Set the keyframe on the framecurve
                to_node["framecurve"].setValueAt(use_frame, at_frame) #, index=1, view=1)
    
    # Change the framecurve KFs to give linear interp - TODO this doesnt work yet
    curve = to_node["framecurve"].animation(0)
    for key in curve.keys():
        print key.interpolation
        key.interpolation = nuke.LINEAR
        
# keyframe it from the framecurve file
me = get_first_selected_node()
knob_names = me.knobs()
if not "framecurve" in knob_names:
    add_framecurve(me)
    
# Couple the animations to the framecurve
for knob_name in me.knobs():
    if knob_name == "framecurve":
        pass
    else:
        apply_framecurve(me, knob_name)

# Load the animation
# framecurve_path = nuke.getFilename("Select the framecurve file", "*.framecurve.txt", default="/", favorites="", type="", multiple=False)
framecurve_path = "/test_export.framecurve.txt"

animate_framecurve_from_file(framecurve_path, me)
