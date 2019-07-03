script "Global_Asana_Project_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Asana_Project_Tree_Menu
type: controller
version: 0.1


--> Global | Asana | Project | Tree | Menu
-
on menu_ProjectInfo displayView
   -- put the meta_Data ["projectName"] of displayView into projectName
   put the meta_Data ["projectID"] of displayView into projectID
   put asana_FetchProjectInfo (projectID) into projectInfoData
   --
   display_Array projectInfoData
end menu_ProjectInfo

on menu_ProjectTaskData displayView, someName
   put asana_GetTemplateArray (someName) into projectTaskData
   --
   display_Array projectTaskData, someName
end menu_ProjectTaskData

on _
end _

on menu_SaveAsanaProject indexView
   put the meta_Data ["projectID"] of indexView into projectID
   --
   set the cursor to watch
   put the meta_Data ["projectTaskData"] of indexView into pProjectTaskData -- speeds things up a bit
   put asana_FetchProjectTaskInfoArray (projectID, pProjectTaskData) into projectTaskInfoArray
   --
   if projectTaskInfoArray is not an array then
      put projectTaskInfoArray into firstError
      dispatch "lcw_WarnAndExit" to indexView with firstError,true
   end if
   --
   put the meta_Data ["projectName"] of indexView into projectName
   put lcw_Ask ("What do you want to call this stored Asana project?", projectName) into someKey
   asana_SetTemplateArray someKey, projectTaskInfoArray
   --
   put the result into asanaData
   display_Array asanaData, ("Saved" && projectName)
end menu_SaveAsanaProject

on menu_RefreshProject indexView
   put the meta_Data ["projectID"] of indexView into projectID
   put the meta_Data ["projectName"] of indexView into projectName
   --
   display_AsanaProject projectID, projectName, indexView
end menu_RefreshProject

on _
end _

on menu_CreateMeeting indexView
   breakpoint
   
   put the meta_Data ["workspaceID"] of indexView into workspaceID
   put asana_GetTeamID (teamName, workspaceID) into teamID
   --
   asana_AskCreateProject "Meeting", teamID, pProjectName, true
   put the result into resultArray
   --
   lcw_Notify "Created Meeting!"
end menu_CreateMeeting


--> Global | Asana | Project | Tree | Menu | Props
-
getprop some_Names
   put asana_ListTemplateNames() into arrayKeys
   return arrayKeys
end some_Names


--> Global | Asana | Project | Tree | Menu | Disabled
-
