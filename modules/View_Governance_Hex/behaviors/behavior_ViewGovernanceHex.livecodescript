script "behavior_ViewGovernanceHex"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewGovernanceHex
type: behavior
version: 0.1

/*Here you make make notes as a basic form of help for this view.
Full help text can be found on the linked wiki for the view.*/


--> Variables
-
constant Default_NodeWidth = 40
constant Default_NodeWidthFactor = 0.125
local Stop_Flag
local Angle_Step = 3


--> Wasm Hacks
-
setprop animate_Fast
   -- as send and dispatch don;t work
   animate_SpinFast
end animate_Fast


--> Working on
-
getprop hex_Label
   put the label of _HexGraphic() into sText
   return sText
end hex_Label

setprop hex_Label sText
   set the label of _HexGraphic() to sText
end hex_Label

getprop gradient_Flag
   return the gradient_Flag of me
end gradient_Flag
   
setprop gradient_Flag sBoolean
   set the gradient_Flag of me to sBoolean
end gradient_Flag

on animate_Gradient
   put _HexGraphic() into gObject
   
   set the gradient_Flag of gObject to not the gradient_Flag of gObject
   local tGradient1,tGradient2
   
   put "0.00000,255,55,255" into tGradient1
   put cr &"1.00000,30,70,100" after tGradient1
   
   put "0.00000,25,55,155" into tGradient2
   put cr &"1.00000,242,146,43" after tGradient2
   if the gradient_Flag of gObject then
      aeMorphGradientRamp gObject,tGradient1,tGradient2,3000,"overshoot"
   else
      aeMorphGradientRamp gObject,tGradient2,tGradient1,3000,"bounce"
   end if
end animate_Gradient

getprop node_WidthFactor
   put the node_WidthFactor of me into nodeWidthFactor
   if nodeWidthFactor is a number then
      return nodeWidthFactor
   else
      return Default_NodeWidthFactor
   end if
end node_WidthFactor

setprop node_WidthFactor sFactor
   if sFactor is not a number then return false
   
   set the node_WidthFactor of me to sFactor
end node_WidthFactor

getprop node_Width
   return _CalculateNodeWidth()
end node_Width

-- setprop node_Width nodeWidth
--
end node_Width

private function _NodeWidth
   return _CalculateNodeWidth()
end _NodeWidth

private function _CalculateNodeWidthFactor
   -- utility function
   
   put the node_Object [3] of me into nodeObject
   put _HexGraphic() into graphicObject
   --
   put the width of graphicObject  into graphicWidth
   put the width of nodeObject into nodeWidth
   --
   put nodeWidth / graphicWidth into nodeWidthFactor
   return nodeWidthFactor
end _CalculateNodeWidthFactor

private function _CalculateNodeWidth
   put _HexGraphic() into graphicObject
   put the node_WidthFactor of me into nodeWidthFactor
   --
   put the width of graphicObject  into graphicWidth
   put graphicWidth * nodeWidthFactor into nodeWidth
   return nodeWidth
end _CalculateNodeWidth


--> Web
-
function jsPostMessage_Internal pageTitle, pWikiDomain
   if pageTitle is empty then put "About Frame Plugin" into pageTitle
   --
   put "window.parent.postMessage({action:'doInternalLink'," into sJavascript
   put "title: '[[pageTitle]]'," after sJavascript
   --
   if pWikiDomain is not empty then
      -- site: "wiki.dbbs.co",
      put "site: '[[pWikiDomain]]'," after sJavascript
   end if
   --
   put "keepLineup: event.shiftKey" after sJavascript
   put "}, '*');"  after sJavascript
   --
   replace "'" with quote in sJavascript
   return merge (sJavascript)
end jsPostMessage_Internal


--> Props | Geometry
-
getprop node_Rect [nodeNum]
   put the node_Points [nodeNum] of me into nodeCentre
   put _NodeWidth() into nodeWidth
   put rect_LocWidthHeight (nodeCentre, nodeWidth, nodeWidth) into nodeRect
   return nodeRect
