script "behavior_ViewGovernancePerson"
--> MetaData
-
license: GPLv3
name: behavior_ViewGovernancePerson
type: behavior
version: 0.2
copyright: David Bovill

/*
An image is burned when a displayed linked file is turned into a snapshot.

-- set the burnt_Image of mTarget to true
does the following:
-- export snapshot from imageGroup to pngVar as PNG
*/

local LocalArray


--> Events
-
on mouseDown pButton
   if pButton = 3 then
      menu_PopUp "Global | Governance | Person | Menu"
   else
      if word 1 of the target = "image" then
         if the burnt_Image of me is true then
            grab me
         else
            grab the target
         end if
      end if
   end if
end mouseDown

on resizecontrol
   LayoutControl
end resizecontrol


--> Events | Drag
-
on dragEnter -- show a green outline around the drop target
   -- set the borderColor of the target to "green"
   set the allowableDragActions to "link"
   set the dragAction to "Link"
end dragEnter

on dragLeave
   -- set the borderColor of the target to ""
end dragLeave

on dragDrop
   put the dragData ["text"] into droppedURL
   if droppedURL is empty then pass dragDrop
   
   put droppedURL
end dragDrop


--> Data
-
getprop displayed_Data
   return LocalArray ["displayed_Data"]
end displayed_Data

setprop displayed_Data dataArray
   put dataArray into LocalArray ["displayed_Data"]
end displayed_Data


--> Image | File
-
getprop image_Content
   put the image_Object of me into imageObject
   put the text of imageObject into someImage
   return someImage
end image_Content

setprop image_Content someImage
   put the image_Object of me into imageObject
   set the text of imageObject to someImage
   return imageObject
end image_Content

getprop image_File
   put the image_Object of me into imageObject
   put the filename of imageObject into imageFile
   return imageFile
end image_File

setprop image_File imageFile
   put the image_Object of me into imageObject
   --
   lock screen
   set the filename of imageObject to imageFile
   set the image_Magnification of me to 1
   set the image_ResizeQuality of me to "best"
   unlock screen
   --
   set the image_SourceFile of me to imageFile
   return imageObject
end image_File

getprop image_SourceFile
   return the image_SourceFile of me
end image_SourceFile

setprop image_SourceFile imageFile
   set the image_SourceFile of me to imageFile
end image_SourceFile


--> Image | Settings
-
/*
Settings are so far "the image_SourceFile of me"
*/

command image_RestoreSettings
   put the image_SourceFile of me into imageFile
   put the image_Object of me into imageObject
   --
   lock screen
   set the filename of imageObject to imageFile
   set the image_ResizeQuality of me to "best"
   set the image_Magnification of me to 1
   set the show_Image of me to true
   unlock screen
   return imageFile
end image_RestoreSettings

command image_SaveSettings
   -- could also save the image offsets etc
   put the image_Object of me into imageObject
   put the filename of imageObject into imageFile
   set the image_SourceFile of me to imageFile
end image_SaveSettings


