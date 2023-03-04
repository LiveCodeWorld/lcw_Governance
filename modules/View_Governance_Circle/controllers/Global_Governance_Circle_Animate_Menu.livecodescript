script "Global | Governance | Circle | Animate | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Governance | Circle | Animate | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
on menu_Init tObject
   -- called only once for top menu
  pass menu_Init
end menu_Init

getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   -- use to do initialisation
   pass menu_CheckTarget
end menu_CheckTarget

function _GetPathStart
   put the long id of grc "Path" into pathGraphic
   put the points of pathGraphic into pathPoints
   put line 1 of pathPoints into pathStart
   return pathStart
end _GetPathStart

command createBall pSpeed, pColour
   if pSpeed is empty then put 1 into pSpeed
   if pColour is empty then put colour_GetRandom() into pColour
   --
   put _GetPathStart() into pathStart
   
   set the backgroundcolor of the templategraphic to pColour
   set the style of the templategraphic to "oval"
   set the width of the templategraphic to "20"
   set the height of the templategraphic to "20"
   set the location of the templategraphic to pathStart
   set the opaque of the templategraphic to "true"
   --
   create graphic ballName
   put it into newBall
   set the behavior of newBall to the long id of btn "Ball Behavior"
   --
   set the movepolygonal ["currentpoints"] of newBall to pathPoints
   set the movepolygonal ["step"] of newBall to pSpeed
   --
   set the layermode of newBall to "dynamic"
   --
   return newBall
end createBall

function colour_GetRandom
   -- was "randomColour"
   put random(255) into item 1 of someColour
   put random(255) into item 2 of someColour
   put random(255) into item 3 of someColour
   return someColour
end colour_GetRandom

on hereWeGo
   send movePolygonal to grc "myGraphic"
   if the flag of me then
      send "hereWeGo" to me in 20 milliseconds
   end if
end hereWeGo

on hereWeGo
   if the movePolygonal["moveDone"] of me is true then
      set the loc of me to the movePolygonal["endpoint"] of me
      set the movePolygonal["moveDone"] of me to false
      --
      put the long id of me into ballGraphic
      send "delete ballGraphic" to me in 2 ticks
   else if the flag of me is not false then
      send movePolygonal to me
      send hereWeGo to me in 5 milliseconds
   end if
end hereWeGo


--> Global | Governance | Circle | Animate | Menu
-
on menu_Animate
   send movePolygonal to grc "myGraphic"
   if the flag of me then
      send "hereWeGo" to me in 20 milliseconds
   end if
end menu_Animate

