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

private function _NameToObject aView, sName
   put the layout_View of aView into layoutView
   if exists (layoutView) is false then
      breakpoint
      return empty
   end if
   
   put the layout_ObjectArray of layoutView into oArray
   put oArray_GetElementID (sName, oArray) into shortID
   if exists (control id shortID of layoutView) then
      return the long id of control id shortID of layoutView
   else
      return empty
   end if
end _NameToObject

function oArray_GetElementID sName, oArray
   repeat for each key indexNum in oArray
      put oArray [indexNum]["name"] into testName
      if testName = sName then
         put oArray [indexNum]["id"] into shortID
         return shortID
      end if
   end repeat
   return empty
end oArray_GetElementID

getprop setFrom_Param [aView]
   put the from_Name of aView into fName
   return fName
end setFrom_Param

getprop setFrom_Params [aView]
   put the link_Names of aView into fNames
   return fNames
end setFrom_Params

getprop setTo_Param [aView]
   put the to_Name of aView into tName
   return tName
end setTo_Param

getprop setTo_Params [aView]
   put the link_Names of aView into fNames
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
   put _NameToObject (aView, fName) into fObject
   set the from_Object of aView to fObject
   --
   dispatch "LayoutControl" to aView
end menu_SetFrom

on menu_SetTo aView, tName
   put _NameToObject (aView, tName) into tObject
   set the to_Object of aView to tObject
   --
   dispatch "LayoutControl" to aView
end menu_SetTo

private on _
end _

on menu_FromSide aView, fSide
   set the from_Side of aView to fSide
   --
   dispatch "LayoutControl" to aView
end menu_FromSide

on menu_ToSide aView, tSide
   set the to_Side of aView to tSide
   --
   dispatch "LayoutControl" to aView
end menu_ToSide

private on __
end __

on menu_SetFromItems aView
   put the from_Items of aView into fItems
   get lcw_Ask ("Set from_Items of arrow...", fItems, "from_Items")
   set the to_Items of aView to it
   --
   dispatch "LayoutControl" to aView
end menu_SetFromItems

on menu_SetToItems aView
   put the to_Items of aView into toItems
   get lcw_Ask ("Set to_Items of arrow...", toItems, "to_Items")
   set the to_Items of aView to it
   --
   dispatch "LayoutControl" to aView
end menu_SetToItems

private on ___
end ___

on menu_Layout aView
   dispatch "LayoutControl" to aView
end menu_Layout
