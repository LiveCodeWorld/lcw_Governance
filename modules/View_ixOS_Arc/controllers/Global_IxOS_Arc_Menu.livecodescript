script "Global | IxOS | Arc | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Arc | Menu
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
   return the arrow_View of tObject
end menu_Target

getprop menu_CheckTarget [aView]
   return exists (aView)
end menu_CheckTarget

getprop checked_StartArrow [aView]
   return the startArrow of aView
end checked_StartArrow

getprop checked_EndArrow [aView]
   return the endArrow of aView
end checked_EndArrow

getprop checked_BallStopped [aView]
   return the ball_Stopped of aView
end checked_BallStopped


--> Global | IxOS | Arc | Menu
-
on menu_AnimateBall aView
   put the points of aView into pathPoints
   put the card_Object of aView into cardObject
   
   set the ball_Path ["2,30"] of cardObject to pathPoints
   put the result into newBall
   --
   ball_PathAnimate newBall
end menu_AnimateBall

on menu_BallStopped aView
   put the ball_Stopped of aView into sBoolean
   set the ball_Stopped of aView to (sBoolean is false)
end menu_BallStopped

private on _
end _

on menu_LineSize aView
   put the lineSize of aView into someNum
   put lcw_Ask ("Set the linesize...", someNum) into someNum
   set the lineSize of aView to someNum
end menu_LineSize

on menu_StartArrow aView
   put the startArrow of aView into sBoolean
   set the startArrow of aView to (sBoolean is false)
end menu_StartArrow

on menu_EndArrow aView
   put the endArrow of aView into sBoolean
   set the endArrow of aView to (sBoolean is false)
end menu_EndArrow

private on __
end __

on submenu_Layout
   return "Global | ixOS | Arc | Layout | Menu"
end submenu_Layout

on submenu_Test
   return "Global | ixOS | Arc | Dev | Menu"
end submenu_Test
