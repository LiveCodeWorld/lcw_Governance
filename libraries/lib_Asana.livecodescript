script "lib_Asana"
--> MetaData
-
license: GPLv3
name: lib_Asana
type: library
version: 0.3

/*
This library is a wrapper for the Asana API - https://asana.com/developers/api-reference

See also model_Asana for storing project and task templates.
*/


--> Variables
-
constant ApiVersionNum = "1.0"

getprop dep_StackNames
   return "model_Secret"
end dep_StackNames


--> Working on
-
function asana_ConvertHtml someHTML
   -- put pageArray_Fetch("festivaljam.org", "design-considerations") into pageArray
   -- put pageArray ["story"][1]["text"] into someHTML
   --
   replace "<p>" with empty in someHTML
   repeat
      if matchChunk (someHTML, "(<strong>.*</strong>)\n", sChar, eChar) is true then
         put char sChar to eChar of someHTML into someLine
         put char 9 to -10 of someLine into someTitle
         put "#" && someTitle into char sChar to eChar of someHTML
      else
         exit repeat
      end if
   end repeat
   --
   replace "<strong>" with "__" in someHTML
   replace "</strong>" with "__" in someHTML
   --
   return someHTML
end asana_ConvertHtml

function asana_FetchMyTaskMarkdown  workspaceName, pWhich
   -- https://app.asana.com/0/760916584371100/list
   -- https://app.asana.com/0/760916584371100/calendar
   -- https://app.asana.com/0/760916584371100/files
   
   if pWhich is empty then put "Today" into pWhich
   
   put asana_FetchWorkSpaceID (workspaceName) into workspaceID
   --
   -- put asana_FetchMyWorkshopTaskArray (workspaceID, true) into myWorkshopTaskArray  
   put asana_FetchMyWorkshopTaskArray (workspaceID, true) into myWorkshopTaskArray  
   put asana_ConstructMyTaskArray (myWorkshopTaskArray, false) into myTaskArray
   --
   put myTaskArray [pWhich] into indexTaskArray
   repeat for each key indexNum in indexTaskArray
      put indexTaskArray [indexNum]["gid"] into taskID
      put indexTaskArray [indexNum]["name"] into taskName
      --
      put asana_FetchTaskArray (taskID) into taskArray
      put taskArray ["data"]["assignee_status"] into assigneeStatus
      switch assigneeStatus
         case "Today"
            -- https://app.asana.com/0/760916584371100/1155025743225649
            
            -- put taskArray ["data"]["gid"] into taskID
            -- put taskArray ["data"]["name"] into taskName
            
            put taskArray ["data"]["workspaceID"] into wsID
            put taskArray ["data"]["projects"] into projectsArray
            put taskArray ["data"]["tags"] into taskTags
            --
            put taskArray ["data"]["html_notes"] into taskHTML
            _FormatTaskHtml taskHTML
            --
            put merge ("https://app.asana.com/0/760916584371100/[[taskID]]") into taskURL
            
            put "- [" & taskURL && taskName & "]" & CR after myTaskMarkDown
            break
      end switch
   end repeat
   delete char -1 of myTaskMarkDown
   return myTaskMarkDown
end asana_FetchMyTaskMarkdown

private command _SetAsanaUserID @pUserID
   if pUserID is empty then put 14716884063745 into pUserID
end _SetAsanaUserID


--> Asana | Tasks
-
function asana_FetchUserTaskArray workspaceID, pUserID
   -- new way, but why do we need pUserID
   local myTaskArray
   
   /*
   put asana_FetchWorkspaceTaskListArray (workspaceID, pUserID) into workspaceTaskListArray
   put workspaceTaskListArray ["data"]["gid"] into userTaskListID   
   if userTaskListID is empty then return empty
   put asana_FetchUserTasks (userTaskListID) into responseArray
   -- put workspaceTaskListArray ["data"]["name"] into userTaskListName
   */
   
   put asana_FetchMyWorkshopTaskArray (workspaceID, true) into myWorkshopTaskArray  
   put asana_ConstructMyTaskArray (myWorkshopTaskArray, true) into myTaskArray
   return myTaskArray
end asana_FetchUserTaskArray

function asana_FetchTaskArray taskID, pWhichFields
   put taskID into pathBit
   if pWhichFields is not false then
      put "?opt_fields=notes,html_notes,name,projects,workspace,tags,start_on,likes,assignee_status" after pathBit
   end if
   --
   put asana_FetchArray ("tasks", pathBit) into someArray
   return someArray
end asana_FetchTaskArray

function asana_FetchMyWorkshopTaskArray workspaceID, pIncomplete
   -- You should specify one of workspace, project, tag, section
   
   put "?" into pathBit
   put "workspace=" & workspaceID after pathBit
   put "&assignee=me" after pathBit
   put "&opt_fields=name,assignee_status" after pathBit
   if pIncomplete is true then
      put "&completed_since=now" after pathBit
   end if
   --
   put asana_FetchArray ("tasks", pathBit) into someArray
   return someArray