--> Geometry
-
command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   lock screen
   
   put the graphic_Object of me into graphicObject
   put the image_Object of me into imageObject
   put the image_Group of me into imageGroup
   
   put the margins of imageGroup into imageGroupMargins
   put the inner_Rect [pRect] of me into innerRect
   rect_SubtractMargins innerRect, 2 -- hack, not sure why?
   
   put rect_GetCentre (innerRect) into innerLoc
   put the rect of graphicObject into gRect
   put the rect of imageGroup into iRect
   
   switch
      case the burnt_Image of me is true      
         -- set the show_Rounded of me to false
         
         put item 3 of innerRect - item 1 of innerRect into innerWidth
         put item 4 of innerRect - item 2 of innerRect into innerHeight
         put min (innerWidth,innerHeight) into innerSquareWidth
         add 1 to item 1 of innerLoc -- hack, not sure why?
         add 1 to item 2 of innerLoc -- hack, not sure why?
         put rect_LocWidthHeight (innerLoc, innerSquareWidth, innerSquareWidth) into graphicRect
         rect_AddMargins graphicRect, -2 -- hack, not sure why?
         
         put graphicRect into imageGroupRect
         rect_AddMargins imageGroupRect, imageGroupMargins
         
         put imageGroupRect into imageRect
         -- rect_AddMargins imageRect, 8
         
         set the rect of imageGroup to imageGroupRect
         set the rect of graphicObject to graphicRect
         set the rect of imageObject to imageRect
         break
      case the resize_Graphic of me is true
         -- set the show_Rounded of me to true
         
         if the constrain_Graphic of me is true then
            put item 3 of innerRect - item 1 of innerRect into innerWidth
            put item 4 of innerRect - item 2 of innerRect into innerHeight
            add 1 to item 1 of innerLoc -- hack, not sure why?
            add 1 to item 2 of innerLoc -- hack, not sure why?
            put min (innerWidth,innerHeight) into innerSquareWidth
            put rect_LocWidthHeight (innerLoc, innerSquareWidth, innerSquareWidth) into graphicRect
            
            rect_AddMargins graphicRect, -2 -- hack, not sure why?
         else
            put innerRect into graphicRect
         end if
         
         put graphicRect into imageGroupRect
         rect_AddMargins imageGroupRect, imageGroupMargins
         
         set the rect of imageGroup to imageGroupRect
         set the rect of graphicObject to graphicRect
         break
      default
         -- set the show_Rounded of me to true
         
         put the rect of graphicObject into imageGroupRect
         rect_AddMargins imageGroupRect, imageGroupMargins
         -- put innerRect into graphicRect
         set the rect of imageGroup to imageGroupRect
         set the loc of imageGroup to innerLoc
   end switch
   hideLabelIfTooSmall graphicRect
   -- set the rect of me to pRect
   unlock screen
end LayoutControl


--> Image | Magnification | Props
-
getprop image_Magnification
   put the image_Object of me into imageObject
   put the width of imageObject / the formattedwidth of imageObject into magFactor
   return magFactor
end image_Magnification

setprop image_Magnification [magCentre] absoluteMagnification 
   put the image_Object of me into imageObject
   --
   lock screen
   put the rect of me into oRect
   put the loc of me into viewCentre
   
   -- set the image_ScrollCentre of me to magCentre
   put the formattedWidth of imageObject into fWidth
   put the formattedHeight of imageObject into fHeight
   put absoluteMagnification * fWidth into newWidth
   put absoluteMagnification * fHeight into newHeight
   put rect_LocWidthHeight (viewCentre, newWidth, newHeight) into newRect
   --
   set the rect of imageObject to newRect
   -- set the show_Image of me to true
   set the show_Rounded of me to true
   --
   unlock screen
end image_Magnification

setprop image_RelativeMagnification [magCentre] relativeMagnification
   put the image_View of the target into imageView
   
   if relativeMagnification is a number then
      lock screen
      put the loc of me into viewCentre
      
      set the image_ScrollCentre of imageView to magCentre
      rect_ScaleGroup imageView, relativeMagnification, viewCentre, false
      
      put relativeMagnification into LocalArray ["image_Magnification"]
      unlock screen
   else
      answer warning "Image magnification factor is not a number!"
   end if
end image_RelativeMagnification


--> Image | Magnification
-
command image_ResetToOriginalSize
   -- resize the image to it's original dimensions, centred on it's original centre
   
   put 1 into LocalArray ["image_Magnification"]
   --
   put the image_Object of me into imageObject
   put the formattedWidth of imageObject into fWidth
   put the formattedHeight of imageObject into fHeight
   put the loc of imageObject into oLoc
   put rect_LocWidthHeight (oLoc, fWidth, fHeight) into newRect
   set the rect of imageObject to newRect
end image_ResetToOriginalSize

function image_AbsoluteToRelativeMagnification absoluteMagnification, imageView
    put the image_Magnification of imageView into oMagnification
    if oMagnification is a number and oMagnification is not 0 then
        put absoluteMagnification / oMagnification into relativeMagnification
        return relativeMagnification
    else
        set the image_Magnification of imageView to 1
        return 1
    end if
end image_AbsoluteToRelativeMagnification

