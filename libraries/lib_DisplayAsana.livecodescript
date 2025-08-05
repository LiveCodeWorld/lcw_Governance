script "lib_DisplayAsana"
--> MetaData
-
license: GPLv3
name: lib_DisplayAsana
type: library
version: 0.2


--> Working on
-
on mDoubleUp_AsanaTask indexView, taskName
   put the selected_Index of indexView into taskName
   put the displayed_Array of indexView into taskNameArray
   put taskNameArray [taskName] into taskID
   --
   if char -1 of taskName = ":" then
      -- section
   else
      display_AsanaTask taskID
   end if
end mDoubleUp_AsanaTask

on mDoubleUp_AsanaTeams indexView, teamName
   put the meta_Data ["workspaceID"] of indexView into workspaceID
   put the meta_Data ["workspaceName"] of indexView into workspaceName
   put the meta_Data ["teamArray"] of indexView into teamArray
   put teamArray [teamName] into teamID
   -- put asana_FetchTeamsArray (workspaceID) into teamArray
   --
   display_AsanaTeam teamID, teamName
end mDoubleUp_AsanaTeams

on mDoubleUp_AsanaTeam indexView, userName
   put the meta_Data ["teamID"] of indexView into teamID
   put the meta_Data ["teamName"] of indexView into teamName
   put the meta_Data ["userTeamArray"] of indexView into userTeamArray
   --
   put userTeamArray [userName] into userID
   display_AsanaUser userID
end mDoubleUp_AsanaTeam


--> Display
-
command display_AsanaTask taskID, pTitle
   if taskID is empty then
      breakpoint -- debug
      return empty
   end if
   --
   put asana_FetchTaskArray (taskID) into responseArray
   asana_DeconstructTaskData responseArray, taskName, taskNotes, assigneeName, assigneeID, hearts, likes
   put the result into taskNotesHtml
   --
   if pTitle is empty then
      put taskName into pTitle
   end if
   --
   display_Lines taskNotesHtml, pTitle, empty, "Asana Task"
   put the result into indexView
   set the field_Style of indexView to "text"
   set the title_Menu of indexView to "Global | Asana | Tree | Menu"
   set the line_Menu of indexView to "Global | Asana | Tree | Line | Menu"
   --
   set the task_ID of indexView to taskID
   -- set the displayed_Array of indexView to taskData
   return indexView
end display_AsanaTask

command display_AsanaUser userID
   if userID is empty then
      breakpoint -- debug
      return empty
   end if
   put asana_FetchUserData (userID) into responseArray
   asana_DeconstructUserData responseArray, userName, userEmail, userPhotoArray, userWorkspaceArray
   put the result into dataArray
   put asana_FetchUserPhotoUrl (userPhotoArray) into photoURL
   
   put "View|Governance|Person" into viewName
   display_ClonedView viewName, true, "Asana User"
   put the result into personView
   --
   set the displayed_Array of personView to dataArray
   
   -- set the image_File of personView to photoURL
   rest_SetUserAgent
   put url photoURL into someImage
   set the image_Content of personView to someImage
   put the stack_Name of personView into cloneStackName
   set the label of stack cloneStackName to userName
   --
   show stack cloneStackName -- "Asana User 1"
   --
   return cloneStackObject
end display_AsanaUser

command display_AsanaTeam teamID, teamName
   put asana_FetchTeamUserArray (teamID) into userTeamArray
   --
   display_Lines userTeamArray, teamName, "mDoubleUp_AsanaTeam", "Asana Team", true
   put the result into indexView
   --
   set the title_Menu of indexView to "Global | Asana | Team | Tree | Menu"
   set the line_Menu of indexView to "Global | Asana | Team | Tree | Line | Menu"
   --
   set the meta_Data ["teamID"] of indexView to teamID
   set the meta_Data ["teamName"] of indexView to teamName
   set the meta_Data ["userTeamArray"] of indexView to userTeamArray
   --
   return displayView
end display_AsanaTeam

on display_AsanaWorkspaces
   local inspectCommand, mDoubleUpCommand
   put asana_FetchWorkSpaceArray() into someArray
   --
   display_Lines someArray, "Workspaces", "mDoubleUp_AsanaWorkSpaces", "Asana", true
   put the result into displayView
   set the title_Menu of displayView to "Global | Asana | Tree | Menu"
   set the line_Menu of displayView to "Global | Asana | Tree | Line | Menu"
end display_AsanaWorkspaces