end asana_FetchMyWorkshopTaskArray

function asana_FetchWorkspaceTaskListArray workspaceID, pUserID
   -- users/{user_gid}/user_task_list?workspace=1234
   _SetAsanaUserID pUserID
   put pUserID & "/user_task_list?workspace=" & workspaceID into restPathID
   put asana_FetchArray ("users", restPathID) into someArray
   return someArray
end asana_FetchWorkspaceTaskListArray

function asana_ConstructMyTaskArray responseArray, pMakePretty
   local inboxArray, todayArray, upcomingArray, laterArray
   
   put responseArray ["data"] into dataArray
   repeat for each key indexNum in dataArray
      put dataArray [indexNum] into taskArray
      put taskArray ["assignee_status"] into assigneeStatus
      --
      switch assigneeStatus
         case "inbox"
            _AddToMyTaskArray inboxArray, taskArray, pMakePretty
            break
         case "Today"
            _AddToMyTaskArray todayArray, taskArray, pMakePretty
            break
         case "Upcoming"
            _AddToMyTaskArray upcomingArray, taskArray, pMakePretty
            break
         case "Later"
            _AddToMyTaskArray laterArray, taskArray, pMakePretty
            break
         default
            _AddToMyTaskArray otherArray, taskArray, pMakePretty
      end switch
   end repeat
   --
   put inboxArray into myTaskArray ["Recently Assigned"]
   put todayArray into myTaskArray ["Today"]
   put upcomingArray into myTaskArray ["Upcoming"]
   put laterArray into myTaskArray ["Later"]
   
   if otherArray is an array then
      breakpoint
      put otherArray into myTaskArray ["Other"]
   end if
   return myTaskArray
end asana_ConstructMyTaskArray

private command _AddToMyTaskArray @arrayOrIndex, taskArray, pMakePretty
   if pMakePretty is true then
      put taskArray ["gid"] into taskID
      put taskArray ["name"] into taskName
      --
      -- put taskID into arrayOrIndex [taskName]
      put taskName & CR after arrayOrIndex
   else
      array_AddToNumbered arrayOrIndex, taskArray
   end if
end _AddToMyTaskArray

function asana_FetchWorkSpaceID workspaceName
   put asana_FetchWorkSpaceArray() into workspaceArray
   return workspaceArray [workspaceName]
end asana_FetchWorkSpaceID

command asana_AddMyTaskArray @myTaskArray, workspaceID, pUserID
   _SetAsanaUserID pUserID
   put asana_FetchWorkspaceTaskListArray (workspaceID, pUserID) into workspaceTaskListArray
   --
   put workspaceTaskListArray ["data"]["gid"] into userTaskListID   
   put workspaceTaskListArray ["data"]["name"] into userTaskListName
   --
   if userTaskListID is empty then return empty
   --
   put asana_FetchUserTasks (userTaskListID) into userTaskArray
   put userTaskArray ["data"] into myTaskArray [userTaskListName]
   return userTaskArray
end asana_AddMyTaskArray

function asana_FetchUserTasks userTaskListID
   /*
   -- GET /user_task_lists/{user_task_list_gid}/tasks
   GET /user_task_lists/159xxxxxxxxx130/tasks?completed_since=now&opt_fields=name,assignee_status
   
   completed_since=now will filter out completed tasks and give you only uncompleted tasks.
   assignee_status is the string value of the section - i.e. "today, “upcoming”, “later”, etc.
   */
   
   put userTaskListID & "/tasks" into restPathID
   put "?completed_since=now&opt_fields=name,assignee_status" after restPathID
   --
   put asana_FetchArray ("user_task_lists", restPathID) into someArray
   return someArray
end asana_FetchUserTasks

function asana_FetchUserTaskListArray userTaskListID
   -- user_task_lists/{user_task_list_gid}
   
   put asana_FetchArray ("user_task_lists", userTaskListID) into someArray
   return someArray
end asana_FetchUserTaskListArray

function asana_FetchTaskNotes taskID
   -- https://app.asana.com/api/1.0/tasks/1001
   put asana_FetchTaskArray (taskID) into taskArray
   put taskArray ["data"]["html_notes"] into taskHTML
   _FormatTaskHtml taskHTML
   return taskHTML
end asana_FetchTaskNotes

