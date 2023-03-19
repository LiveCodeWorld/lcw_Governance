script "behavior_ViewixOSArc"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOSArc
type: behavior
version: 0.2


--> Working on
-
private function _FromView fromName
   put the from_Object of me into fromObject
   if exists (fromObject) then return fromObject
   
   # Legacy Code
   if exists (group fromName) then
      return the long id of group fromName
   else
      return empty
   end if
end _FromView

private function _ToView toName
   put the to_Object of me into toObject
   if exists (toObject) then return toObject
   
   # Legacy Code
   if exists (group toName) then
      return the long id of group toName
   else
      return empty
   end if
end _ToView

getprop from_Object
   return the arrow_Array ["from_Object"] of me
end from_Object

setprop from_Object fromObject
   if exists (fromObject) is false then return empty
   
   put the rugged_ID of fromObject into rObject
   set the arrow_Array ["from_Object"] of me to rObject
   --
   put the short name of fromObject into fromName
   set the from_Name of me to fromName
end from_Object

getprop to_Object
   return the arrow_Array ["to_Object"] of me
end to_Object

setprop to_Object toObject
   if exists (toObject) is false then return empty
   
   put the rugged_ID of toObject into rObject
   set the arrow_Array ["to_Object"] of me to rObject
   --
   put the short name of toObject into toName
   set the to_Name of me to toName
end to_Object

getprop from_Name
   return the arrow_Array ["from_Name"] of me
end from_Name

setprop from_Name fromName
   set the arrow_Array ["from_Name"] of me to fromName
end from_Name

getprop to_Name
   return the arrow_Array ["to_Name"] of me
end to_Name

setprop to_Name toName
   set the arrow_Array ["to_Name"] of me to toName
end to_Name


--> Events
-
on mouseDown pButtonNumber
   put the behavior of me into bObject
   if exists (bObject) is false then
      breakpoint
   end if
   set the behavior of me to bObject
   
   switch pButtonNumber
      case 3
         put menu_GetGlobalButton() into mButton
         mArray_PopUp "Global | IxOS | Arc | Menu", mButton
         break
      default
         pass mouseDown
   end switch
end mouseDown

on mouseUp
   arrow_AnimateBall true
   pass mouseUp
end mouseUp

on arrow_AnimateBall pReverse
   put the points of me into pathPoints
   if pReverse is not false then
      put index_Reverse (pathPoints) into pathPoints
   end if
   put the card_Object of me into cardObject
   --
   set the ball_Path ["3"] of cardObject to pathPoints
   put the result into newBall
   --
   ball_PathAnimate newBall
   return newBall
end arrow_AnimateBall

function index_Reverse sIndex
   repeat for each line sLine in sIndex
      put sLine & CR before rIndex
   end repeat
   delete char - 1 of rIndex
   return rIndex
end index_Reverse
   
on resizeControl
   LayoutControl
end resizeControl

command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   --
   -- set the rect of me to pRect
   --
   put the arrow_Data of me into arrowData
   set the arrow_PointLink of me to arrowData
end LayoutControl


--> Points
-
getprop arrow_NameLink
   put the from_Name of me into fromName
   put the from_Items of me into fItems
   put the to_Name of me into toName
   put the to_Items of me into tItems
   --
   put _ConstructItems (fromName, fItems, toName, tItems) into nameLink
   return nameLink
end arrow_NameLink

setprop arrow_PointLink pNameLink
   put _ConstructArrowPoints (pNameLink) into arrowPoints
   if arrowPoints is empty then return empty
   set the points of me to arrowPoints
   return arrowPoints
end arrow_PointLink


--> Geometry
-
getprop arrow_PointsWidth
   put the width of me into aWidth
   put the lineSize of me into aLineSize
   put aWidth + aLineSize into cWidth
   return cWidth
end arrow_PointsWidth


--> Props | Compound
-
getprop arrow_Data
   set the customPropertySet of me to "arrow_Array"
   put the customproperties of me into arrowData
   set the customPropertySet of me to empty
   return arrowData
end arrow_Data

getprop from_Items
   put the from_Side of me into fItems
   put the from_StepNum of me into item 2 of fItems
   put the from_SliceNum of me into item 3 of fItems
   return fItems
end from_Items

setprop from_Items [pFromName] fItems  
   _NormaliseItems fItems
   if the result is false then return empty
   
   set the from_Side of me to item 1 of fItems
   set the from_StepNum of me to item 2 of fItems
   set the from_SliceNum of me to item 3 of fItems
   --
   if pFromName is not empty then
      set the from_Name of me to pFromName
   end if
   return fItems
end from_Items

getprop to_Items
   put the to_Side of me into tItems
   put the to_StepNum of me into item 2 of tItems
   put the to_SliceNum of me into item 3 of tItems
   return tItems
end to_Items

setprop to_Items [pToName] tItems
   _NormaliseItems tItems
   if the result is false then return empty
   
   set the to_Side of me to item 1 of tItems
   set the to_StepNum of me to item 2 of tItems
   set the to_SliceNum of me to item 3 of tItems
   --
   if pToName is not empty then
      set the to_Name of me to pToName
   end if
   return tItems
end to_Items


--> Props | From
-
getprop from_Side
   return the arrow_Array ["from_Side"] of me
end from_Side

setprop from_Side fSide
   _NormaliseItems fSide
   if the result is false then return empty
   put item 1 of fSide into fSide
   
   set the arrow_Array ["from_Side"] of me to fSide
end from_Side

