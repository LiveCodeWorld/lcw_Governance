script "Global_Governance_Person_Menu"
--> MetaData
-
license: GPLv3
name: Global_Governance_Person_Menu
type: controller
version: 0.1

/*
Was "Global | Image | Masked | Menu
*/


--> Global | Governance | Person | Menu
-
on menu_PersonType mTarget, someType
   set the person_Type of mTarget to someType
end menu_PersonType

getprop some_Type [mTarget]
   put the person_Type of mTarget into someType
   return someType
end some_Type

getprop some_Types [mTarget]
   put the person_Types of mTarget into someTypes
   return someTypes
end some_Types

on _
end _

on menu_BurnImage mTarget
   set the burnt_Image of mTarget to true
end menu_BurnImage

on menu_RestoreImageFile mTarget
   set the burnt_Image of mTarget to false
end menu_RestoreImageFile

-- on menu_BurnImageTo mTarget, someSize
set the burnt_Image [someSize] of mTarget to true
end menu_BurnImageTo

on menu_SizeImage mTarget, someSize
   -- set the burnt_ImageWidth of mTarget to someSize
   if someSize = "full" then
      put 1 into someMag
   else
      put someSize / 100 into someMag
   end if
   set the image_Magnification of mTarget to someMag
end menu_SizeImage

on _
end _

on menu_ChooseImage mTarget, chooseHow
   switch chooseHow
      case "Online image"
         put "https://upload.wikimedia.org/wikipedia/commons/2/2c/Bullant_head_detail.jpg" into someURL
         put lcw_Ask ("Add a url of an image...", someURL)into someURL
         set the image_File of mTarget to someURL
         set the show_Image of mTarget to true
         break
      case "Local file"
         answer file "Select an image..."
         if it is empty then exit to top
         --
         set the image_File of mTarget to it
         set the show_Image of mTarget to true
         break
      case "-"
      case "Reset internet"
         resetall
         break
   end switch
end menu_ChooseImage

on _
end _

on menu_ShowRounded mTarget, someBoolean
   set the show_Rounded of mTarget to someBoolean
end menu_ShowRounded

on menu_ShowImage mTarget, someBoolean
   set the show_Image of mTarget to someBoolean
end menu_ShowImage

on menu_ShowImageBorder mTarget, someBoolean
   set the show_ImageBorder of mTarget to someBoolean
end menu_ShowImageBorder

on _
end _

on menu_ResizeGraphic mTarget, someBoolean
   set the resize_Graphic of mTarget to someBoolean
end menu_ResizeGraphic

on menu_ResizeQuality mTarget, someQuality
   set the image_ResizeQuality of mTarget to someQuality
end menu_ResizeQuality

on menu_ConstrainGraphic mTarget, someBoolean
   set the constrain_Graphic of mTarget to someBoolean
end menu_ConstrainGraphic

on _
end _

on submenu_Image
   return "Global | Image | Menu"
end submenu_Image


on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Governance | Person | Menu | Props
-
getprop some_Size [mTarget]
   put round (the image_Magnification of mTarget * 100) into someSize
   if someSize = 100 then 
      return "full"
   else
      return someSize
   end if
end some_Size

getprop some_Sizes
   return "10,20,30,40,50,60,70,80,90,-,full,-,150,200,250,300,350,400"
end some_Sizes

getprop some_Quality [mTarget]
   put the image_ResizeQuality of mTarget into someQuality
   return someQuality
end some_Quality

getprop some_Qualities
   return "normal,good,best"
end some_Qualities

getprop show_Rounded [mTarget]
   put the show_Rounded of mTarget into someBoolean
   return someBoolean
end show_Rounded
   
getprop show_Image [mTarget]
   if the long id of the target is not the long id of me then pass show_Image
   put the show_Image of mTarget into someBoolean
   return someBoolean
end show_Image

getprop show_Rounded [mTarget]
   if the long id of the target is not the long id of me then pass show_Rounded
   put the show_Rounded of mTarget into someBoolean
   return someBoolean
end show_Rounded

getprop show_ImageBorder [mTarget]
   if the long id of the target is not the long id of me then pass show_ImageBorder
   put the show_ImageBorder of mTarget into someBoolean
   return someBoolean
end show_ImageBorder

-- getprop burn_Image [mTarget]
   return the burnt_Image of mTarget
end burn_Image

getprop resize_Graphic [mTarget]
   if the long id of the target is not the long id of me then pass resize_Graphic
   put the resize_Graphic of mTarget into someBoolean
   return someBoolean
end resize_Graphic

getprop constrain_Graphic [mTarget]
   if the long id of the target is not the long id of me then pass constrain_Graphic
   put the constrain_Graphic of mTarget into someBoolean
   return someBoolean
end constrain_Graphic


--> Global | Governance | Person | Menu | Disabled
-
getprop disabled_ResizeQuality [mTarget]
   if the burnt_Image of mTarget is true then return true
   
   put the resize_Graphic of mTarget into canResize
   if canResize is true then
      return false
   else
      return true
   end if
end disabled_ResizeQuality

getprop disabled_BurnImage [mTarget]
   put the burnt_Image of mTarget into isBurnt
   if isBurnt is true then
      return "delete"
   else
      return false
   end if
end disabled_BurnImage

getprop disabled_RestoreImageFile [mTarget]
   put the burnt_Image of mTarget into isBurnt
   if isBurnt is true then
      return false
   else
      return "delete"
   end if
end disabled_RestoreImageFile


--> Dev | Menu
-
on menu_ShowRounded mTarget, someBoolean
   set the show_Rounded of mTarget to someBoolean
end menu_ShowRounded
