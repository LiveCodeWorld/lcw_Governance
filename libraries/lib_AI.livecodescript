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


--> OpenAi | Working on
-
function openAI_GetProcessedPageText promptSlug, wikiDomain, pageSlug, pModel
   put wikiPage_GetText (wikiDomain, pageSlug) into userText
   
   # Get ChatGPT reply
   put prompt_Process (userText, promptSlug, pModel) into sText
   return sText
end openAI_GetProcessedPageText

function openAI_FetchProcessedPageText promptSlug, wikiDomain, pageSlug, pModel, pProtocol, pPort
   put wikiPage_FetchText (wikiDomain, pageSlug, pPort, pProtocol) into userText
   
   # Get ChatGPT reply
   put prompt_Process (userText, promptSlug, pModel) into sText
   return sText
end openAI_FetchProcessedPageText


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


--> OpenAI | Image
-
command openAI_CreateImage sPrompt
   if sPrompt is empty then
      put "a white siamese cat" into sPrompt
   end if
   
   put openAI_GenerateImageArray (sPrompt) into imageArray
   -- return json_FromArray (imageArray, "", true)
   -- display_Data imageArray
   
   openAI_DeconstructImageArray imageArray, sImage, revisedPrompt
   --
   display_Image sImage, sPrompt
   put the result into imageObject
   --
   set the revised_Prompt of imageObject to revisedPrompt
   set the image_Prompt of imageObject to sPrompt
   --
   return revisedPrompt
end openAI_CreateImage

function openAI_GenerateImageArray sPrompt, pImageDimensions
   /*
   The image generations endpoint allows you to create an original image given a text prompt. 
   When using DALL·E 3, images can have a size of 1024x1024, 1024x1792 or 1792x1024 pixels.
   By default, images are generated at standard quality, but when using DALL·E 3 you can set quality: "hd" for enhanced detail. 
   Square, standard quality images are the fastest to generate.
   */
   
   put "https://api.openai.com/v1/images/generations" into restURL
   if pImageDimensions is empty then
      put "1024x1024" into pImageDimensions
   end if
   
   # Image content setup
   put "dall-e-3" into postData ["model"]
   put sPrompt into postData ["prompt"]
   put 1 into postData ["n"]
   put pImageDimensions into postData ["size"]
   put "b64_json" into postData ["response_format"]
   
   # Fetch
   put _FetchPostData (postData, "images/generations") into imageArray
   return imageArray
end openAI_GenerateImageArray

command openAI_DeconstructImageArray imageArray, @sImage, @revisedPrompt
   put imageArray ["data"][1]["revised_prompt"] into revisedPrompt
   put imageArray ["data"][1]["url"] into imageURL
   put imageArray ["data"][1]["b64_json"] into base64image
   put base64Decode (base64image) into sImage
   
   return sImage
end openAI_DeconstructImageArray

function openAI_VisionData imageUrl, imageQuestion, pTemp
   # Basics
   put "" into sPrompt
   put "" into pUserText
   put _ConstructMessagePostData (pUserText, sPrompt, "gpt-4-turbo", pTemp, 300) into postData
   
   # Image content setup
   put "user" into postData ["messages"][1]["role"]
   put "text" into postData ["messages"][1]["content"][1]["type"]
   put imageQuestion into postData ["messages"][1]["content"][1]["text"]
   --
   put "image_url" into postData ["messages"][1]["content"][2]["type"]
   put imageUrl into postData ["messages"][1]["content"][2]["image_url"]["url"]
   
   -- return json_FromArray (postData, "", true)
   
   # Fetch Vision Data
   put _FetchPostData (postData, "chat/completions") into rData
   --
   -- return json_FromArray (rData, "", true)
   display_Data rData
   return rData
end openAI_VisionData


--> OpenAI
-
command openAI_TextToSpeech someText, pAudioFile, pWhisperVoice, pUseHD
   if pWhisperVoice is empty then put "alloy" into pWhisperVoice
   if someText is empty then put "Thanks for all the Fish!" into someText   
   if pUseHD is not false then
      put "tts-1-hd" into postData ["model"]
   else
      put "tts-1" into postData ["model"]
   end if
   if pAudioFile is empty then put the tempname & ".mp3" into pAudioFile
   
   # Construct postData
   put textEncode (someText, "UTF-8") into utf8Text
   put utf8Text into postData ["input"]
   put pWhisperVoice into postData ["voice"]
   put "https://api.openai.com/v1/audio/speech" into restURL
   
   # Create and Fetch audio
   put _FetchPostResult (postData, restUrl) into someAudio
   -- put textEncode (someAudio, "UTF-8") into someAudio
   
   # Create audio file
   put pAudioFile into audioFolder
   set the itemdelimiter to slash
   put empty into audioFolder
   folder_CreateNested audioFolder
   --
   put someAudio into url ("binfile:" & pAudioFile)
   --
   return pAudioFile
end openAI_TextToSpeech

function openAI_Chat pUserText, pSystemPrompt, pModel, pTemp, pMaxTokens, pTopP
   put openAI_FetchChatData (pUserText, pSystemPrompt, pModel, pTemp, pMaxTokens, pTopP) into postData
   if postData is not an array then
      -- display_Data postData
      return empty
   else
      put postData ["choices"][1]["message"]["content"] into chatReply
      return chatReply
   end if
end openAI_Chat