command image_ScaleWithin zoomRect, imageView
   -- not sure what this does
   -- was tail end of "rect_MouseDownDraw" script
   
   rect_ExtractDimensions zoomRect, someW, someH
   if someW > 10 and someH > 10 then
      -- bit of a hack but generally mouseClicking results in 1 pixel widths and heights
      -- and should check it is not too much magnification anycase
      put the rect of imageView into imageRect -- imageGroup or imageRect?
      
      put rect_ScaleToFitInside(zoomRect, imageRect) into toFitRect
      rect_SetScaleVectors zoomRect, toFitRect, scaleX, scaleY
      
      put rect_GetCentre(zoomRect) into magCentre
      set the image_RelativeMagnification [magCentre] of imageView to scaleX
   end if
end image_ScaleWithin


--> Geometry | Scroll
-
getprop image_Hscroll
   put the image_View of the target into imageView
   put the hscroll of imageView into relativeX
   return relativeX
end image_Hscroll

setprop image_Hscroll relativeX
   put the image_View of the target into imageView
   set the hscroll of imageView to relativeX 
end image_Hscroll

getprop image_Scroll
   put the image_View of the target into imageView
   
   put the hscroll of imageView into scrollVector
   put the vscroll of imageView into item 2 of scrollVector
   return scrollVector
end image_Scroll

setprop image_Scroll scrollVector
   put the image_View of the target into imageView
   
   set the hscroll of imageView to item 1 of scrollVector
   set the vscroll of imageView to item 2 of scrollVector
end image_Scroll

setprop image_ScrollCentre someLoc
   put rect_GetCentre (the rect of me) into centreLoc
   get loc_GetTranslation (someLoc, centreLoc, x, y)
   image_ScrollByVector x, y
   return it
end image_ScrollCentre

command image_ScrollByVector x, y
   put the hscroll of me into originalHScroll 
   put the vscroll of me into originalVScroll
   image_PanScroll x, y, originalHScroll, originalVScroll
end image_ScrollByVector

command image_PanScroll x, y, originalHScroll, originalVScroll
   put originalHScroll - x into newX
   put originalVScroll - y into newY
   
   lock screen
   set the hscroll of me to newX 
   set the vscroll of me to newY
   unlock screen
end image_PanScroll


--> Burnt
-
getprop burnt_Image
   -- put the burnt_Image of me is true into someBoolean
   put the image_File of me is empty into isBurnt
   return isBurnt
end burnt_Image

setprop burnt_Image [imageWidth] someBoolean
   lock screen
   set the show_Rounded of me to someBoolean
   
   if someBoolean is false then
      image_RestoreSettings
      unlock screen
      return the result
   else
      image_SaveSettings
      
      put the image_Group of me into imageGroup
      put the image_Object of me into imageObject
      
      put the show_ImageBorder of me into oBorder
      set the show_ImageBorder of imageGroup to false
      
      if imageWidth is empty then
         -- don't change dimensions
         put the rect of imageGroup into imageGroupRect
         --
         put the width of imageGroup into iWidth
         put the height of imageGroup into iHeight
         put iWidth,iHeight into newSize
         export snapshot from imageGroup at size newSize to pngVar as PNG
         -- export snapshot from imageGroup to pngVar as PNG
         --
         set the rect of imageObject to imageGroupRect
      else
         -- export image then change dimensions
         set the burnt_ImageWidth of me to imageWidth
      end if
      
      set the text of imageObject to pngVar
      
      set the show_ImageBorder of imageGroup to oBorder
      set the image_ResizeQuality of me to "best"
      unlock screen
      return pngVar
   end if
end burnt_Image

getprop burnt_ImageWidth
   if the burnt_Image of me is false then return empty
   
   put the image_Object of me into imageObject
   return the width of imageObject
end burnt_ImageWidth

setprop burnt_ImageWidth imageWidth
   if imageWidth = "full" then
      put the image_FormatttedWidth of me into imageWidth
   end if
   
   put the loc of me into oLoc
   put view_RectFromImageWidth (imageWidth, oLoc) into viewRect
   
   LayoutControl viewRect
   return viewRect
end burnt_ImageWidth

getprop burnt_ImageRect
   -- not used
   if the burnt_Image of me is false then return empty
   
   put the image_Object of me into imageObject
   return the rect of imageObject
end burnt_ImageRect


--> Geometry | Image
-
getprop image_FormatttedWidth
   -- was "formatted_ImageWidth"
   put the image_Object of me into imageObject
   return the formattedwidth of imageObject
end image_FormatttedWidth

