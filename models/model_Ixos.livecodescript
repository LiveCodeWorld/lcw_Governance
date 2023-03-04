script "model_Ixos"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: model_Ixos
type: model
version: 0.1


--> Props | Chart
-
getprop charts_Visible
   put the card_Object of the target into cObject
   if exists (cObject) is empty then return empty
   --
   put the top_Chart of cObject into topChart
   if exists (topChart) is false then return empty
   --
   return the visible of topChart 
end charts_Visible

setprop charts_Visible sBoolean
   put the card_Object of the target into cObject
   if exists (cObject) is empty then return empty
   --
   lock screen
   put the top_GroupNames of cObject into gNames
   repeat for each line gName in gNames
      put the long id of group gName of cObject into ixView
      --
      if sBoolean is true then
         put the csv_Data of ixView into someCSV
      end if
      
      if exists (widget gName of cObject) then
         put the long id of widget gName of cObject into chartObject
         --
         if sBoolean is true then
            set the displayed_Data of chartObject to someCSV
         end if
         --
         put the dg_Rect of ixView into dgRect
         set the rect of chartObject to dgRect
         set the visible of chartObject to sBoolean
      end if
   end repeat
   unlock screen
   return gNames
end charts_Visible

getprop stack_Charts
   put the stack_Object of the target into sObject
   return the top_Charts of sObject
end stack_Charts

getprop top_Chart
   put the top_ViewObject ["View|ixOS|Chart"] of the target into topChart
   return topChart
end top_Chart

getprop top_ChartNames
   put the top_ViewNames ["View|ixOS|Chart"] of the target into topChartNames
   return topChartNames
end top_ChartNames

getprop top_Charts
   put the top_ViewObjects ["View|ixOS|Chart"] of the target into topCharts
   return topCharts
end top_Charts

getprop ix_ViewNames
   put the top_ViewNames ["View|ixOS"] of the target into ixViewNames
   put the top_GroupNames of me into ixViewNames
   return ixViewNames
end ix_ViewNames

getprop ix_Views
   -- put the top_Groups of the target into ixViews
   put the top_ViewObjects ["View|ixOS"] of the target into ixViews
   return ixViews
end ix_Views


--> Ixos | Model
-
getprop view_ModelName [pModelName]
   if pModelName is empty then put the short name of the target into pModelName
   
   if char 1 to 5 of pModelName = "View|" then
      delete char 1 to 5 of pModelName
   end if
   return pModelName
end view_ModelName

getprop view_ModelShortFile [pModelName]
   put the view_ModelName [pModelName] of me into pModelName
   --
   set the itemdelimiter to "."
   if the number of items of pModelName = 1 then
      put pModelName & ".array" into shortFile
   else
      put pModelName into shortFile
   end if
   return shortFile
end view_ModelShortFile


--> View | Model
-
getprop module_ModelFile [pModelName]
   put the view_ModelShortFile [pModelName] of the target into shortFile
   put the template_Object of the target into templateObject
   if exists (templateObject) is false then return empty
   --
   put the module_ModelFolder of templateObject into modelDataFolder
   put dataFolder_GetFile (modelDataFolder, shortFile) into mFile
   return mFile
end module_ModelFile

getprop module_ModelFolder
   put the module_Folder of the target into moduleFolder
   put folder_AddShort (moduleFolder, "models") into moduleModelFolder
   return moduleModelFolder
end module_ModelFolder

getprop module_Model [pModelName]
   put the module_ModelFile [pModelName] of the target into modelDataFile
   if modelDataFile is empty then return empty
   -- 
   put array_FetchModel (modelDataFile) into modelArray
   return modelArray
end module_Model

setprop module_Model [pModelName] dataArray
   put the module_ModelFile [pModelName] of the target into mFile   
   if mFile is empty then return empty
   -- 
   array_SaveModel mFile, dataArray
   return mFile
end module_Model

getprop module_ModelNames [listShortFiles]
   put the module_ModelFolder of the target into modelDataFolder
   put folder_ListShortFiles (modelDataFolder) into shortFiles
   if listShortFiles is not true then
      replace ".array" with empty in shortFiles
   end if
   return shortFiles
end module_ModelNames


--> Objects
-
getprop ix_Arrows
   put the ix_LinkArray of the target into ixLinkArray
   return ix_GetArrows(ixLinkArray)
end ix_Arrows

function ix_GetArrows ixLinkArray
   repeat for each key fromName in ixLinkArray
      put ixLinkArray [fromName] into toArray
      repeat for each key toName in toArray
         put ixLinkArray [fromName][toName]["arrowView"] into arrowView
         put arrowView & CR after arrowViews
      end repeat
   end repeat
   delete char -1 of arrowViews
   return arrowViews
end ix_GetArrows

getprop ix_LinkArray
   put the card_Object of the target into cObject
   put the ix_Views of cObject into ixViews
   --
   repeat for each line fromView in ixViews
      put the short name of fromView into fromName
      --
      repeat for each line toView in ixViews
         if toView = fromView then next repeat -- not self
         --
         put the displayed_Data of toView into dData
         put array_IndexFind (dData, "title", fromName) into foundIndexNum
         if foundIndexNum > 0 then
            put the short name of toView into toName
            put foundIndexNum into ixLinkArray [fromName][toName]["indexNum"]
            put toView into ixLinkArray [fromName][toName]["toView"]
            put fromView into ixLinkArray [fromName][toName]["fromView"]
            --
            put ix_ConstructArrowName (fromView, toView) into aName
            if exists (graphic aName of cObject) then
               put the rugged_ID of graphic aName of cObject into ixLinkArray [fromName][toName]["arrowView"]
            end if
         end if
      end repeat
   end repeat
   return ixLinkArray
end ix_LinkArray

function ix_ConstructArrowName fromView, toView
   if exists (fromView) is false then return empty
   put the short name of fromView into arrowName
   
   if exists (toView) is false then return empty
   put space & "-" && the short name of toView after arrowName
   return arrowName
end ix_ConstructArrowName

function ix_ListDisplayCharts
   put display_FindStackNameArray (empty, empty, true) into displayViewArray
   put display_ListStackNames
end ix_ListDisplayCharts

function ix_ListDisplayChartNames
   put stack_FindNameData ("Chart") into stackNameData
   put keys (stackNameData) into stackNames
   sort stackNames
   return stackNames
end ix_ListDisplayChartNames
