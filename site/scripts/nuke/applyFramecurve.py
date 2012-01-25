# framecurve in nuke python
# for more info, see http://framecurve.org
# Framecurve scripts are subject to MIT license
# http://framecurve.org/scripts/#license

from __future__ import with_statement
import nuke, nukescripts, os, re

# On the current node, add a userknob for the framecurve
def add_framecurve(onNode):
    framecurveKnob = nuke.Double_Knob("framecurve",  "timewarp frame")
    framecurveKnob.setTooltip( "This contains the retiming framecurve animation")
    onNode.addKnob(framecurveKnob)
    onNode["framecurve"].setAnimated()
    onNode["framecurve"].setValueAt(1.0, 1)
    onNode["label"].setValue("TW to [value framecurve]")

# We want our retime knob to appear in a separate tab
def organize_retime_tab(onNode):
    pass
    
def apply_framecurve(inNode, toKnobName):
    pass
    
# This fails on Nuke < 6.3 but there ain't much we can do
def make_keyframes_linear(curve):
    for key in curve.keys():
        print key.interpolation
        key.interpolation = nuke.LINEAR

def animate_framecurve_from_file(fc_path, to_node):
    with open(fc_path) as fc_file:
        for line in fc_file:
            if line.startswith("#"):
                pass
            else:
                # Parse out the two values
                at_and_v = line.split("\t")
                at_frame, use_frame = int(at_and_v[0]), float(at_and_v[1])
                # Set the keyframe on the framecurve
                to_node["framecurve"].setValueAt(use_frame, at_frame) #, index=1, view=1)
    
    # Change the framecurve KFs to give linear interp as per spec
    make_keyframes_linear(to_node["framecurve"].animation(0))

def apply_framecurve(toNode, framecurve_path):
    if not "framecurve" in toNode.knobs():
        add_framecurve(toNode)
        organize_retime_tab(toNode)
    
    # Apply the file at path
    animate_framecurve_from_file(framecurve_path, toNode)
    
    # Couple the animations to the framecurve
    for knob_name in toNode.knobs():
        if knob_name == "framecurve":
            pass
        else:
            k = toNode.knob(knob_name)
            if k.visible() and k.isAnimated():
                # Apply the magic framecurve expr!
                k.setExpression("curve(framecurve(frame))")


def grab_file():
    return nuke.getFilename("Select the framecurve file", "*.framecurve.txt", default="/", favorites="", type="", multiple=False)

def apply_framecurve_from_file():
    # Load the animation
    framecurve_path = grab_file()
    selected = filter(lambda n: n.Class() != "Viewer" and n.name() != "VIEWER_INPUT", nuke.selectedNodes())
    for n in selected:
        apply_framecurve(n, framecurve_path)