script "Global | Multichain | Layer | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Multichain | Layer | Menu
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
   put the display_View of tObject into dView
   if exists (dView) then
      put the displayed_Object of tObject into circleView
   else
      put the view_Object of tObject into circleView
   end if
   return circleView
end menu_Target

getprop setLayer_Param [circleView]
   put the multichain_LayerName of circleView into layerName
   return layerName
end setLayer_Param

getprop setLayer_Params
   return "Application,Aggregation,Execution,Relay,Core"
end setLayer_Params


--> Global | Multichain | Layer | Menu
-
on menu_SetLayer circleView, layerName
   set the multichain_LayerName of circleView to layerName
end menu_SetLayer

on menu_SetLabelBehavior circleView
   put the name of stack "behavior_ViewMultichainLabel" into bObject
   set the label_Behavior of circleView to bObject
   put the result into labelButton
   --
   edit the script of labelButton
end menu_SetLabelBehavior

