script "model_Grid"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: model_Grid
type: model
version: 0.1


--> Variables
-
constant GridViewName = "View|Grid"
constant GridProjectName = "lcw_Governance"


--> Working on
-


--> Grid | Model | List
-
function grid_ListModelShortFiles
   put module_ListModelShortFiles (GridViewName, GridProjectName) into shortFiles
   return shortFiles
end grid_ListModelShortFiles

function grid_ListModelNames pAddModel
   put module_ListModelNames (GridViewName, GridProjectName) into gridModelNames
   --
   if pAddModel is not true then return gridModelNames
   
   repeat for each line mName in gridModelNames
      put mName && "Model" & CR after modelNameList
   end repeat
   delete char -1 of modelNameList
   return modelNameList
end grid_ListModelNames


--> Grid | Model
-
function grid_GetShapeData shortNameOrFile
   put module_GetModel (shortNameOrFile, GridViewName, GridProjectName) into shapeData
   return shapeData
end grid_GetShapeData

command grid_SetShapeData shortNameOrFile, shapeData
   module_SetModel shortNameOrFile, GridViewName, GridProjectName, shapeData
   put the result into mFile
   return mFile
end grid_SetShapeData

command grid_DuplicateModel shortNameOrFile
   module_DuplicateModel shortNameOrFile, GridViewName, GridProjectName
end grid_DuplicateModel

command grid_DeleteModel shapeTitle
   module_DeleteModel shapeTitle, GridViewName, GridProjectName
end grid_DeleteModel

function grid_ConstructModelFile shortNameOrFile
   return module_ConstructModelFile (shortNameOrFile, GridViewName, GridProjectName)
end grid_ConstructModelFile