--> Whisper
-
function openAI_ListModels
   /*
   babbage-002
   dall-e-2
   dall-e-3
   davinci-002
   gpt-3.5-turbo
   gpt-3.5-turbo-0301
   gpt-3.5-turbo-0613
   gpt-3.5-turbo-1106
   gpt-3.5-turbo-16k
   gpt-3.5-turbo-16k-0613
   gpt-3.5-turbo-instruct
   gpt-3.5-turbo-instruct-0914
   gpt-4
   gpt-4-0125-preview
   gpt-4-0613
   gpt-4-1106-preview
   gpt-4-turbo-preview
   gpt-4-vision-preview
   text-embedding-3-large
   text-embedding-3-small
   text-embedding-ada-002
   tts-1
   tts-1-1106
   tts-1-hd
   tts-1-hd-1106
   whisper-1
   */
   
   put openAI_GetApiKey() into apiKey
   put openAI_RestURL ("models") into restUrl
   put jsonrpc_GetArray (restURL, apiKey) into rData
   put rData ["data"] into indexArray
   --
   -- display_Data rData
   repeat with itemNum = 1 to item 2 of the extents of indexArray
      put indexArray [itemNum]["id"] into modelName
      put modelName & CR after modelNames
   end repeat
   delete char -1 of modelNames
   sort modelNames
   return modelNames
end openAI_ListModels

function openAI_FetchChatData pUserText, pSystemPrompt, pModel, pTemp, pMaxTokens, pTopP
   if pTemp is empty then put 0.7 into pTemp
   if pUserText is empty then put "Hello!" into pUserText
   if pSystemPrompt is empty then put "You are a helpful assistant." into pSystemPrompt
   
   put _ConstructMessagePostData (pUserText, pSystemPrompt, pModel, pTemp, pMaxTokens, pTopP) into postData
   put _FetchPostData (postData, "chat/completions") into rData
   switch
      case rData ["error"] is an array
         put rData ["error"]["message"] into sError
         return "Error," && sError
      case rData is not an array
         if postResult is empty then
            return "Error, postJSON is empty." & CR & postJSON
         else
            return "Error, postResult is empty." & CR & postResult
         end if
      default
         return rData
   end switch
end openAI_FetchChatData

function openAI_FetchChatJson pUserText, pSystemPrompt, pModel, pTemp, pMaxTokens, pTopP
   if pUserText is empty then put "Hello!" into pUserText
   if pSystemPrompt is empty then put "You are a helpful assistant designed to output JSON" into pSystemPrompt
   
   if pSystemPrompt contains "JSON" is false then return "Error, system prompt must contina the word JSON."
   put "json_object" into postData ["response_format"]["type"]
   
   if pModel is empty then
      put "gpt-4-turbo-preview" into pModel
      -- put "gpt-4" into pModel
   end if
   
   if pTemp is empty then put 0.7 into pTemp
   put pTemp into postData ["temperature"]
   
   /*
   if pMaxTokens is empty then put 64 into pMaxTokens
   put pMaxTokens into postData ["max_tokens"]
   if pTopP is empty then put 1 into pTopP
   put pTopP into postData ["top_p"]   --
   */
   
   put openAI_RestURL ("chat/completions") into restUrl
   --
   put pModel into postData ["model"]
   --
   put "system" into postData ["messages"][1]["role"]
   put pSystemPrompt into postData ["messages"][1]["content"]
   --
   put "user" into postData ["messages"][1]["role"]
   put pUserText into postData ["messages"][1]["content"]
   --
   put _FetchResultData (postData, restUrl) into postData
   return postData
end openAI_FetchChatJson

function openAI_RestURL pRestBit
   put "https://api.openai.com/v1/" into restURL
   put pRestBit after restURL
   return restURL
end openAI_RestURL


--> Private
-
private function _ConstructMessagePostData
   if pModel is empty then
      -- put "gpt-4" into pModel
      put "gpt-4-turbo" into pModel
   end if
   
   if pTemp is not empty then
      put pTemp into postData ["temperature"]
   end if
   if pMaxTokens is not empty then
      put pMaxTokens into postData ["max_tokens"]
   end if
   if pTopP is not empty then
      --  put 1 into pTopP
      put pTopP into postData ["top_p"]
   end if
   
   put pModel into postData ["model"]
   
   # System Prompt (option)
   put 1 into indexNum
   if pSystemPrompt is not empty then
      put "system" into postData ["messages"][indexNum]["role"]
      put pSystemPrompt into postData ["messages"][indexNum]["content"]
      add 1 to indexNum
   end if
   
   # UserText
   if pUserText is not empty then
      put "user" into postData ["messages"][indexNum]["role"]
      put pUserText into postData ["messages"][indexNum]["content"]
   end if
   --
   return postData
end _ConstructMessagePostData

private function _FetchPostData postData, restPath
   put openAI_RestURL (restPath) into restUrl
   
   put openAI_GetApiKey() into apiKey
   put json_FromArray (postData) into postJSON
   
   # Here we could try tsNet to make it more reliable
   set the cursor to watch
   set socketTimeoutInterval to 120000  --120 seconds
   put jsonrpc_POST (postJSON, restUrl, apiKey) into postResult
   set socketTimeoutInterval to 10000  -- default
   
   # Process result
   put json_ToArray (postResult) into rData
   return rData
end _FetchPostData

private function _FetchResultData postData, restUrl
   put _FetchPostResult (postData, restUrl) into postResult
   put json_ToArray(postResult) into postData
   if postData is false then
      return postResult
   else
      return postData
   end if
end _FetchResultData

private function _FetchPostResult postData, restUrl
   put openAI_GetApiKey() into apiKey
   -- put jsonrpc_PostArray (postData, restUrl, apiKey) into responseData
   put json_FromArray (postData) into postJSON
   -- put postJSON
   put jsonrpc_POST (postJSON, restUrl, apiKey) into postResult
   return postResult
end _FetchPostResult
