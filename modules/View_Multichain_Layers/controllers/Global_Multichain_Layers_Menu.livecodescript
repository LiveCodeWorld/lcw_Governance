script "Global | Multichain | Layers | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Multichain | Layers | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put the multiChain_View of tObject into multiLayerView
   return multiLayerView
end menu_Target

getprop menu_CheckTarget [mTarget]
   -- use to do initialisation
   pass menu_CheckTarget
end menu_CheckTarget


--> Global | Multichain | Layers | Menu
-
on menu_SetLabelBehaviors multiLayerView
   put the name of stack "behavior_ViewMultichainLabel" into labelBehavior
   put the name of stack "behavior_ViewMultichainLayer" into bObject
   --
   put the number of groups of multiLayerView into maxNum
   repeat with gNum = 1 to maxNum
      set the cursor to busy
      put the long id of group gNum of multiLayerView into circleView 
      
      set the behavior of circleView to bObject
      set the label_Behavior of circleView to labelBehavior
      put the result into labelButton
      set the script of labelButton to empty
   end repeat
end menu_SetLabelBehaviors

on menu_Experiment multiLayerView
   put the number of groups of multiLayerView
end menu_Experiment