getprop from_StepNum
   return the arrow_Array ["from_StepNum"] of me
end from_StepNum

setprop from_StepNum stepNum
   set the arrow_Array ["from_StepNum"] of me to stepNum
end from_StepNum

getprop from_SliceNum
   return the arrow_Array ["from_SliceNum"] of me
end from_SliceNum

setprop from_SliceNum sliceNum
   set the arrow_Array ["from_SliceNum"] of me to sliceNum
end from_SliceNum


--> Props | To
-
getprop to_Side
   return the arrow_Array ["to_Side"] of me
end to_Side

setprop to_Side toSide
   _NormaliseItems toSide
   if the result is false then return empty
   put item 1 of toSide into toSide
   
   set the arrow_Array ["to_Side"] of me to toSide
end to_Side

getprop to_StepNum
   return the arrow_Array ["to_StepNum"] of me
end to_StepNum

setprop to_StepNum stepNum
   set the arrow_Array ["to_StepNum"] of me to stepNum
end to_StepNum

getprop to_SliceNum
   return the arrow_Array ["to_SliceNum"] of me
end to_SliceNum

setprop to_SliceNum sliceNum
   set the arrow_Array ["to_SliceNum"] of me to sliceNum
end to_SliceNum


--> Private
-
private function _ConstructArrowPoints pNameLink
   if pNameLink is an array then
      _DeconstructArray pNameLink, fromName, fItems, toName, tItems
   else
      _DeconstructItems pNameLink, fromName, fItems, toName, tItems
   end if
   --
   put _GetArrowPoints (fromName, fItems, toName, tItems) into arrowPoints
   return arrowPoints
end _ConstructArrowPoints

private command _DeconstructArray arrowArray, @fromName, @fItems, @toName, @tItems
   put arrowArray ["from_Name"] into fromName
   put arrowArray ["from_Side"] into item 1 of fItems
   put arrowArray ["from_StepNum"] into item 2 of fItems
   put arrowArray ["from_SliceNum"] into item 3 of fItems
   _NormaliseItems fItems
   --
   put arrowArray ["to_Name"] into toName
   put arrowArray ["to_Side"]into item 1 of tItems
   put arrowArray ["to_StepNum"] into item 2 of tItems
   put arrowArray ["to_SliceNum"] into item 3 of tItems
   _NormaliseItems tItems
end _DeconstructArray

private function _ConstructItems fromName, fItems, toName, tItems
   _NormaliseItems fItems
   if the result is false then return empty
   _NormaliseItems tItems
   if the result is false then return empty
   
   set the linedelimiter to " - "
   put fromName,fItems into line 1 of nameLink
   put toName,tItems into line 2 of nameLink
   return nameLink
end _ConstructItems

private command _DeconstructItems pNameLink, @fromName, @fItems, @toName, @tItems   
   set the linedelimiter to "-"
   put word 1 to -1 of line 1 of pNameLink into fromItems
   put word 1 to -1 of line 2 of pNameLink into toItems
   --
   put word 1 to -1 of item 1 of fromItems into fromName
   put word 1 to -1 of item 2 of fromItems into fSide
   put word 1 to -1 of item 3 of fromItems into fStepNum
   put word 1 to -1 of item 4 of fromItems into fSliceNum
   --
   put fSide into item 1 of fItems
   put fStepNum into item 2 of fItems
   put fSliceNum into item 3 of fItems
   _NormaliseItems fItems
   
   put word 1 to -1 of item 1 of toItems into toName
   put word 1 to -1 of item 2 of toItems into tSide
   put word 1 to -1 of item 3 of toItems into tStepNum
   put word 1 to -1 of item 4 of toItems into tSliceNum
   --
   put tSide into item 1 of tItems
   put tStepNum into item 2 of tItems
   put tSliceNum into item 3 of tItems
   _NormaliseItems tItems
end _DeconstructItems

private function _GetArrowPoints fromName, fItems, toName, tItems
   put _FromView (fromName) into fromView
   if fromView is empty then return empty
   
   put the border_Loc [fItems] of fromView into aStartPoint
   if aStartPoint is empty then
      return empty
   end if
   
   put _ToView (toName) into toView
   if toView is empty then return empty
   
   put the border_Loc [tItems] of toView into aEndPoint
   if aEndPoint is empty then
      return empty
   end if
   
   put (item 2 of aEndPoint - item 2 of aStartPoint)/2 into aHalfHeight
   --
   put aStartPoint into upPoint
   add aHalfHeight to item 2 of upPoint
   --
   put aEndPoint into downPoint
   subtract aHalfHeight from item 2 of downPoint
   
   put aStartPoint into sPoints
   put CR & upPoint after sPoints
   put CR & downPoint after sPoints
   put CR & aEndPoint after sPoints
   --
   return sPoints
end _GetArrowPoints

private command _NormaliseItems @sItems
   get char 1 of sItems
   if it is not among the chars of "lrtb" then
      put empty into sItems
      return false
   end if
   
   switch char 1 of sItems
      case "l"
         put "left" into item 1 of sItems
         break
      case "r"
         put "right" into item 1 of sItems
         break
      case "t"
         put "top" into item 1 of sItems
         break
      case "b"
         put "bottom" into item 1 of sItems
         break
   end switch
   
   if item 2 of sItems is empty then
      put 1 into item 2 of sItems
      put 2 into item 3 of sItems
   end if
   return true
end _NormaliseItems


--> Objects
-
getprop arrow_View
   return the long id of me
end arrow_View

getprop view_Object
   return the long id of me
end view_Object