function asana_ParseTaskArray projectTaskData
   put empty into sectionTitle
   put empty into sectionTaskNames
   repeat with lineNum =1 to item 2 of the extents of projectTaskData
      get projectTaskData [lineNum]["resource_type"]
      -- if it is not "task" then next repeat -- they are all tasks
      
      put projectTaskData [lineNum]["gid"] into gid
      put projectTaskData [lineNum]["name"] into taskName
      put gid into taskNameArray [taskName]
      --
      switch
         case char -1 of taskName = ":"
            -- old way of marking sections
            put lineNum & comma after sectionLineNums
            --
            put taskName into sectionTitle
            put empty into taskArray [sectionTitle]
            break
         case sectionTitle is empty
            put empty into taskArray [taskName]
            break
         default
            put empty into taskArray [sectionTitle][taskName]
      end switch
      --
      put taskName & CR after taskNames
      put gid into lineNumArray [lineNum]
   end repeat
   delete char -1 of sectionLineNums
   delete char -1 of taskNames
   --
   put taskNames into parsedArray ["taskNames"]
   put sectionLineNums into parsedArray ["sectionLineNums"]
   put taskArray into parsedArray ["taskArray"]
   put taskNameArray into parsedArray ["taskNameArray"]
   --
   return parsedArray
end asana_ParseTaskArray

command asana_DeconstructTaskData responseArray, @taskName, @taskNotes, @assigneeName, @assigneeID, @hearts, @likes
   put responseArray ["data"] into taskData
   --
   put taskData ["name"] into taskName
   put taskData ["notes"] into taskNotes
   --
   put taskData ["projects"] into taskProjectArray
   --
   put taskData ["assignee"]["name"] into assigneeName
   put taskData ["assignee"]["gid"] into assigneeID
   --
   put taskData ["hearted"] into hearted
   put taskData ["hearts"] into hearts
   put taskData ["liked"] into liked
   put taskData ["likes"] into likes
   --
   return taskNotes
end asana_DeconstructTaskData


--> Asana | Wiki
-
command asana_CreateTaskFromWiki droppedURL
   put fedwiki_FetchDroppedFlagJson (droppedURL) into pageJSON
   put json_ToArray (pageJSON) into pageArray
   put pageArray ["title"] into taskName
   put pageArray ["story"][1]["text"] into taskNotes
   put CR & CR & droppedURL after taskNotes
   --
   asana_CreateProjectTask "854783096772498", taskName, taskNotes
   put the result into responseArray
   put responseArray ["data"]["gid"] into taskID
   
   put pageArray_Construct ("New Asana task", "Here is a link to the newly created Asana taks for this wiki page:") into fedwikiPageArray
   --
   put "# Asana" into someMarkdown
   -- put CR & "View this content in [[Asana]]:" after someMarkdown
   put "https://app.asana.com/0/854783096772498/" & taskID into taskURL
   put CR & CR & "View [[" & taskName & "]] in [" & taskURL && "asana.com]" after someMarkdown
   pageArray_AddMarkdown fedwikiPageArray, someMarkdown
   --
   return fedwikiPageArray
end asana_CreateTaskFromWiki

function asana_FetchProjectPageArray projectID
   put asana_FetchProjectInfo (projectID) into responseArray
   asana_DeconstructError responseArray, projectInfoArray, firstError
   if the result is true then return firstError
   -- display_Array projectInfoArray
   put projectInfoArray ["name"] into projectName
   put projectName into fedwikiPageArray ["title"]
   put pageArray_ConstructJournal (projectName) into fedwikiPageArray ["journal"]
   
   put projectInfoArray ["notes"] into projectNotes -- could be "html_notes"
   pageArray_AddText fedwikiPageArray, projectNotes
   
   put asana_FetchProjectTasks (projectID, true) into responseArray
   asana_DeconstructError responseArray, projectTaskArray, firstError
   if the result is true then return firstError
   -- display_Array projectTaskArray
   
   repeat with keyNum = 1 to item 2 of the extents of projectTaskArray
      put projectTaskArray [keyNum]["name"] into taskName
      put projectTaskArray [keyNum]["gid"] into taskID
      put projectTaskArray [keyNum]["html_notes"] into taskHTML
      _FormatTaskHtml taskHTML
      
      pageArray_SetTitle fedwikiPageArray, taskName
      pageArray_AddHtml fedwikiPageArray, taskHTML
   end repeat
   pageArray_StripJournal fedwikiPageArray
   return fedwikiPageArray
end asana_FetchProjectPageArray

command asana_Test
   -- https://app.asana.com/0/1199894684330889/1199936015567129
   -- put asana_FetchTaskPageArray ("1199936015567129") into fedwikiPageArray
   get asana_FetchTaskAttachments ("1199936015567129")
   put it ["data"][1] into aData
   put aData ["gid"] into attachmentID
   put aData ["name"] into shortFile
   put aData ["resource_type"] into aType
   --
   put asana_FetchAttachment (attachmentID) into someArray
   display_Data someArray
end asana_Test

function asana_FetchAttachment attachmentID
   -- GET /attachments/{attachment_gid}
   put asana_FetchArray ("attachments", attachmentID) into someArray
   return someArray
end asana_FetchAttachment

function asana_FetchTaskAttachments taskID
   -- GET /tasks/{task_gid}/attachments
   put taskID & "/attachments" into pathBit
   put asana_FetchArray ("tasks", pathBit) into someArray
   return someArray
end asana_FetchTaskAttachments

