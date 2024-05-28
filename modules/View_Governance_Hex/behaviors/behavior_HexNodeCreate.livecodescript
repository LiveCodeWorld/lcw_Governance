script "behavior_HexNodeCreate"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_HexNodeCreate
type: behavior
version: 0.1

/*
We use this behavior to create and destroy nodes.
*/


--> Working on
-
setprop node_Points nodeNum
   lock screen
   repeat with pNum = 1 to nodeNum
      put the node_Object [pNum] of me into nodeObject
      if exists (nodeObject) then
         hex_ResetNode pNum, nodeObject
      else
         create_Node pNum
      end if
   end repeat
   unlock screen
end node_Points


--> Create
-
command create_Node nodeNum
   put "Node" && nodeNum into nodeName
   put the node_Rect [nodeNum] of me into nodeRect
   
   # Fixed
   set the style of the templategraphic to "oval"
   set the showname of the templategraphic to true
   set the opaque of the templategraphic to true
   
   # Node specific
   set the label of the templategraphic to nodeNum
   set the rect of the templategraphic to nodeRect
   set the backgroundcolor of the templategraphic to _NodeColour(nodeNum)
   
   # Create
   lock screen
   create graphic nodeName in me
   put it into nodeObject
   -- set the rect of newNode to nodeRect
   unlock screen
   
   return nodeObject
end create_Node