end node_Rect

getprop centre_Rect
   put the loc of me into nodeCentre
   put _NodeWidth() into nodeWidth
   put round (nodeWidth / 2) into nodeWidth
   put rect_LocWidthHeight (nodeCentre, nodeWidth, nodeWidth) into nodeRect
   return nodeRect
end centre_Rect

getprop node_Points [nodeNum]
   put _HexGraphic() into gObject
   --
   put the effective points of gObject into nodePoints
   delete line -1 of nodePoints
   if nodeNum is a number then
      return line nodeNum of nodePoints
   else
      return nodePoints
   end if
end node_Points

getprop hex_Angle
   put the angle of _HexGraphic() into sAngle
   return sAngle
end hex_Angle

setprop hex_Angle sAngle
   put _HexGraphic() into hexGraphic
   
   lock screen
   set the angle of hexGraphic to sAngle
   Layout_Nodes
   unlock screen
end hex_Angle


--> Props
-
getprop mouse_IdleRate
   put the mouseH into mY
   return _MouseIdleRate(mY)
end mouse_IdleRate

getprop node_Visible [nodeNum]
   return _IsVisible (nodeNum)
end node_Visible

setprop node_Visible [nodeNum] sBoolean
   if nodeNum is a number then
      animate_NodeFade nodeNum, sBoolean
      return the result
   end if
   
   if sBoolean is true then
      animate_FadeIn
   else
      animate_FadeOut
   end if
   return the result
end node_Visible


--> Hex
-
command hex_NodeClick tName
   put word -1 of tName into nodeNum
   put _NodeName (nodeNum) into nodeName
   
   switch nodeName
      case "Magician"
         hex_OpenWikiPage nodeName
         --
         animate_ToCentre
         break
      case "Heart"
         hex_OpenWikiPage nodeName
         if _IsVisible() is true then
            animate_ToOne
         else
            Layout_Init
            animate_FadeIn
         end if
         break
      case "Jester"
         hex_OpenWikiPage nodeName
         animate_ToEdge
         break
      case "Healer"
         set the visible of _HexGraphic() to not the visible of _HexGraphic() 
         hex_OpenWikiPage nodeName
         break
      case "Head"
         set the visible of _HexGraphic() to true 
         hex_OpenWikiPage nodeName
         animate_SpinFast
         break
      case "Hands"
         put Stop_Flag is false into Stop_Flag
         if Stop_Flag is true then
            put 3 into Angle_Step
         else
            put 1 into Angle_Step
            hex_OpenWikiPage nodeName
         end if
         --
         animate_SendSpin
         break
      default
         hex_OpenWikiPage nodeName
   end switch
end hex_NodeClick

command hex_OpenWikiPage nodeName
   if the platform is "web" then
      put jsPostMessage_Internal (nodeName) into sJavascript
      do sJavascript as "Javascript"
   end if
   --
   set the hex_Label of me to nodeName
end hex_OpenWikiPage

command hex_ResetNode nodeNum, nodeObject
   put the node_Rect [nodeNum] of me into nodeRect
   put _NodeColour (nodeNum) into nodeColour
   put _SwitchColour (nodeColour) into nodeTextColour
   
   lock screen
   set the opaque of nodeObject to true
   set the rect of nodeObject to nodeRect
   set the backgroundcolor of nodeObject to nodeColour
   set the foregroundcolor of nodeObject to nodeTextColour
   unlock screen
   
   return nodeRect
end hex_ResetNode


--> Events
-
on preopenControl
   Layout_Init
end preopenControl

on resizeControl
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl

on mouseEnter
   set the idlerate to 20
end mouseEnter

on mouseLeave
   set the idlerate to 200
end mouseLeave

on mouseDoubleUp
   Layout_Init
   
   if the platform is "web" then
   else
      edit the script of me
   end if