function asana_FetchTaskPageArray taskID
   put asana_FetchTaskArray (taskID) into taskArray
   _DeconstructTaskArray taskArray, taskName, taskHTML, taskTags
   put asana_ConvertHtml (taskHTML) into taskMarkdown
   --
   put pageArray_Construct (taskName, taskMarkdown) into fedwikiPageArray
   --
   put asana_FetchSubTasks (taskID) into subtaskArray
   repeat with keyNum = 1 to item 2 of the extents of subtaskArray
      put subtaskArray [keyNum]["name"] into subtaskName
      put subtaskArray [keyNum]["gid"] into subtaskID
      put subtaskArray [keyNum]["resource_type"] into resourceType
      if resourceType is not "task" then next repeat
      
      put asana_FetchTaskArray (subtaskID) into sArray
      _DeconstructTaskArray sArray, subtaskName, subtaskHTML, subtaskTags
      put asana_ConvertHtml (subtaskHTML) into subTaskMarkdown
      --
      pageArray_SetTitle fedwikiPageArray, subtaskName
      -- pageArray_AddHtml fedwikiPageArray, subtaskHTML
      pageArray_AddMarkdown fedwikiPageArray, subTaskMarkdown
   end repeat
   pageArray_StripJournal fedwikiPageArray
   return fedwikiPageArray
end asana_FetchTaskPageArray

private command _DeconstructTaskArray taskArray, @taskName, @taskHTML, @taskTags
   put taskArray ["data"]["name"] into taskName
   put taskArray ["data"]["html_notes"] into taskHTML
   _FormatTaskHtml taskHTML
   put taskArray ["data"]["tags"] into taskTags
end _DeconstructTaskArray

private command _FormatTaskHtml @taskHTML
   replace "</body>" with empty in taskHTML
   replace "<body>" with empty in taskHTML
   replace CR with (CR & "<p>") in taskHTML
   return word 1 to -1 of taskHTML
end _FormatTaskHtml


--> Asana | Task | Subtasks
-
function asana_FetchSubTasks taskID
   /*
   You can find all of the subtasks of a task via the /tasks/task-id/subtasks endpoint.
   GET    /tasks/{task_gid}/subtasks
   */
   put taskID & "/subtasks" into endPath
   get asana_FetchArray ("tasks", endPath)
   put it ["data"] into subtaskArray
   return subtaskArray
end asana_FetchSubTasks


--> Asana | Create
-
command asana_AskCreateEgg teamName, workspaceName, pProjectName, pProjectNotes
   put asana_GetTeamID (teamName, workspaceName) into teamID
   --
   asana_AskCreateProject "Egg", teamID, pProjectName, true
   put the result into resultArray
   return resultArray
end asana_AskCreateEgg

command asana_AskCreateProject templateName, teamID, pProjectName, pAsk
   put asana_GetTemplateArray (templateName) into asanaTemplateData
   if pProjectName is empty then
      put asanaTemplateData ["info"]["name"] into pProjectName
   end if
   put asanaTemplateData ["info"]["notes"] into projectNotes
   --
   if pAsk is true then
      put lcw_Ask ("What do you want to call the new project?", pProjectName) into pProjectName
      put lcw_Ask ("Edit the notes for this project...", projectNotes) into projectNotes
   end if
   --
   put pProjectName into asanaTemplateData ["info"]["name"]
   put projectNotes into asanaTemplateData ["info"]["notes"]
   --
   asana_CreateProjectFromTemplate teamID, asanaTemplateData
   put the result into resultArray
   return resultArray
end asana_AskCreateProject

command asana_CreateProjectFromTemplate teamID, asanaTemplateData
   put asanaTemplateData ["info"] into projectInfoArray
   put asanaTemplateData ["tasks"] into taskData
   put asanaTemplateData ["data"] into projectTaskArray
   --
   put projectInfoArray ["name"] into projectName
   put projectInfoArray ["notes"] into projectNotes
   --
   asana_CreateTeamProject teamID, projectName, projectNotes
   put the result into responseArray
   asana_DeconstructError responseArray, projectInfoData, firstError
   if the result is true then return firstError
   
   put projectInfoData ["gid"] into projectID
   put projectInfoData ["workspace"]["gid"] into workspaceID
   --
   put item 2 of the extents of projectTaskArray into maxItem
   repeat with itemNum = maxItem down to 1
      set the cursor to busy
      --
      put projectTaskArray [itemNum]["gid"] into taskID
      put taskData [taskID] into taskArray
      --
      -- add only the bits we want
      put taskArray ["name"] into taskName
      put taskName into cleanTaskArray ["name"]
      put taskArray ["notes"] into cleanTaskArray ["notes"]
      --
      -- put taskArray ["assignee"] into cleanTaskArray ["assignee"] -- not a user in organisation
      -- put taskArray ["followers"] into cleanTaskArray ["followers"]
      -- put taskArray ["parent"] into cleanTaskArray ["parent"]
      -- put taskArray ["projects"] into cleanTaskArray ["projects"]
      put taskArray ["tags"] into cleanTaskArray ["tags"]
      --
      put taskArray ["likes"] into likeArray
      if likeArray is an array then put likeArray into cleanTaskArray ["likes"]
      put taskArray ["due_on"] into cleanTaskArray ["due_on"]
      --
      -- put taskArray ["memberships"] into cleanTaskArray ["memberships"]
      -- put taskArray ["completed_at"] into cleanTaskArray ["completed_at"] -- can't be created
      -- asana_CreateProjectTask projectID, taskName, taskNotes
      --
      asana_CreateProjectTask projectID, cleanTaskArray
      put the result into responseArray
      --  
      asana_DeconstructError responseArray, responseData, firstError
      if the result is true then
         breakpoint
         put taskName into resultArray ["error"][itemNum]["name"]
         put responseArray into resultArray ["error"][itemNum]["errorArray"]
      else
         put responseData into resultArray ["data"][itemNum]
      end if
   end repeat
   return resultArray
