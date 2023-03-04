script "behavior_ViewGovernanceLogo"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewGovernanceLogo
type: behavior
version: 0.1

--> Variables
-
local LocalArray


--> Custom
-
private function _LayerNames
   return _GraphicLayerNames() & ",-,Image,SVG"
end _LayerNames

private function _GraphicLayerNames
   return "Round Rectangle,Rectangle,Oval"
end _GraphicLayerNames


--> Working on
-
function rect_GetSquare sRect
   put item 1 of sRect into sLeft
   put item 2 of sRect into sTop
   put item 3 of sRect into sRight
   put item 4 of sRect into sBottom
   
   put (sLeft + sRight) / 2 into sCenterX
   put (sTop + sBottom) / 2 into sCenterY
   put min (sRight - sLeft, sBottom - sTop) / 2 into sSize
   
   put sCenterX - sSize into sNewLeft
   put sCenterY - sSize into sNewTop
   put sCenterX + sSize into sNewRight
   put sCenterY + sSize into sNewBottom
   --
   return sNewLeft,sNewTop,sNewRight,sNewBottom
end rect_GetSquare

command logo_Stretch pRect
   put the rect_Array of me into rectArray
   put rectArray ["view"]["width"] into oWidth
   put rectArray ["view"]["height"] into oHeight
   --
   put the rect of dafs into oRectangleRect
   put rectArray ["controls"][1006]["rect"] into oRoundRect
   
   put rect_FromHeight (pRect, oHeight) into newRect
   put item 3 of newRect into nRight
   --
   put rect_FromHeight (oRectangleRect, oHeight) into nRectangleRect
   put nRight into item 3 of nRectangleRect
   put rect_FromHeight (oRoundRect, oHeight) into nRoundRect
   put nRight into item 3 of nRoundRect
   
   lock screen
   set lockmessages to true
   -- set the rect of me to newRect
   --
   set the rect of _RectGraphic() to nRectangleRect
   set the rect of _RoundGraphic() to nRoundRect
   --
   set the rect of _SvgObject() to newRect
   set the rect of _ImageObject() to newRect
   set lockmessages to false
   unlock screen
end logo_Stretch

function scale_Height originalRect, newW
   rect_ExtractDimensions originalRect, originalW , originalH
   put newW / originalW into sFactor
   put originalH * sFactor into newH
   return newH
end scale_Height

function rect_FromHeight sRect, newHeight
   put item 2 of sRect into someTop
   put (item 4 of sRect - someTop)/2 into oHalfHeight
   put someTop + oHalfHeight into centreY
   put newHeight/2 into nHalfHeight
   --
   put sRect into nRect
   put centreY - nHalfHeight into item 2 of nRect
   put centreY + nHalfHeight into item 4 of nRect
   --
   return nRect
end rect_FromHeight

command rect_SetHeight @someRect, newHeight, pDontCentre
   if pDontCentre is true then
      put item 2 of someRect + newHeight into item 4 of someRect
   else
      put item 2 of someRect into someTop
      put (item 4 of someRect - someTop)/2 into oHalfHeight
      put someTop + oHalfHeight into centreY
      
      put newHeight/2 into nHalfHeight
      put centreY - nHalfHeight into item 2 of someRect
      put centreY + nHalfHeight into item 4 of someRect
   end if
end rect_SetHeight

getprop poly_Points [useRelative]
   if useRelative is true then
      return the relativepoints of _PolygonObject()
   else
      return the points of _PolygonObject()
   end if
end poly_Points

getprop poly_Points [useRelative] sPoints
   if useRelative is true then
      set the relativepoints of _PolygonObject() to sPoints
   else
      set the points of _PolygonObject() to sPoints
   end if
end poly_Points

command logo_Centre pRect
   put rect_GetCentre (pRect) into myCentre
   --
   lock screen
   set the loc of me to myCentre
   --
   set the loc of _SvgObject() to myCentre
   set the loc of _ImageObject() to myCentre
   set the loc of _PolygonObject() to myCentre
   
   unlock screen
end logo_Centre