getprop image_FormattedRect
   put the rect of me into imageRect
   put image_GetFormattedRect (imageRect) into imageRect
   return imageRect
end image_FormattedRect

private function image_GetFormattedRect imageRect
   put _imageObject() into imageObject
   --
   put the formattedwidth of imageObject into originalW
   put the formattedheight of imageObject into originalH
   rect_SetWidth imageRect, originalW, false
   rect_SetHeight imageRect, originalH, false
   --
   return imageRect
end image_GetFormattedRect

function view_RectFromImageWidth imageWidth, oLoc
   put the image_Group of me into imageGroup
   
   put the margins of me into myMargins
   put the margins of imageGroup into imageGroupMargins
   put margins_Add (myMargins, imageGroupMargins) into innerMargins
   
   if the showborder of me is true then
      put -2 - the borderwidth of me into someHack
      subtract 1 from item 1 of oLoc
      subtract 1 from item 2 of oLoc
   else
      put -4 into someHack
      subtract -1 from item 1 of oLoc
      subtract -1 from item 2 of oLoc
   end if
   put rect_LocWidthHeight (oLoc, imageWidth, imageWidth) into viewRect
   rect_AddMargins viewRect, innerMargins
   
   rect_AddMargins viewRect, someHack -- hack, not sure why?
   return viewRect
end view_RectFromImageWidth


--> Geometry | Props
-
getprop image_Margins
   put the image_Group of me into imageGroup
   
   put the margins of me into outerMargin
   put the margins of imageGroup into innerMargin
   return outerMargin + innerMargin
end image_Margins

setprop image_Margins someMargin
   put the rect of me into oRect
   put the image_Group of me into imageGroup
   
   put round (someMargin/2) into outerMargin
   put someMargin - outerMargin into innerMargin
   
   lock screen
   set the margins of me to outerMargin
   set the margins of imageGroup to innerMargin
   LayoutControl oRect
   unlock screen
end image_Margins

getprop resize_Graphic
   return the resize_Graphic of me is not false
end resize_Graphic

setprop resize_Graphic someBoolean
   set the resize_Graphic of me to someBoolean
end resize_Graphic

getprop constrain_Graphic
   return the constrain_Graphic of me is not false
end constrain_Graphic

setprop constrain_Graphic someBoolean
   set the resize_Graphic of me to someBoolean
end constrain_Graphic


--> Graphic
-
getprop graphic_Colour
   put the graphic_Object of me into graphicObject
   put the backgroundcolor of graphicObject into someColour
   return someColour
end graphic_Colour

setprop graphic_Colour someColour
   put the graphic_Object of me into graphicObject
   set the backgroundcolor of graphicObject to someColour
   return graphicObject
end graphic_Colour

setprop graphic_Style graphicStyle
   put the graphic_Object of me into graphicObject
   switch graphicStyle
      case "mask"
         set the backgroundcolor of graphicObject to "black"
         set the ink of graphicObject to "blendSrcOver"
         break
      default
         set the ink of graphicObject to "srcCopy"
         -- set the backgroundcolor of graphicObject to "blue"
   end switch
end graphic_Style


--> Node
-
getprop node_Type
   return the person_Type of me
end node_Type

setprop node_Type nType
   set the person_Type of me to nType
   return the result
end node_Type


--> Person
-
getprop person_Type
   -- put the person_Type of me to someType
   put the graphic_Object of me into graphicObject
   put the label of graphicObject into myLabel
   
   put the person_Types of me into personTypes
   repeat for each item personType in personTypes
      if char 1 of personType = myLabel then
         return personType
      end if
   end repeat
   return empty
end person_Type

setprop person_Type personType
   person_NormalizeType personType
   put the result into someColour
   
   -- put person_TypeArray() into pTypeArray
   -- put pTypeArray [personType] into someColour
   
   if someColour is empty then return empty
   
   put the graphic_Object of me into graphicObject
   lock screen
   set the label of graphicObject to toUpper (char 1 of personType)
   set the backgroundcolor of graphicObject to someColour
   unlock screen
   return someType
end person_Type

command person_NormalizeType @personType
   put person_TypeArray() into pTypeArray
   repeat for each key testType in pTypeArray
      if char 1 of testType = char 1 of personType then
         put testType into personType
         return pTypeArray [testType]
      end if
   end repeat
   put empty into personType
   return empty