end asana_CreateProjectFromTemplate

command asana_CreateWorkspaceProject workspaceID, projectName, projectNotes
   -- only for workspaces (not organisations with teams)
   -- /workspaces/workspace-id/projects
   put "workspaces/" & workspaceID & "/tasks" into restPath
   
   if projectName is an array then
      put projectName into postData
   else
      put projectNotes into postData ["data"]["notes"]
      put projectName into postData ["data"]["name"]
   end if
   --
   put asana_PostArray (restPath, postData) into responseArray
   return responseArray   
end asana_CreateWorkspaceProject

command asana_CreateTeamProject teamID, projectName, projectNotes
   -- teamID is required if workspace is an organisation
   -- /teams/team-id/projects
   put "teams/" & teamID & "/projects" into restPath
   --
   if projectName is an array then
      put projectName into postData
   else
      put projectNotes into postData ["data"]["notes"]
      put projectName into postData ["data"]["name"]
   end if
   --
   put asana_PostArray (restPath, postData) into responseArray
   return responseArray
end asana_CreateTeamProject

command asana_CreateWorkspaceTask workspaceID, taskName, taskNotes, pProjectID
   /*
   /workspaces/workspace-id/tasks
   Creating a new task is as easy as POSTing to the /tasks endpoint with a data block containing the fields you’d like to set on the task. 
   Any unspecified fields will take on default values.
   
   Every task is required to be created in a specific workspace, and this workspace cannot be changed once set. 
   The workspace need not be set explicitly if you specify a project or a parent task instead.
   */
   
   put taskNotes into postData ["data"]["notes"]
   put taskName into postData ["data"]["name"]
   if pProjectID is not empty then
      -- "project=14641"
      put pProjectID into postData ["data"]["projects"][1]["gid"]
   end if
   --
   put "workspaces/" & workspaceID & "/tasks" into restPath
   put asana_PostArray (restPath, postData) into responseArray
   return responseArray
end asana_CreateWorkspaceTask

command asana_CreateProjectTask projectID, taskName, taskNotes
   if taskName is an array then
      put taskName into postData ["data"]
   else
      put taskNotes into postData ["data"]["notes"]
      put taskName into postData ["data"]["name"]
   end if
   --
   put projectID into postData ["data"]["projects"][1]
   --
   put asana_PostArray ("tasks", postData) into responseArray
   return responseArray
end asana_CreateProjectTask


--> Asana | Project
-
function asana_FetchProjectInfo projectID
   -- /projects/project-id
   put asana_FetchArray ("projects", projectID) into someArray
   return someArray
end asana_FetchProjectInfo

function asana_FetchProjectTaskInfoArray projectID, pProjectTaskData
   put asana_FetchProjectInfo (projectID) into responseArray
   asana_DeconstructError responseArray, projectInfoData, firstError
   if the result is true then return firstError
   
   if pProjectTaskData is empty then
      put asana_FetchProjectTasks (projectID, true) into responseArray
      asana_DeconstructError responseArray, pProjectTaskData, firstError
      if the result is true then return firstError
   end if
   
   put asana_FetchProjectTaskInfo (pProjectTaskData) into projectTaskInfoArray
   put projectInfoData into projectTaskInfoArray ["info"]
   --
   return projectTaskInfoArray
end asana_FetchProjectTaskInfoArray

function asana_FetchProjectTaskInfo projectTaskData
   repeat for each key itemNum in projectTaskData
      set the cursor to busy
      put projectTaskData [itemNum]["gid"] into taskID
      put asana_FetchTaskArray (taskID) into responseArray
      --
      asana_DeconstructError responseArray, dataArray, firstError
      if the result is true then
         put firstError into projectTaskInfoArray ["tasks"][taskID]["error"]
      else
         put dataArray into projectTaskInfoArray ["tasks"][taskID]
      end if
   end repeat
   put projectTaskData into projectTaskInfoArray ["data"]
   return projectTaskInfoArray
