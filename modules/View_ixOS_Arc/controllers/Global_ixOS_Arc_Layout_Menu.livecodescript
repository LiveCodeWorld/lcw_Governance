script "Global | ixOS | Arc | Layout | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | ixOS | Arc | Layout | Menu
type: controller
version: 0.1


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   return the arrow_View of tObject
end menu_Target

getprop menu_CheckTarget [aView]
   return exists (aView)
end menu_CheckTarget

getprop setFrom_Param [aView]
   put the from_Name of aView into fName
   return fName
end setFrom_Param

getprop setFrom_Params [aView]
   put the card_Object of aView into cObject
   put the top_ChartNames of cObject into fNames
   return fNames
end setFrom_Params

getprop setTo_Param [aView]
   put the to_Name of aView into tName
   return tName
end setTo_Param

getprop setTo_Params [aView]
   put the card_Object of aView into cObject
   put the top_ChartNames of cObject into fNames
   return fNames
end setTo_Params

getprop fromSide_Param [aView]
   return the from_Side of aView
end fromSide_Param

getprop fromSide_Params
   return "top,bottom,left,right"
end fromSide_Params

getprop toSide_Param [aView]
   return the to_Side of aView
end toSide_Param

getprop toSide_Params
   return "left,right,-,top,bottom"
end toSide_Params


--> Global | ixOS | Arc | Layout | Menu
-
on menu_SetFrom aView, fName
   set the from_Name of aView to fName
end menu_SetFrom

on menu_SetTo aView, tName
   set the to_Name of aView to tName
end menu_SetTo

private on _
end _

on menu_FromSide aView, fSide
   set the from_Side of aView to fSide
end menu_FromSide

on menu_ToSide aView, tSide
   set the to_Side of aView to tSide
end menu_ToSide

private on __
end __

on menu_SetFromItems aView
   put the from_Items of aView into fItems
   get lcw_Ask ("Set from_Items of arrow...", fItems, "from_Items")
   set the to_Items of aView to it
end menu_SetFromItems

on menu_SetToItems aView
   put the to_Items of aView into toItems
   get lcw_Ask ("Set to_Items of arrow...", toItems, "to_Items")
   set the to_Items of aView to it
end menu_SetToItems

private on ___
end ___

on menu_Layout aView
   dispatch "LayoutControl" to aView
end menu_Layout
