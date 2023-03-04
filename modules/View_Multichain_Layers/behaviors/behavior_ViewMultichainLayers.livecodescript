script "behavior_ViewMultichainLayers"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewMultichainLayers
type: behavior
version: 0.1

/*
Here you make make notes as a basic form of help for this view.
Full help text can be found on the linked wiki for the view.
*/

--> Variables
-
local LocalArray


--> Working on
-
getprop ring_Height [squareRect]
   put the rect of the target into squareRect
   _SetMultiChainHeights squareRect, ringH, centreD
   return ringH
end ring_Height


--> Events
-
on resizeControl
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl


--> Events | Custom
-
on refreshDisplay
   put the rect of me into viewRect
   LayoutControl viewRect
end refreshDisplay

command LayoutControl pRect
   local squareRect, centreLoc, ringH, centreD, layerNum, newRect
   
   lock screen
   if pRect is empty then put the rect of me into pRect
   
   put rect_GetSquare (pRect) into squareRect
   put rect_GetCentre (squareRect) into centreLoc
   
   # Fixed ringH based on this squareRect
   _SetMultiChainHeights squareRect, ringH, centreD
   --
   put the number of groups of me into maxNum
   repeat with layerNum = 1 to maxNum
      put the long id of group layerNum of me into circleGroup
      --
      -- put _MultiChainCircleRect (layerNum, squareRect, centreLoc, ringH, centreD) into newRect
      switch layerNum
         case 1
            set the circle_Rect [ringH] of circleGroup to squareRect
            break
         case 5
            put rect_LocWidthHeight (centreLoc, centreD, centreD) into centreRingRect
            put centreRingRect into newRect
            set the circle_Rect [ringH] of circleGroup to newRect
            set the title_Top of circleGroup to false -- hack to reshow
            break
         default
            put (layerNum - 1) * ringH into shrinkBit
            put rect_SimpleSubtract (squareRect, shrinkBit) into newRect
            set the circle_Rect [ringH] of circleGroup to newRect
      end switch
   end repeat
   --
   unlock screen
   return newRect
end LayoutControl

private command _SetMultiChainHeights squareRect, @ringH, @centreD
   put item 4 of squareRect - item 2 of squareRect into circleH
   put 9.5/90 * circleH into ringH -- should be 10
   put 14/90 * circleH into centreD
   return circleH
end _SetMultiChainHeights


--> Deps | Geometry
-
function rect_SimpleSubtract someRect, sNum
   add sNum to item 1 of someRect
   add sNum to item 2 of someRect
   subtract sNum from item 3 of someRect
   subtract sNum from item 4 of someRect
   --
   return someRect
end rect_SimpleSubtract


--> Objects
-
getprop multiChain_View
   return the long id of me
end multiChain_View

getprop view_Object
   return the long id of me
end view_Object