end asana_FetchProjectTaskInfo


--> Asana | Project | Sections
-
function asana_FetchSectionArray projectID
   get asana_FetchProjectSections (projectID)
   put it ["data"] into sectionData
   repeat for each key itemNum in sectionData
      put sectionData [itemNum]["resource_type"] into resourceType
      if resourceType is not "section" then next repeat
      
      put sectionData [itemNum]["gid"] into gid
      put sectionData [itemNum]["name"] into projectName
      --
      put gid into sectionArray [projectName]
   end repeat
   return sectionArray
end asana_FetchSectionArray

function asana_FetchProjectSections projectID
   -- https://app.asana.com/api/1.0/projects/1331/sections
   put projectID & "/sections" into pathBit
   put asana_FetchArray ("projects", pathBit) into someArray
   return someArray
end asana_FetchProjectSections


--> Asana | Project | Tasks
-
function asana_FetchProjectTaskArray projectID
   put asana_FetchProjectTasks (projectID) into responseArray
   put _ConstructNameArray (responseArray, "task") into taskArray
   return taskArray
end asana_FetchProjectTaskArray

function asana_FetchProjectTasks projectID, pNotesOnly
   -- https://app.asana.com/api/1.0/projects/1331/tasks
   put projectID & "/tasks" into pathBit
   put asana_FetchProjectArray (pathBit) into someArray
   return someArray
end asana_FetchProjectTasks

function asana_FetchProjectArray projectID
   put "projects" into restPath
   if projectID is not empty then
      put "/" & projectID after restPath
   end if
   --
   put "?opt_fields=html_notes,name,projects,workspace,tags,start_on,likes" after restPath
   --
   put asana_FetchJSON (restPath) into someJSON
   put json_ToArray (someJSON) into someArray
   return someArray
end asana_FetchProjectArray

--> Asana | Teams
-
function asana_FetchTeamInfoArray teamID
   -- GET    /teams/team-id
   put asana_FetchArray ("teams", teamID) into teamInfoArray
   return teamInfoArray
end asana_FetchTeamInfoArray

function asana_FetchUserTeamsArray userID
   put asana_FetchUserTeams (userID) into responseArray
   put _ConstructNameArray (responseArray, "team") into teamArray
   return teamArray
end asana_FetchUserTeamsArray

function asana_FetchUserTeams userID
   -- /users/user-id/teams
   put userID & "/teams" into pathBit
   put asana_FetchArray ("users", pathBit) into someArray
   return someArray
end asana_FetchUserTeams

function asana_FetchTeamsArray workspaceID
   put asana_FetchTeams (workspaceID) into responseArray
   put _ConstructNameArray (responseArray, "team") into teamArray
   return teamArray
end asana_FetchTeamsArray

function asana_FetchTeams workspaceID
   -- Returns the compact records for all teams in the organization visible to the authorized user.
   -- /organizations/organization-id/teams
   put workspaceID & "/teams" into pathBit
   put asana_FetchArray ("organizations", pathBit) into someArray
   return someArray
end asana_FetchTeams


--> Asana | Task | Likes
-
function asana_GetTaskVoteNames taskData
   put asana_GetTaskVoteNameArray (taskData) into voteNameArray
   put keys (voteNameArray) into voteNames
   sort voteNames
   return voteNames
end asana_GetTaskVoteNames

function asana_GetTaskVoteNameArray taskData
   put asana_GetTaskLikeArray (taskData) into likeArray
   put item 2 of the extents of likeArray into taskVoteNum
   repeat with itemNum = 1 to taskVoteNum
      put likeArray [itemNum]["user"]["name"] into userName
      put likeArray [itemNum]["user"]["gid"] into userID
      --
      put userID into voteNameArray [userName]
   end repeat
   return voteNameArray
end asana_GetTaskVoteNameArray

function asana_GetTaskVoteNum taskData
   put asana_GetTaskLikeArray (taskData) into likeArray
   put item 2 of the extents of likeArray into taskVoteNum
   return taskVoteNum
end asana_GetTaskVoteNum

function asana_GetTaskLikeArray taskData
   put taskData ["likes"] into likeArray
   return likeArray
end asana_GetTaskLikeArray


--> Asana | users
-
function asana_FetchUserPhotoUrl userPhotoArray, pSize
   switch pSize
      case "small"
         put 21 into imageWidth
         -- put 27 into imageWidth
         break
      case "medium"
         --put 36 into imageWidth
         put 60 into imageWidth
         break
      default
         put 128 into imageWidth
   end switch
   put merge ("image_[[imageWidth]]x[[imageWidth]]") into imageKey
   put userPhotoArray [imageKey] into imageURL
   return imageURL
end asana_FetchUserPhotoUrl

command asana_DeconstructUserData responseArray, @userName, @userEmail, @userPhotoArray, @userWorkspaceArray
   put responseArray ["data"] into dataArray
   --
   put dataArray ["email"] into userEmail
   put dataArray ["name"] into userName
   --
   put dataArray ["workspaces"] into userWorkspaceArray
   put dataArray ["photo"] into userPhotoArray
   --
   return dataArray
