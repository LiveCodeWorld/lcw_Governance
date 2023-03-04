script "Global | Governance | HexText | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | HexText | Menu
type: controller
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put the hexText_View of tObject into hexTextView
   return hexTextView
end menu_Target

getprop rotate_Param [hexTextView]
   put the text_Rotation of hexTextView into sDegrees
   return sDegrees -- "60"
end rotate_Param

getprop rotate_Params [hexTextView]
   return "0,60,120,180,240,300,360"
end rotate_Params

getprop show_Param [hexTextView]
   return the visible_Names of hexTextView
end show_Param

getprop show_Params [hexTextView]
   return the layer_Names of hexTextView
end show_Params

getprop checked_ShowName [hexTextView]
   return the show_Name of hexTextView
end checked_ShowName

getprop checked_Opaque [hexTextView]
   return the opaque of hexTextView
end checked_Opaque


--> Global | Governance | HexText | Menu
-
on menu_Rotate hexTextView, sDegree
   set the text_Rotation of hexTextView to sDegree
end menu_Rotate

on menu_Show hexTextView, layerName
   set the toggle_Visible of hexTextView to layerName
end menu_Show

on _
end _

on menu_ShowName hexTextView
   put the show_Name of hexTextView is false into sBoolean
   set the show_Name of hexTextView to sBoolean
end menu_ShowName

on menu_Opaque hexTextView
   put the opaque of hexTextView is false into sBoolean
   set the opaque of hexTextView to sBoolean
end menu_Opaque
