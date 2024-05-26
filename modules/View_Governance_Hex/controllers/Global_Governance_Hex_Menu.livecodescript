script "Global | Governance | Hex | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Hex | Menu
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
   put display_MenuTarget (tObject) into hexView
   -- put the display_View of tObject into hexView
   return hexView
end menu_Target

getprop menu_CheckTarget [hexView]
   return exists (hexView)
end menu_CheckTarget

getprop checked_NodesVisible [hexView]
   return the node_Visible of hexView 
end checked_NodesVisible


--> Global | Governance | Hex | Menu
-
on menu_AnimateSpinFast hexView
   dispatch "animate_SpinFast" to hexView
end menu_AnimateSpinFast

on menu_AnimateToOne hexView
   dispatch "animate_ToOne" to hexView
end menu_AnimateToOne

private on _
end _

on menu_AnimateToCentre hexView
   dispatch "animate_ToCentre" to hexView
end menu_AnimateToCentre

on menu_AnimateToEdge hexView
   dispatch "animate_ToEdge" to hexView
end menu_AnimateToEdge

private on __
end __

on menu_NodesVisible hexView
   set the node_Visible of hexView to not the node_Visible of hexView 
end menu_NodesVisible

on submenu_Dev
   return menu_DevTitle ("Global | Governance | Hex | Menu")
end submenu_Dev
