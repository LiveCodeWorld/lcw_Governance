script "Global | Governance | Person | Menu"
--> MetaData
-
license: GPLv3
name: Global | Governance | Person | Menu
type: controller
version: 0.1

/*Was "Global | Image | Masked | Menu*/

on _AllMyTasks
   put asana_FetchMyWorkshopTaskArray() into myTaskArray
   --
   display_Array myTaskArray 
end _AllMyTasks

on _MyTasks indexView, workspaceName
   put asana_FetchWorkSpaceID (workspaceName) into workspaceID
   put asana_FetchUserTaskArray (workspaceID) into myTaskArray
   --
   display_Array myTaskArray 
end _MyTasks

on _UpdateMyWorkspaces
   put asana_FetchWorkspaceNames() into LocalArray ["MyWorkspaces"]
end _UpdateMyWorkspaces

on _PersonTasks personView
   put the displayed_Data of personView into asanaUserArray
   put asanaUserArray ["gid"] into userID
   
   local myTaskArray
   --
   put asanaUserArray ["workspaces"] into userWorkspaceArray
   repeat for each key indexNum in userWorkspaceArray
      set the cursor to busy
      put userWorkspaceArray [indexNum]["gid"] into workspaceID
      --
      asana_AddMyTaskArray myTaskArray, workspaceID, userID
   end repeat
   display_Array myTaskArray
end _PersonTasks

on _DisplayData personView
   put the displayed_Data of personView into asanaUserArray
   put asanaUserArray ["gid"] into userID
   put asanaUserArray ["email"] into userEmail
   put asanaUserArray ["photo"] into userPhotoArray
   put asanaUserArray ["resourceType"] is "person" into isPerson
   put asanaUserArray ["workspaces"] into userWorkspaceArray
   --
   put userID & CR & userEmail
   display_Array userWorkspaceArray
end _DisplayData


--> Menu | Props
-
local LocalArray

getprop menu_Target [tObject]
   if LocalArray ["MyWorkspaces"] is empty then
      put asana_FetchWorkspaceNames() into LocalArray ["MyWorkspaces"]
   end if
   put the person_View of tObject into pView
   return pView
end menu_Target

getprop resizeGraphic_Param [mTarget]
   if the long id of the target is not the long id of me then pass resizeGraphic_Param
   put the resize_Graphic of mTarget into someBoolean
   return someBoolean
end resizeGraphic_Param

getprop resizeGraphic_Params
   return "true,false"
end resizeGraphic_Params

getprop constrainGraphic_Param [mTarget]
   if the long id of the target is not the long id of me then pass constrainGraphic_Param
   put the constrain_Graphic of mTarget into someBoolean
   return someBoolean
end constrainGraphic_Param

getprop constrainGraphic_Params
   return "true,false"
end constrainGraphic_Params

getprop personType_Param [mTarget]
   put the person_Type of mTarget into someType
   return someType
end personType_Param

getprop personType_Params [mTarget]
   put the person_Types of mTarget into someTypes
   return someTypes
end personType_Params

getprop sizeImage_Param [mTarget]
   put round (the image_Magnification of mTarget * 100) into someSize
   if someSize = 100 then 
      return "full"
   else
      return someSize
   end if
end sizeImage_Param

getprop sizeImage_Params
   return "10,20,30,40,50,60,70,80,90,-,full,-,150,200,250,300,350,400"
end sizeImage_Params

getprop chooseImage_Params
   return "Online image,Local file,-,Reset internet"
end chooseImage_Params

getprop resizeQuality_Param [mTarget]
   put the image_ResizeQuality of mTarget into someQuality
   return someQuality
end resizeQuality_Param

getprop resizeQuality_Params
   return "normal,good,best"
end resizeQuality_Params

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

getprop myTasks_Params
   return LocalArray ["MyWorkspaces"]
end myTasks_Params

getprop checked_ShowImage [mTarget]
   put the show_Image of mTarget into sBoolean
   return sBoolean
end checked_ShowImage

getprop checked_ShowRounded [mTarget]
   put the show_Rounded of mTarget into sBoolean
   return sBoolean
end checked_ShowRounded

getprop checked_ShowImageBorder [mTarget]
   put the show_ImageBorder of mTarget into sBoolean
   return sBoolean
end checked_ShowImageBorder

getprop checked_Opaque [pView]
   return the opaque of pView
end checked_Opaque


--> Global | Governance | Person | Menu
-
on menu_ShowRounded mTarget
   put the show_Rounded of mTarget is false into sBoolean
   set the show_Rounded of mTarget to sBoolean
end menu_ShowRounded

on menu_ShowImage mTarget
   put the show_Image of mTarget is false into sBoolean
   set the show_Image of mTarget to sBoolean
end menu_ShowImage

on menu_ShowImageBorder mTarget
   put the show_ImageBorder of mTarget is false into sBoolean
   set the show_ImageBorder of mTarget to sBoolean
end menu_ShowImageBorder

on menu_Opaque pView
   set the opaque of pView to not the opaque of pView
end menu_Opaque

on _
end _

on menu_PersonType mTarget, someType
   set the person_Type of mTarget to someType
end menu_PersonType

on menu_BurnImage mTarget
   set the burnt_Image of mTarget to true
end menu_BurnImage

on menu_RestoreImageFile mTarget
   set the burnt_Image of mTarget to false
end menu_RestoreImageFile

on menu_SizeImage mTarget, someSize
   -- set the burnt_ImageWidth of mTarget to someSize
   if someSize = "full" then
      put 1 into someMag
   else
      put someSize / 100 into someMag
   end if
   set the image_Magnification of mTarget to someMag
end menu_SizeImage

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

on menu_ResizeQuality mTarget, someQuality
   set the image_ResizeQuality of mTarget to someQuality
end menu_ResizeQuality

on _
end _

on submenu_Image
   return "Global | Image | Menu"
end submenu_Image

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_ResizeGraphic mTarget, someBoolean
   set the resize_Graphic of mTarget to someBoolean
end menu_ResizeGraphic

on menu_ConstrainGraphic mTarget, someBoolean
   set the constrain_Graphic of mTarget to someBoolean
end menu_ConstrainGraphic

on menu_ShowRounded mTarget, someBoolean
   set the show_Rounded of mTarget to someBoolean
end menu_ShowRounded
