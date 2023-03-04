script "Global | Governance | Person | Graphic | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Person | Graphic | Menu
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
   put the person_Graphic of tObject into pGraphic
   put pGraphic into LocalArray ["person_Graphic"]
   return pGraphic
end menu_Target

getprop menu_CheckTarget [pGraphic]
   return pGraphic is not empty
end menu_CheckTarget

getprop markerScale_Param [pGraphic]
   return the ring_MarkerScale of pGraphic
end markerScale_Param

getprop markerScale_Params [pGraphic]
   return "0.5,1,1.25,1.5,2,-,ask"
end markerScale_Params

getprop properties_Params
   return "View,Ring,Circle,People,-,Person"
end properties_Params


--> Global | Governance | Person | Graphic | Menu
-
on menu_Replace pGraphic
   set the control_Type of pGraphic to "View|Governance|Person"
end menu_Replace

on menu_MarkerScale pGraphic, mScale
   if mScale = "ask" then
      put the ring_MarkerScale of pGraphic into mScale
      put lcw_Ask ("Give marker a new scale...", mScale) into mScale
   end if
   set the ring_MarkerScale of pGraphic to mScale
end menu_MarkerScale

on menu_Properties pGraphic, oName
   switch oName
      case "View"
         put the circle_View of pGraphic into sObject
         break
      case "Circle"
         put the circle_Graphic of pGraphic into sObject
         break
      case "Ring"
         put the ring_Graphic of pGraphic into sObject
         break
      case "People"
         put the people_Group of pGraphic into sObject
         break
      default
         put pGraphic into sObject
   end switch
   --
   display_ObjectProperties sObject
end menu_Properties

on _
end _

on menu_SetPurple  pGraphic
   put the people_Group of pGraphic into pGroup
   --
   lock screen
   set the backgroundColor of pGroup to "94,15,142" -- purple colour_HSVToRGB ("277,89,56")
   -- set the people_Props ["backgroundColor"] of pGroup to empty -- "94,15,142"
   set the people_Props ["lineSize"] of pGroup to 1 -- "94,15,142"
   set the ring_NumberOfPoints of pGraphic to 20
   unlock screen
end menu_SetPurple

on menu_SetBrown  pGraphic
   put the people_Group of pGraphic into pGroup
   --
   lock screen
   set the backgroundColor of pGroup to blue -- "94,15,142" -- purple colour_HSVToRGB ("277,89,56")
   set the people_Props ["lineSize"] of pGroup to 1 -- "94,15,142"
   set the people_Props ["backgroundColor"] of pGroup to empty
   set the ring_NumberOfPoints [pi] of pGraphic to 5
   unlock screen
end menu_SetBrown

on menu_Rename pGraphic
   put the label of pGraphic into pLabel
   put lcw_Ask ("Give initials and appoint a person to this post...", pLabel) into newLabel
   set the label of pGraphic to newLabel
   set the showname of pGraphic to true
end menu_Rename
