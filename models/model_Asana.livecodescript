script "model_Asana"
--> MetaData
-
license: GPLv3
name: model_Asana
type: model
version: 0.1

/*
Here we store in a local project array stuff we have fetched form the asana server.
Will need to figure out alternative server / blockchain storage for our own purposes later.
*/


--> Working on
-
function asana_GetTeamID teamName, workspaceIdOrName
   if workspaceIdOrName is a number then
      put workspaceIdOrName into workspaceID
   else
      breakpoint
      -- not done yet
   end if
   
   put asana_GetTeamData (workspaceID) into teamData
   repeat for each key teamItemNum in teamData
      put teamData [teamItemNum]["name"] into testTeamName
      if teamName = testTeamName then
         put teamData [teamItemNum]["gid"] into teamID
         return teamID
      end if
   end repeat
   
   breakpoint
   put "14716922790572" into teamID -- Governance Unlimited/Projects
   return teamID
   
   return empty
end asana_GetTeamID


--> Asana | Model | Utils
-
function asana_IsOrg nameOrNumber, pWorkspaceInfoArray
   put asana_GetOrgArray (pWorkspaceInfoArray) into orgArray
   repeat for each key workspaceID in orgArray
      if nameOrNumber is a number then
         if nameOrNumber = workspaceID then
            return true
         end if
      else
         put orgArray [workspaceID] into foundName
         if nameOrNumber = foundName then
            return true
         end if
      end if
   end repeat
   return false
end asana_IsOrg


--> Asana | Model | List
-
function asana_ListTeamNames workspaceID
   put asana_GetTeamData (workspaceID) into teamData
   repeat for each key teamItemNum in teamData
      put teamData [teamItemNum]["name"] into teamName
      put teamName & CR after teamNames
   end repeat
   delete char -1 of teamNames
   sort teamNames
   return teamNames
end asana_ListTeamNames

function asana_GetTeamData workspaceID
   put asana_GetWorkspaceInfoArray ("data") into dataArray
   repeat for each key itemNum in dataArray
      if dataArray [itemNum]["gid"] = workspaceID then
         put dataArray [itemNum]["teams"] into teamData
         return teamData
      end if
   end repeat
   return empty 
end asana_GetTeamData

function asana_ListTemplateNames
   put the model_Array ["asana_template.array"] of stack "lcw_Governance" into asanaData
   put keys (asanaData) into arrayKeys
   return arrayKeys 
end asana_ListTemplateNames

function asana_ListWorkspaces pWorkspaceInfoArray
   put asana_GetWorkspaceArray (pWorkspaceInfoArray) into spaceArray
   put _ListOrgNames (spaceArray) into spaceNames
   return spaceNames
end asana_ListWorkspaces

function asana_ListOrgs pWorkspaceInfoArray
   put asana_GetOrgArray (pWorkspaceInfoArray) into orgArray
   put _ListOrgNames (orgArray) into orgNames
   return orgNames
end asana_ListOrgs

function asana_ListAll pWorkspaceInfoArray
   if pWorkspaceInfoArray is empty then
      put asana_GetWorkspaceInfoArray ("data") into pWorkspaceInfoArray
   end if
   
   repeat for each key itemNum in pWorkspaceInfoArray
      put pWorkspaceInfoArray [itemNum]["name"] into workspaceName
      put workspaceName & CR after allNames
   end repeat
   delete char -1 of allNames
   sort allNames
   return allNames
end asana_ListAll

function asana_GetOrgArray pWorkspaceInfoArray
   put asana_GetOrgData (pWorkspaceInfoArray) into orgData
   return orgData ["org"]
end asana_GetOrgArray

function asana_GetWorkspaceArray pWorkspaceInfoArray
   put asana_GetOrgData (pWorkspaceInfoArray) into orgData
   return orgData ["workspace"]
end asana_GetWorkspaceArray

function asana_GetOrgData pWorkspaceInfoArray
   if pWorkspaceInfoArray is empty then
      put asana_GetWorkspaceInfoArray ("data") into pWorkspaceInfoArray
   end if
   
   repeat for each key itemNum in pWorkspaceInfoArray
      put pWorkspaceInfoArray [itemNum]["gid"] into workspaceID
      put pWorkspaceInfoArray [itemNum]["name"] into workspaceName
      put pWorkspaceInfoArray [itemNum]["is_organization"] into isOrg
      if isOrg is true then
         put workspaceName into orgData ["org"][workspaceID]
      else
         put workspaceName into orgData ["workspace"][workspaceID]
      end if
   end repeat
   return orgData
end asana_GetOrgData


--> Asana | Model
-
function asana_GetWorkspaceInfoArray someKey
   put the model_Array ["asana_workspace.array"] of stack "lcw_Governance" into asanaData
   put asanaData [someKey] into asanaArray
   return asanaArray 
end asana_GetWorkspaceInfoArray

command asana_SetWorkspaceInfoArray someKey, someValue
   put the model_Array ["asana_workspace.array"] of stack "lcw_Governance" into asanaData
   put someValue into asanaData [someKey]
   set the model_Array ["asana_workspace.array"] of stack "lcw_Governance" to asanaData
   return asanaData 
end asana_SetWorkspaceInfoArray


--> Asana | Template | Model
-
function asana_GetTemplateInfo infoKey, pTaskInfoArray
   if pTaskInfoArray is an array then
      return pTaskInfoArray ["info"][infoKey]
   else
      put asana_GetTemplateArray ("info") into infoArray
      return infoArray [infoKey]
   end if
end asana_GetTemplateInfo

function asana_GetTemplateArray someKey
   put asana_GetTemplateData() into asanaData
   put asanaData [someKey] into asanaArray
   return asanaArray 
end asana_GetTemplateArray

command asana_SetTemplateArray someKey, someValue
   put asana_GetTemplateData() into asanaData
   put someValue into asanaData [someKey]
   asana_SetTemplateData asanaData
   return asanaData 
end asana_SetTemplateArray

function asana_GetTemplateData
   put the model_Array ["asana_template.array"] of stack "lcw_Governance" into asanaData
   return asanaData 
end asana_GetTemplateData

command asana_SetTemplateData asanaData
   set the model_Array ["asana_template.array"] of stack "lcw_Governance" to asanaData
   put the result into modelDataFile
   return modelDataFile
end asana_SetTemplateData


--> Private
-
private function _ListOrgNames orgArray
   repeat for each key workspaceID in orgArray
      put orgArray [workspaceID] into orgName
      put orgName & CR after orgNames
   end repeat
   delete char -1 of orgNames
   sort orgNames
   return orgNames
end _ListOrgNames