command logo_Resize squareRect
   -- put rect_GetSquare (squareRect) into squareRect
   --
   put the rect_Array of me into rectArray
   put rectArray ["view"]["rect"] into oRect
   --
   rect_SetScaleVectors oRect, squareRect, scaleX, scaleY
   --
   put rectArray ["controls"][1004]["rect"] into oOvalRect
   put rectArray ["controls"][1005]["rect"] into oRectangleRect
   put rectArray ["controls"][1006]["rect"] into oRoundRect
   --
   put transformRectangle (oRect, squareRect, oOvalRect) into nOvalRect
   put transformRectangle (oRect, squareRect, oRectangleRect) into nRectangleRect
   put transformRectangle (oRect, squareRect, oRoundRect) into nRoundRect
   
   lock screen
   set lockmessages to true 
   set the rect of me to squareRect
   set the rect of _SvgObject() to squareRect
   set the rect of _ImageObject() to squareRect
   set the rect of _PolygonObject() to squareRect
   --
   set the rect of _OvalGraphic() to nOvalRect
   set the rect of _RectGraphic() to nRectangleRect
   set the rect of _RoundGraphic() to nRoundRect
   
   set lockmessages to false
   unlock screen
end logo_Resize

function rect_ScaleTo someRect, scaleX, scaleY, toRect
   put scaleX * (item 3 of someRect - item 1 of someRect) into nWidth
   put scaleY * (item 4 of someRect - item 2 of someRect) into nHeight
   
   put 0,0,nWidth,nHeight into scaledRect
   put item 1 of toRect into xVector
   put item 2 of toRect into yVector
   rect_Translate scaledRect, xVector, yVector
   --
   return scaledRect
end rect_ScaleTo

function transformRectangle srcRect, dstRect, innerRect
   -- generated by chatGPT!
   put item 1 of srcRect into srcLeft
   put item 2 of srcRect into srcTop
   put item 3 of srcRect into srcRight
   put item 4 of srcRect into srcBottom
   put item 1 of dstRect into dstLeft
   put item 2 of dstRect into dstTop
   put item 3 of dstRect into dstRight
   put item 4 of dstRect into dstBottom
   put item 1 of innerRect into innerLeft
   put item 2 of innerRect into innerTop
   put item 3 of innerRect into innerRight
   put item 4 of innerRect into innerBottom
   put srcRight - srcLeft into srcW
   put srcBottom - srcTop into srcH
   put dstRight - dstLeft into dstW
   put dstBottom - dstTop into dstH
   put innerRight - innerLeft into innerW
   put innerBottom - innerTop into innerH
   put dstW / srcW into xScale
   put dstH / srcH into yScale
   put innerLeft * xScale into newInnerLeft
   put innerTop * yScale into newInnerTop
   put innerW * xScale into newInnerW
   put innerH * yScale into newInnerH
   put newInnerLeft + (dstLeft - srcLeft) into newInnerLeft
   put newInnerTop + (dstTop - srcTop) into newInnerTop
   put newInnerLeft + newInnerW into newInnerRight
   put newInnerTop + newInnerH into newInnerBottom
   return newInnerLeft & "," & newInnerTop & "," & newInnerRight & "," & newInnerBottom
end transformRectangle

function rect_ScaleTo cRect, scaleX, scaleY, fromLoc, toLoc
   put scaleX * (item 3 of someRect - item 1 of someRect) into nWidth
   put scaleY * (item 4 of someRect - item 2 of someRect) into nHeight
   --
   loc_SetTranslationVector fromLoc, toLoc, xVector, yVector
   rect_Translate scaledRect, xVector, yVector
   --
   return scaledRect
end rect_ScaleTo

command rect_SetScaleVectors someRect, targetRect, @scaleX, @scaleY
   put item 3 of someRect - item 1 of someRect into someWidth
   put item 3 of targetRect - item 1 of targetRect into targetWidth
   put targetWidth/someWidth into scaleX
   
   put item 4 of someRect - item 2 of someRect into someHeight
   put item 4 of targetRect - item 2 of targetRect into targetHeight
   put targetHeight/someHeight into scaleY
   
   return scaleX,scaleY
end rect_SetScaleVectors

function rect_ScaleByVectors someRect, scaleX, scaleY
   put item 1 of someRect * scaleX into item 1 of scaledRect
   put item 3 of someRect * scaleX into item 3 of scaledRect
   put item 2 of someRect * scaleY into item 2 of scaledRect
   put item 4 of someRect * scaleY into item 4 of scaledRect
   return scaledRect
end rect_ScaleByVectors

command logo_Centre pRect
   lock screen
   put rect_GetCentre (pRect) into myCentre
   --
   set the loc of me to myCentre
   set the loc of _SvgObject() to myCentre
   set the loc of _ImageObject() to myCentre
   --
   unlock screen
