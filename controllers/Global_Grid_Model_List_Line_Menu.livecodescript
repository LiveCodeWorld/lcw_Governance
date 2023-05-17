script "Global | Grid | Model | List | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Model | List | Line | Menu
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
   put the display_View of tObject into dView
   put the list_Short of dView into LocalArray ["list_Short"]
   put the clicktext into shortNameOrFile
   return shortNameOrFile
end menu_Target


--> Global | Grid | Model | List | Line | Menu
-
on menu_Test shortNameOrFile
   put grid_GetShapeData (shortNameOrFile) into shapeData
   --
   display_Clone "View|Grid", "Grid Shape Data", shapeData, "displayed_Data", "mouse"
   put the result into dView
end menu_Test

on menu_Display shortNameOrFile
   put grid_GetShapeData (shortNameOrFile) into shapeData
   display_GridShapeData shapeData
end menu_Display

private command _
end _

on menu_Duplicate shortNameOrFile
   grid_DuplicateModel shortNameOrFile
   display_GridModels
end menu_Duplicate

on menu_Rename shapeTitle
   put LocalArray ["list_Short"] into listShort
   -- comment
   put lcw_Ask ("Rename model...", shapeTitle, "Grid Model") into newName
   put grid_ConstructModelFile (newName) into newPath
   if there is a file newPath then
      lcw_AnswerWarning "Model '[[newName]]' already exists. Choose a different name or delete first.", empty, newName
   end if
   --
   put grid_ConstructModelFile (shapeTitle) into mFile
   rename mFile to newPath
   --
   display_GridModels
end menu_Rename

on menu_Delete shortNameOrFile
   grid_DeleteModel shortNameOrFile, listShort
   --
   display_GridModels
end menu_Delete