end person_NormalizeType

getprop person_Types
   return "new student,student,qualified,expert,-,teacher,lecturer,professor"
   put person_TypeArray() into pTypeArray
   return keys (pTypeArray)
end person_Types

function person_TypeArray
   put "yellow" into pTypeArray ["professor"]
   put "orange" into pTypeArray ["lecturer"]
   put "red" into pTypeArray ["teacher"]
   
   put "pink" into pTypeArray ["expert"]
   put "purple" into pTypeArray ["qualified"]
   put "102,102,255" into pTypeArray ["student"] -- orchid
   put "green" into pTypeArray ["new student"]
   
   return pTypeArray
end person_TypeArray


--> Show
-
getprop show_Label
   put the graphic_Object of me into graphicObject
   put the showname of graphicObject into someBoolean
   return someBoolean
end show_Label

setprop show_Label someBoolean
   put the graphic_Object of me into graphicObject
   set the showname of graphicObject to someBoolean
   return graphicObject
end show_Label

private command hideLabelIfTooSmall graphicRect
   put item 3 of graphicRect - item 1 of graphicRect into gWidth
   -- put gWidth
   if gWidth < 30 then
      set the show_Label of me to false
   else
      set the show_Label of me to true
   end if
end hideLabelIfTooSmall

getprop show_ImageBorder
   return the showborder of me
   put the image_Group of me into imageGroup
   put the showborder of imageGroup into someBoolean
   return someBoolean
end show_ImageBorder

setprop show_ImageBorder someBoolean
   put the image_Group of me into imageGroup
   lock screen
   set the showborder of imageGroup to someBoolean
   set the showborder of me to someBoolean
   unlock screen
   return imageGroup
end show_ImageBorder

getprop show_Rounded
   put the ink of me into someInk
   if someInk is "blendSrcOver" then
      return true
   else
      return false
   end if
end show_Rounded

setprop show_Rounded someBoolean
   put the graphic_Object of me into graphicObject
   put the image_Object of me into imageObject
   
   lock screen
   set the ink of imageObject to "blendSrcAtop"
   if someBoolean is true then
      set the ink of me to "blendSrcOver"
      set the ink of graphicObject to "blendSrcOver"
      set the opaque of me to false
   else
      set the ink of me to "srcCopy"
      set the ink of graphicObject to "srcCopy"
   end if
   set the visible of graphicObject to someBoolean
   unlock screen
end show_Rounded

getprop show_Image 
   put the image_Object of me into imageObject
   put the visible of imageObject into someBoolean
   return someBoolean
end show_Image

setprop show_Image someBoolean
   put the image_Object of me into imageObject
   put the graphic_Object of me into graphicObject
   
   lock screen
   set the visible of imageObject to someBoolean
   if someBoolean is true then
      set the show_Rounded of me to true -- hack
      set the graphic_Style of me to "mask"
      if the burnt_Image of me is true then
         set the visible of graphicObject to false
         set the show_Rounded of me to false
      else
         set the visible of graphicObject to true
         set the showname of graphicObject to false
         set the show_Rounded of me to true
      end if
   else
      set the show_Rounded of me to false
      -- set the graphic_Style of me to "bue"
      set the visible of graphicObject to true
      set the showname of graphicObject to true
      set the person_Type of me to the person_Type of me
   end if
   unlock screen
   return someBoolean
end show_Image


--> Image
-
getprop image_ResizeQuality
   put the image_Object of me into imageObject
   put the resizeQuality of imageObject into someQuality
   return someQuality
end image_ResizeQuality

setprop image_ResizeQuality someQuality
   put the image_Object of me into imageObject
   set the resizeQuality of imageObject to someQuality
   return imageObject
end image_ResizeQuality

getprop image_ResizeQualities
   return "normal,good,best"
end image_ResizeQualities


--> Objects
-
getprop image_View
   return the long id of me
end image_View

getprop person_View
   return the long id of me
end person_View

getprop view_Object
   return the long id of me
end view_Object

getprop image_Group
   return the long id of group 1 of me
end image_Group

getprop image_Object
   return _imageObject()
end image_Object

getprop graphic_Object
    return the long id of grc 1 of me
 end graphic_Object
 
private function _imageObject
   return the long id of image 1 of me
end _imageObject