end asana_DeconstructUserData

function asana_FetchUserData userID
   -- /users/user-id
   put asana_FetchArray ("users", userID) into someArray
   return someArray
end asana_FetchUserData

function asana_FetchWorkspaceUsers workspaceID
   put asana_FetchWorkspaceUserArray (workspaceID) into nameArray
   return keys (nameArray)
end asana_FetchWorkspaceUsers

function asana_FetchWorkspaceUserArray workspaceID
   put asana_FetchWorkspaceUserData (workspaceID) into someArray
   put _ConstructNameArray (someArray, "user") into nameArray
   return nameArray
end asana_FetchWorkspaceUserArray

function asana_FetchWorkspaceUserData workspaceID
   -- /workspaces/workspace-id/users
   put workspaceID & "/users" into pathBit
   put asana_FetchArray ("workspaces", pathBit) into someArray
   return someArray
end asana_FetchWorkspaceUserData

function asana_FetchTeamUserArray teamID
   put asana_FetchTeamUserData (teamID) into someArray
   put _ConstructNameArray (someArray, "user") into nameArray
   return nameArray
end asana_FetchTeamUserArray

function asana_FetchTeamUserData teamID
   -- /teams/team-id/users
   put teamID & "/users" into pathBit
   put asana_FetchArray ("teams", pathBit) into someArray
   return someArray
end asana_FetchTeamUserData


--> Asana | Workspace
-
function asana_FetchMyTasks workspaceName, pWhich
   if pWhich is empty then put "Today" into pWhich
   
   put asana_FetchWorkSpaceID (workspaceName) into workspaceID
   put asana_FetchUserTaskArray (workspaceID) into myTaskArray
   put myTaskArray [pWhich] into myTaskNames
   return myTaskNames
end asana_FetchMyTasks

function asana_FetchWorkspaceProjectsArray workspaceID
   put asana_FetchWorkspaceProjects (workspaceID) into responseArray
   put _ConstructNameArray (responseArray, "project") into projectsArray
   return projectsArray
end asana_FetchWorkspaceProjectsArray

function asana_FetchWorkspaceProjects workspaceID
   -- /workspaces/workspace-id/projects
   put workspaceID & "/projects" into pathBit
   put "?archived=" & "false" after pathBit
   put asana_FetchArray ("workspaces", pathBit) into someArray
   return someArray
end asana_FetchWorkspaceProjects

function asana_FetchWorkspaceInfoArray workspaceID
   -- /workspaces/workspace-id
   put asana_FetchArray ("workspaces", workspaceID) into someArray
   return someArray
end asana_FetchWorkspaceInfoArray

function asana_FetchWorkspaceNames
   put asana_FetchWorkSpaceArray() into workspaceArray
   put keys (workspaceArray) into workspaceNames
   sort workspaceNames
   return workspaceNames
end asana_FetchWorkspaceNames

function asana_FetchWorkSpaceArray
   put asana_FetchMe() into asanaArray
   put asanaArray ["data"]["workspaces"] into spacesArray
   repeat for each key itemNum in spacesArray
      put spacesArray [itemNum]["resource_type"] into resourceType
      if resourceType is not "workspace" then next repeat
      
      put spacesArray [itemNum]["gid"] into gid
      put spacesArray [itemNum]["name"] into spaceName
      --
      put gid into workspaceArray [spaceName]
   end repeat
   return workspaceArray
end asana_FetchWorkSpaceArray

function asana_FetchMe
   put asana_FetchArray ("users", "me") into someArray
   return someArray
end asana_FetchMe

function asana_FetchMyWorkSpaceData
   put asana_FetchMe() into asanaArray
   put asanaArray ["data"]["workspaces"] into myWorkSpaceData
   repeat for each key itemNum in myWorkSpaceData
      set the cursor to busy
      --
      put myWorkSpaceData [itemNum]["resource_type"] into resourceType
      if resourceType is not "workspace" then next repeat
      
      put myWorkSpaceData [itemNum]["gid"] into workspaceID
      put myWorkSpaceData [itemNum]["name"] into workspaceName
      --
      put asana_FetchWorkspaceInfoArray (workspaceID) into responseArray
      asana_DeconstructError responseArray, dataArray, firstError
      if the result is true then
         put responseArray into myWorkSpaceData [itemNum]["error"]
      else
         put dataArray into myWorkSpaceData [itemNum]
         --
         if dataArray ["is_organization"] is true then
            put asana_FetchTeams (workspaceID) into responseArray
            asana_DeconstructError responseArray, teamsData, firstError
            if the result is true then
               put firstError into myWorkSpaceData [itemNum]["teams"]["error"]
            else
               put teamsData into myWorkSpaceData [itemNum]["teams"]
            end if
         else
            -- nothing for workspaces
         end if
      end if   
   end repeat
   
   return myWorkSpaceData
