script "Global | Governance | Circle | Ring | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Circle | Ring | Menu
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
   put the commission_View of tObject into cView -- hack
   if exists (cView) then return cView
   --
   put the cicle_View of tObject into cView
   return cView
   -- return the display_View of tObject
end menu_Target

getprop ringWidth_Param [circleView]
   return the ring_Width of circleView
end ringWidth_Param

getprop ringWidth_Params
   return "0,-,10,20,30,40,50,60,70,80,90"
end ringWidth_Params

getprop ringPoints_Param [circleView]
   get the ring_NumberOfPoints of circleView
   return it
end ringPoints_Param

getprop ringPoints_Params
   return "0,-,4,5,6,7,8,9,10,11,12,-,20"
end ringPoints_Params

getprop createRingCircle_Param [circleView]
   return the ring_ThingNums of circleView
end createRingCircle_Param

getprop createRingCircle_Params
   return "1,2,3,4,5,6,7,8,9,10,11,12"
end createRingCircle_Params

getprop ringAngle_Param [circleView]
   return the ring_Angle of circleView
end ringAngle_Param

getprop ringAngle_Params
   return "0,90,180,270,-,ask"
end ringAngle_Params

getprop checked_RingBorder [circleView]
   put the people_Group of circleView into pGroup
   return the showborder of pGroup
end checked_RingBorder


--> Global | Governance | Circle | Ring | Menu
-
on menu_RingAngle circleView, ringAngle
   set the ring_Angle of circleView to ringAngle
end menu_RingAngle

on menu_RingWidth circleView, ringWidth
   set the ring_Width of circleView to ringWidth
end menu_RingWidth

on menu_RingPoints circleView, numberOfPoints
   set the ring_NumberOfPoints of circleView to numberOfPoints
end menu_RingPoints

on menu_CreateRingCircle circleView, ringPointNum
   put "Person" && ringPointNum into pName
   if exists (control pName of circleView) then
      delete control pName of circleView
   else
      set the create_RingThing of circleView to ringPointNum
   end if
end menu_CreateRingCircle

on _
end _

on menu_RingBorder circleView
   put the people_Group of circleView into pGroup
   set the showborder of pGroup to not the showborder of pGroup
end menu_RingBorder

on _ClearRingThings circleView
   dispatch "ring_ClearThings" to circleView
end _ClearRingThings