end mouseDoubleUp

on mouseDown
   if "animationEngine" is among the lines of the stacksinuse then
      animate_Gradient
   else
   end if
end mouseDown

on mouseUp
   put the short name of the target into tName  
   switch tName
      case "Hexagon"
         _HexClick
         put Stop_Flag is false into Stop_Flag
         break
      default
         hex_NodeClick tName
   end switch
end mouseUp

on mouseMove mX, mY
   put _MouseIdleRate (mY) into mouseIdleRate
   set the idlerate to mouseIdleRate
end mouseMove


--> Animate | Spin
-
command animate_Spin
   if Stop_Flag is true then
      return empty
   else
      animate_RotateStep
      return the result
   end if
end animate_Spin

on animate_RotateStep
   put the hex_Angle of me into sAngle
   add Angle_Step to sAngle
   set the hex_Angle of me to sAngle
   return sAngle
end animate_RotateStep

command animate_SendSpin
   if the shiftKey is "Down" then exit to top
   if Stop_Flag is true then
      return empty
   end if
   
   animate_RotateStep
   send "animate_SendSpin" to me in 40 milliseconds
end animate_SendSpin


--> Animate
-
command animate_SpinFast
   put 6 into Angle_Step
   put the hex_Angle of me into oAngle
   --
   put oAngle into sAngle
   repeat 120
      add Angle_Step to sAngle
      set the hex_Angle of me to sAngle
      wait 2 milliseconds
   end repeat
   set the hex_Angle of me to oAngle -- just in case
   --
   put true into Stop_Flag
   -- lcw_Answer "Finished!"
end animate_SpinFast

command animate_NodeFade nodeNum, sBoolean, pDuration
   if pDuration is not a number then put 300 into pDuration
   put the node_Object [nodeNum] of me into nodeObject
   if exists (nodeObject) is false then return empty
   
   if sBoolean is not false then
      aeFadeIn nodeObject, pDuration
   else
      aeFadeOut nodeObject, pDuration
   end if
   return nodeObject
end animate_NodeFade

command animate_FadeIn pDuration
   if pDuration is not a number then put 300 into pDuration
   repeat with nodeNum = 6 down to 1
      put the node_Object [nodeNum] of me into nodeObject
      aeFadeIn nodeObject, pDuration
   end repeat
end animate_FadeIn

command animate_FadeOut pDuration
   if pDuration is not a number then put 300 into pDuration
   repeat with nodeNum = 6 down to 1
      put the node_Object [nodeNum] of me into nodeObject
      aeFadeOut nodeObject, pDuration
   end repeat
end animate_FadeOut

command animate_ToOne pDuration, pMethod
   put "inout" into pMethod -- valid methods are: in,out,inOut,bounce or overshoot
   put 400 into pDuration
   
   put the centre_Rect [6] of me into centreRect
   --
   aeLockRects
   repeat with nodeNum = 6 down to 2
      put the node_Object [nodeNum] of me into nodeObject
      aeChangeRect nodeObject, centreRect, 200, pMethod
      aeFadeOut nodeObject, 100
   end repeat
   aeUnLockRects
   
   put the loc of me into centreLoc
   put the node_Object [1] of me into nodeObject
   aeMoveTo nodeObject, centreLoc, pDuration, pMethod
end animate_ToOne

command animate_ToEdge pDuration, pMethod
   put "out" into pMethod -- valid methods are: in,out,inOut,bounce or overshoot
   put 400 into pDuration
   
   aeLockMoves
   repeat with nodeNum = 1 to 6
      put the node_Object [nodeNum] of me into nodeObject
      put the node_Rect [nodeNum] of me into nodeRect
      aeChangeRect nodeObject, nodeRect, pDuration, pMethod
   end repeat
   aeUnlockMoves
end animate_ToEdge