end asana_FetchMyWorkSpaceData


--> Asana | Error
- 
function assana_GetData responseArray
   asana_DeconstructError responseArray, dataArray, firstError
   return dataArray
end assana_GetData

function assana_GetError responseArray
   asana_DeconstructError responseArray, dataArray, firstError
   return firstError
end assana_GetError

function assana_IsError responseArray
   asana_DeconstructError responseArray, dataArray, firstError
   return the result
end assana_IsError

command asana_DeconstructError responseArray, @dataArray, @firstError
   put responseArray ["data"] into dataArray
   put responseArray ["errors"] into errorArray
   put errorArray is an array into isError
   --
   if isError is true then
      put errorArray [1]["message"] & CR & errorArray [1]["help"] into firstError
   else
      put empty into firstError
   end if
   return isError
end asana_DeconstructError


--> Asana | REST
-
function asana_FetchArray pathStem, pPathID
   put pathStem into restPath
   if pPathID is not empty then
      put "/" & pPathID after restPath
   end if
   --
   put asana_FetchJSON (restPath) into someJSON
   put json_ToArray (someJSON) into someArray
   return someArray
end asana_FetchArray

function asana_PostArray restPath, postArray
   put json_FromArray (postArray) into someJSON
   put asana_PostJSON (restPath, someJSON) into someJSON
   put json_ToArray (someJSON) into responseArray
   return responseArray
end asana_PostArray

function asana_PostJSON restPath, someJSON
   -- curl -H "Authorization: Bearer 0/123456789abcdef" https://app.asana.com/api/1.0/users/me
   put merge ("https://app.asana.com/api/[[ApiVersionNum]]/") & restPath into restURL
   put asana_GetAuthenticationToken() into oAuthToken
   put jsonrpc_POST (someJSON, restUrl, oAuthToken) into someJSON
   return someJSON
end asana_PostJSON

function asana_FetchJSON restPath
   put asana_GetExtraHeaders() into extraHeaders
   --
   put merge ("https://app.asana.com/api/[[ApiVersionNum]]/") & restPath into restURL
   put asana_GetAuthenticationToken() into oAuthToken
   --
   put jsonrpc_GET (restURL, oAuthToken, empty, extraHeaders) into someJSON
   -- rest_SetJsonHeaders oAuthToken, empty, extraHeaders
   -- put url restURL into someJson
   return someJSON
end asana_FetchJSON

command rest_SetJsonHeaders pOAuthToken, pVersionNum, pExtraHeaders
   put "Content-type: application/json" into someHeader
   put CR & "Accept: application/json" after someHeader
   put CR & "Accept-Charset: utf-8" after someHeader
   --
   if pVersionNum is not empty then
      put "; version=" & pVersionNum after someHeader
   end if
   if pExtraHeaders is not empty then
      put CR & word 1 to -1 of pExtraHeaders after someHeader
   end if
   if pOAuthToken is not empty then
      put CR & "Authorization: Bearer" && pOAuthToken after someHeader
   end if
   --
   set the httpHeaders to someHeader
   return someHeader
end rest_SetJsonHeaders

function asana_GetExtraHeaders
   put "Asana-Enable: new_rich_text" into extraHeaders
   return extraHeaders
end asana_GetExtraHeaders



--> Asana | Authentication
-
function asana_GetAuthenticationToken
   put secret_Get ("AsanaAuthenticationToken", "asana") into oAuthToken
   return oAuthToken
end asana_GetAuthenticationToken

command asana_SetAuthenticationToken oAuthToken
   pref_SaveValue "AsanaAuthenticationToken", oAuthToken -- only for local
   -- secret_Set "AsanaAuthenticationToken", "asana", oAuthToken
   put the result into modelDataFile
   return modelDataFile
end asana_SetAuthenticationToken


--> Deps
-
command rest_SetUserAgent
   set the httpheaders to "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"
end rest_SetUserAgent

command array_AddToNumbered @indexedArray, keyOrArray, pValue
   /*
   Adds a value to the end of an indexed array.
   Value can be simple or an array
   If someKey is an array it adds the array
   */
   
   put item 2 of the extents of indexedArray + 1 into newIndexNum
   if keyOrArray is an array then
      put keyOrArray into indexedArray [newIndexNum]
   else
      put pValue into indexedArray [newIndexNum][keyOrArray]
   end if
   return newIndexNum
end array_AddToNumbered

--> Private
-
private function _ConstructNameArray responseArray, resourceType
   put responseArray ["data"] into dataArray
   repeat for each key itemNum in dataArray
      get dataArray [itemNum]["resource_type"]
      if it is not resourceType then next repeat
      
      put dataArray [itemNum]["gid"] into gid
      put dataArray [itemNum]["name"] into someName
      --
      put gid into nameArray [someName]
   end repeat
   return nameArray
end _ConstructNameArray
