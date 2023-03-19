script "lib_AI"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_AI
type: library
version: 0.1

/*Some help*/


--> Working on
-
on mDoupleUp_DisplayOpenaiModel displayView, someLine
   breakpoint
   put the title_Text of displayView into someTitle
end mDoupleUp_DisplayOpenaiModel

command display_OpenAiModels
   put openAI_ListModels() into modelIDs
   sort modelIDs
   display_Data modelIDs, "OpenAI Models", "OpenAI"
   put the result into displayView
   --
   display_SetInteractions displayView, "OpenAI | Model", "mDoupleUp_DisplayOpenaiModel", "lib_AI"
   return displayView
end display_OpenAiModels


--> AI
-
command openAI_TestDalle
   put "b64_json" into pFormat
   put openAI_ConstructImageData ("A cute fox", 1, "small", pFormat) into rData
   --
   put rData [1][pFormat] into compressedImage
   put base64Decode( compressedImage) into somePNG
   --
   display_Image somePNG, "OpenAI Image"
   put the result into dView
   --
   return rData
end openAI_TestDalle

command openAI_TestCompletions
   put "https://api.openai.com/v1/chat/completions" into restUrl
   put openAI_ConstructMessageData ("Hello!") into postData
   put openAI_FetchData (postData, restUrl) into rData
   if rData is an array then
      display_Data rData, "Completions", "OpenAI"
   else
      -- false
      breakpont
   end if
   return rData
end openAI_TestCompletions

command openAI_TestEdits
   put "https://api.openai.com/v1/edits " into restUrl
   put openAI_ConstructEditData ("What day of the wek is it?", "Fix the spelling mistakes") into postData
   put openAI_FetchData (postData, restUrl) into rData
   
   if rData is an array then
      display_Data rData, "Edits", "OpenAI"
   else
      -- false
      breakpont
   end if
   return rData
end openAI_TestEdits

command openAI_TestCodex
   put "https://api.openai.com/v1/completions" into restUrl
   put openAI_ConstructCodexMessage () into postData
   put openAI_FetchData (postData, restUrl) into rData
   display_Data rData, "Codex", "OpenAI"
   --
   return rData
end openAI_TestCodex

command openAI_Test
   -- '{"model": "text-davinci-003", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 7}'
   
   /*
   put "https://api.openai.com/v1/chat/completions" into restUrl
   put openAI_ConstructMessageData ("Hello!") into postData
   put openAI_FetchData (postData, restUrl) into rData
   display_Data rData, "Completions", "OpenAI"
   --
   put "https://api.openai.com/v1/edits " into restUrl
   put openAI_ConstructEditData ("What day of the wek is it?", "Fix the spelling mistakes") into postData
   put openAI_FetchData (postData, restUrl) into rData
   display_Data rData, "Edits", "OpenAI"
   --
   put "https://api.openai.com/v1/completions" into restUrl
   put openAI_ConstructCodexMessage () into postData
   put openAI_FetchData (postData, restUrl) into rData
   display_Data rData, "Codex", "OpenAI"
   */
   
   put "b64_json" into pFormat
   put openAI_ConstructImageData ("A cute fox", 1, "small", pFormat) into rData
   --
   put rData [1][pFormat] into compressedImage
   put base64Decode( compressedImage) into somePNG
   --
   display_Image somePNG, "OpenAI Image"
   put the result into dView
   --
   return rData
end openAI_Test

function openAI_ConstructImageData imagePrompt, pNumberOfImages, pImageSize, pFormat
   -- imagePrompt is a text description of the desired image(s). The maximum length is 1000 characters.
   
   put "https://api.openai.com/v1/images/generations" into restURL
   --
   if pNumberOfImages is empty then put 1 into pNumberOfImages
   --
   switch pImageSize
      case empty
      case "small"
         put "256x256" into pImageSize
         break
      case "medium"
         put "512x512" into pImageSize
         break
      case "large"
         put "1024x1024" into pImageSize
         break
      default
         -- can specify
   end switch
   
   if pFormat is empty then put "b64_json" into pFormat -- or "ur"
   --
   put { \
         "prompt": imagePrompt, \
         "n": pNumberOfImages, \
         "size": pImageSize, \
         "response_format": pFormat \
         } into postData
   --
   put openAI_FetchData (postData, restUrl) into rData
   return rData ["data"]
end openAI_ConstructImageData

function openAI_ImagesSizes
   return "256x256,512x512,1024x1024"
end openAI_ImagesSizes

function openAI_ConstructMessageData sText
   -- "model": "gpt-3.5-turbo",
   -- "messages": [{"role": "user", "content": "Hello!"}]
   -- put { "model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": sText}] } into postData
   
   put { "model": "gpt-3.5-turbo", \
         "messages": [{"role": "user", \
         "content": sText}] } into postData
   --
   return postData
end openAI_ConstructMessageData

function openAI_ConstructCodexMessage
   /*
   curl https://api.openai.com/v1/completions \
   -H "Content-Type: application/json" \
         -H "Authorization: Bearer $OPENAI_API_KEY" \
         -d '{
   "model": "code-davinci-002",
   "prompt": "# Python 3\n# Calculate the mean distance between an array of points\n",
   "temperature": 0,
   "max_tokens": 256,
   "top_p": 1,
   "frequency_penalty": 0,
   "presence_penalty": 0
   }'
   */
   
   put { \
         "model": "code-davinci-002", \
         "prompt": "# Python 3\n# Calculate the mean distance between an array of points\n", \
         "temperature": 0, \
         "max_tokens": 100, \
         "top_p": 1.0, \
         "frequency_penalty": 0.2, \
         "presence_penalty": 0.0, \
         "stop": ["\n"] \
         } into postData
   --
   return postData
end openAI_ConstructCodexMessage

function openAI_ConstructEditData sInput, sInstruction
   get { "model": "text-davinci-edit-001", "input": sInput, "instruction": sInstruction, }
   return it
end openAI_ConstructEditData


--> OpenAI | Rest
-
function openAI_FetchData postData, restUrl
   put openAI_GetApiKey() into apiKey
   put jsonrpc_PostArray (postData, restUrl, apiKey) into rData
   return rData
end openAI_FetchData

function openAI_RestGet restURL
   put openAI_GetApiKey() into apiKey
   put jsonrpc_GetArray (restURL, apiKey) into rData
   return rData
end openAI_RestGet

function openAI_GetApiKey
   return secret_Get ("OpenAI")
end openAI_GetApiKey

command ai_SetApiKey apiKey
   secret_Set "OpenAI", apiKey
   put openAI_GetApiKey()
end ai_SetApiKey


--> OpenAI | Model
-
function openAI_ListModels
   put openAI_FetchModelData() into mData
   repeat with itemNum = 1 to item 2 of the extents of mData
      put mData [itemNum]["id"] into modelID
      put modelID & CR after modelIDs
   end repeat
   delete char -1 of modelIDs
   return modelIDs
end openAI_ListModels

function openAI_FetchModelData
   put "https://api.openai.com/v1/models" into restURL
   --
   put openAI_RestGet (restURL) into rData
   return rData ["data"]
end openAI_FetchModelData