command display_AsanaWorkspace workspaceID, workspaceName
   put asana_FetchWorkspaceProjectsArray (workspaceID) into projectsArray
   --
   display_Lines projectsArray, workspaceName, "mDoubleUp_AsanaProject", "Asana Projects", true
   put the result into displayView
   --
   set the title_Menu of displayView to "Global | Asana | Workspace | Tree | Menu"
   set the line_Menu of displayView to "Global | Asana | Workspace | Tree | Line | Menu"
   --
   set the meta_Data ["workspaceID"] of displayView to workspaceID
   set the meta_Data ["workspaceName"] of displayView to workspaceName
   --
   return displayView
end display_AsanaWorkspace

command display_AsanaTeams workspaceID, workspaceName
   put asana_FetchTeamsArray (workspaceID) into teamArray
   --
   display_Lines teamArray, workspaceName, "mDoubleUp_AsanaTeams", "Asana Teams", true
   put the result into displayView
   --
   set the title_Menu of displayView to "Global | Asana | Team | Tree | Menu"
   set the line_Menu of displayView to "Global | Asana | Team | Tree | Line | Menu"
   --
   set the meta_Data ["workspaceID"] of displayView to workspaceID
   set the meta_Data ["workspaceName"] of displayView to workspaceName
   set the meta_Data ["teamArray"] of displayView to teamArray
   --
   return displayView
end display_AsanaTeams

command display_AsanaProject projectID, projectName, pIndexView
   if projectID is empty then
      breakpoint -- debug
      return empty
   end if
   put asana_FetchProjectTasks (projectID) into responseArray
   put responseArray ["data"] into projectTaskData
   put asana_ParseTaskArray (projectTaskData) into parsedArray
   --
   put parsedArray ["taskNames"] into taskNames
   put parsedArray ["sectionLineNums"] into sectionLineNums
   put parsedArray ["taskArray"] into taskArray
   put parsedArray ["taskNameArray"] into taskNameArray
   --
   line_AddBlank taskNames, sectionLineNums
   --
   if exists (pIndexView) is false then
      -- should fix to create invisible then show at end to avoid two stage show
      display_Lines taskNames, projectName, "mDoubleUp_AsanaTask", "Asana Tasks", true
      put the result into displayView
      set the title_Lines of displayView to sectionLineNums
   else
      put pIndexView into displayView
      lock screen
      set the displayed_Index of displayView to taskNames
      set the title_Lines of displayView to sectionLineNums
      unlock screen
   end if
   --
   set the title_Menu of displayView to "Global | Asana | Project | Tree | Menu"
   set the line_Menu of displayView to "Global | Asana | Project | Tree | Line | Menu"
   --
   set the displayed_Array of displayView to taskNameArray
   --
   set the meta_Data ["projectID"] of displayView to projectID
   set the meta_Data ["projectName"] of displayView to projectName
   set the meta_Data ["projectTaskData"] of displayView to projectTaskData
   --
   return displayView
end display_AsanaProject

command display_AsanaWorkspaceMembers workspaceID, pTitle
   if workspaceID is empty then
      breakpoint -- debug
      return empty
   end if
   if pTitle is empty then put "Users" into pTitle
   put asana_FetchWorkspaceUserArray (workspaceID) into responseArray
   --
   display_Lines responseArray, pTitle, "mDoubleUp_AsanaUser", "Asana Workspace Users", true
   put the result into indexView
   return indexView
end display_AsanaWorkspaceMembers


--> Display | Events
-
on mDoubleUp_AsanaUser indexView, userName
   put the selected_Index of indexView into userName
   put the displayed_Array of indexView into nameArray
   put nameArray [userName] into userID
   --
   display_AsanaUser userID
   --
   -- display_Array userWorkspaceArray
end mDoubleUp_AsanaUser

on mDoubleUp_AsanaWorkSpaces indexView, workspaceName
   put the selected_Value of indexView into workspaceID
   display_AsanaWorkspace workspaceID, workspaceName
end mDoubleUp_AsanaWorkSpaces

on mDoubleUp_AsanaProject indexView, projectName
   put the selected_Index of indexView into projectName
   put the displayed_Array of indexView into projectArray
   put projectArray [projectName] into projectID
   -- 
   display_AsanaProject projectID, projectName
   put the result into displayView
end mDoubleUp_AsanaProject


--> Deps
-
command line_AddBlank @taskNames, @sectionLineNums
   put the number of items of sectionLineNums into maxNum
   repeat with itemNum = maxNum down to 1
      put item itemNum of sectionLineNums into sectionLineNum
      put CR before line sectionLineNum of taskNames
   end repeat
   --
   if line 1 of taskNames is empty then
      delete line 1 of taskNames
      put -1 into extraNum
   else
      put 0 into extraNum
   end if
   --
   repeat with itemNum = 1 to maxNum
      add 1 to extraNum
      put item itemNum of sectionLineNums into sectionLineNum
      add extraNum to sectionLineNum
      put sectionLineNum into item itemNum of sectionLineNums
   end repeat
end line_AddBlank