end logo_Centre


--> Props
-
getprop resize_Style
   put LocalArray ["resize_Style"] into resizeStyle
   if resizeStyle is empty then
      return "centre"
   else
      return resizeStyle
   end if
end resize_Style

setprop resize_Style resizeStyle
   put resizeStyle into LocalArray ["resize_Style"]
end resize_Style

getprop resize_Styles
   return "stretch,resize,centre"
end resize_Styles

getprop layer_Names
   return _LayerNames()
end layer_Names

getprop show_Names
   return the showName of _OvalGraphic() is true
end show_Names

setprop show_Names sBoolean
   lock screen
   repeat for each item layerName in _GraphicLayerNames()
      put _LayerObject (layerName) into layerObject
      if exists (layerObject) is false then next repeat
      --
      set the showName of layerObject to sBoolean
   end repeat
   unlock screen
end show_Names

getprop graphic_Borders
   return the lineSize of _OvalGraphic() > 0
end graphic_Borders

setprop graphic_Borders sBoolean
   lock screen
   repeat for each item layerName in _GraphicLayerNames()
      put _LayerObject (layerName) into layerObject
      if exists (layerObject) is false then next repeat
      --
      if sBoolean is true then
         set the lineSize of layerObject to 8
      else
         set the lineSize of layerObject to 0
      end if
   end repeat
   unlock screen
end graphic_Borders

getprop visible_Names
   repeat for each item layerName in _LayerNames()
      if layerName = "-" then next repeat
      put _LayerObject (layerName) into layerObject
      if exists (layerObject) is false then next repeat
      --
      if the visible of layerObject is true then
         put layerName & comma after visibleNames
      end if
   end repeat
   delete char -1 of visibleNames
   return visibleNames
end visible_Names

setprop toggle_Visible layerName
   put _LayerObject (layerName) into layerObject
   --
   put the visible of layerObject into sBoolean
   set the visible of layerObject to (sBoolean is false)
   return layerObject
end toggle_Visible

getprop layer_Visible [layerName]
   put _LayerObject (layerName) into layerObject
   --
   put the visible of layerObject into sBoolean
   return sBoolean
end layer_Visible

setprop layer_Visible [layerName] sBoolean
   put _layerObject (layerName) into layerObject
   --
   set the visible of layerObject to sBoolean
   return layerObject
end layer_Visible

getprop text_Rotation
   return the angle of _SvgObject()
end text_Rotation

setprop text_Rotation sDegree
   set the angle of _SvgObject() to sDegree
end text_Rotation


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
   if pRect is empty then put the rect of me into pRect
   
   switch LocalArray ["resize_Style"]
      case "stretch"
         logo_Stretch pRect
         break
      case "resize"
         logo_Resize pRect
         break
      default -- "centre"
         logo_Centre pRect
   end switch   
end LayoutControl

command rect_ExtractDimensions someRect, @someW, @someH, pScale
   if pScale is not a number then put 1 into pScale
   --
   put pScale * (item 3 of someRect - item 1 of someRect) into someW
   put pScale * (item 4 of someRect - item 2 of someRect) into someH
end rect_ExtractDimensions


--> Objects
-
getprop graphic_Objects
   repeat for each item layerName in _GraphicLayerNames()
      put _LayerObject (layerName) into layerObject
      if exists (layerObject) then
         put layerObject & CR after layerObjects
      end if
   end repeat
   return layerObjects
end graphic_Objects

getprop layer_Object [layerName]
   return _LayerObject (layerName)
end layer_Object

private function _LayerObject layerName
   if exists (control layerName of me) is false then return empty
   put the long id of control layerName of me into layerObject
   return revRuggedId (layerObject)
end _LayerObject

private function _PolygonObject
   return the long id of control "Polygon" of me
end _PolygonObject

private function _SvgObject
   return the long id of control "SVG" of me
end _SvgObject

private function _ImageObject
   return the long id of control "Image" of me
end _ImageObject

private function _RoundGraphic
   return the long id of control "Round Rectangle" of me
end _RoundGraphic

private function _RectGraphic
   return the long id of control "Rectangle" of me
end _RectGraphic

private function _OvalGraphic
   return the long id of control "Oval" of me
end _OvalGraphic

getprop view_Object
   return the long id of me
end view_Object