command animate_ToCentre pDuration, pMethod
   put "inout" into pMethod -- valid methods are: in,out,inOut,bounce or overshoot
   put 300 into pDuration
   
   -- put the centre_Rect of me into centreRect
   put the loc of me into centreLoc
   --
   aeLockMoves
   repeat with nodeNum = 1 to 6
      put the node_Object [nodeNum] of me into nodeObject
      aeMoveTo nodeObject, centreLoc, pDuration, pMethod
      -- aeChangeRect nodeObject, centreRect, pDuration, pMethod
   end repeat
   aeUnlockMoves
end animate_ToCentre


--> Layout
-
command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   put _HexGraphic() into hexGraphic
   put _NodeWidth() into nodeWidth
   --
   put rect_SimpleSubtract (pRect, nodeWidth) into innerRect
   
   lock screen
   set the rect of hexGraphic to innerRect
   Layout_Nodes
   set the rect of me to pRect
   unlock screen
end LayoutControl

command Layout_Init
   put _HexGraphic() into hexGraphic
   
   put the rect of this cd into pRect
   --
   lock screen
   set the visible of _HexGraphic() to true
   set the hex_Angle of hexGraphic to -90
   set the label of hexGraphic to empty
   --
   LayoutControl pRect
   put true into Stop_Flag
   unlock screen
end Layout_Init

command Layout_Nodes
   lock screen
   repeat with nodeNum = 1 to 6
      put the node_Object [nodeNum] of me into nodeObject
      if exists (nodeObject) then
         hex_ResetNode nodeNum, nodeObject
      end if
   end repeat
   unlock screen
end Layout_Nodes


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

function rect_LocWidthHeight someLoc, newW, newH
   put newW/2 into leftBit
   put newW - leftBit into rightBit
   put item 1 of someLoc into someX
   put someX - leftBit into item 1 of someRect
   put someX + rightBit into item 3 of someRect
   
   put newH/2 into upBit
   put newH - upBit into downBit
   put item 2 of someLoc into someY
   put someY - upBit into item 2 of someRect
   put someY + downBit into item 4 of someRect
   
   return someRect
end rect_LocWidthHeight


--> Private
-
private function _HexGraphic
   return the long id of graphic "Hexagon" of me
end _HexGraphic

private function _SwitchColour nodeColour
   switch nodeColour
      case "black"
         return white
         break
      default
         return black
   end switch
end _SwitchColour

private command _HexClick
   if the platform is "web" then
      put jsPostMessage_Internal ("Micro Assembly") into sJavascript
      do sJavascript as "Javascript"
   else
      if _IsVisible() is false then
         animate_FadeIn
      end if
   end if
end _HexClick

private function _IsVisible pNum
   if pNum is empty then put 3 into pNum
   put the node_Object [pNum] of me into nodeObject
   return the visible of nodeObject
end _IsVisible

private function _NodeColour nodeNum
   return item nodeNum of "red,yellow,blue,black,white,green"
end _NodeColour

private function _NodeName nodeNum
   return item nodeNum of "Heart,Healer,Hands,Magician,Head,Jester"
end _NodeName

private function _MouseIdleRate mY
   put _HexGraphic() into hexGraphic
   --
   put the height of hexGraphic into myHeight
   put the bottom of hexGraphic into myBottom
   --
   put (myBottom - my) / myHeight into sFrac
   put 50 * sFrac into slowDown
   put 10 + slowDown into newRate
   return round (newRate)
end _MouseIdleRate


--> Objects
-
getprop view_Object
   return the long id of me
end view_Object

getprop hex_View
   return the long id of me
end hex_View

getprop hex_Graphic
   return _HexGraphic()
end hex_Graphic

getprop node_Object [nodeNum]
   put "Node" && nodeNum into nodeName
   --
   if exists (control nodeName of me) then
      put the long id of control nodeName of me into nodeObject
      return nodeObject
   else
      return empty
   end if
end node_Object
