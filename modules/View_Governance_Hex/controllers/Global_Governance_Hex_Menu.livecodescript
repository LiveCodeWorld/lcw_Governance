script "Global | Governance | Hex | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Hex | Menu
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
   put display_MenuTarget (tObject) into hexView
   -- put the display_View of tObject into hexView
   return hexView
end menu_Target

getprop menu_CheckTarget [hexView]
   return exists (hexView)
end menu_CheckTarget

getprop checked_NodesVisible [hexView]
   return the node_Visible of hexView 
end checked_NodesVisible

getprop checked_DefaultStackRect [hexView]
   put 400 into wikiPageWidth
   --
   put the stack_Name of hexView into stackName
   put the width of stack stackName into sWidth
   put the width of stack stackName into sHeight
   return (sWidth = wikiPageWidth) AND (sHeight = wikiPageWidth)
end checked_DefaultStackRect


--> Global | Governance | Hex | Menu
-
on menu_AnimateSpinFast hexView
   dispatch "animate_SpinFast" to hexView
end menu_AnimateSpinFast

on menu_AnimateToOne hexView
   dispatch "animate_ToOne" to hexView
end menu_AnimateToOne

private on _
end _

on menu_AnimateToCentre hexView
   dispatch "animate_ToCentre" to hexView
end menu_AnimateToCentre

on menu_AnimateToEdge hexView
   dispatch "animate_ToEdge" to hexView
end menu_AnimateToEdge

private on __
end __

on menu_NodesVisible hexView
   set the node_Visible of hexView to not the node_Visible of hexView 
end menu_NodesVisible

on menu_DefaultStackRect hexView
   put the stack_Name of hexView into stackName
   --
   put 400 into wikiPageWidth
   put the loc of stack stackName into sLoc
   put rect_LocWidthHeight (sLoc, wikiPageWidth, wikiPageWidth) into newRect
   --
   set the rect of stack stackName to newRect
end menu_DefaultStackRect

private on ___
end ___

on menu_AddStandaloneBehaviors hexView
   put the stack_Name of hexView into stackName
   --
   lcw_Answer "Add behavior paths to standalone settings of stack '[[var]]'?", hexView, stackName
   
   put the module_BehaviorPaths of hexView into bPaths
   set the standalone_AddPath of hexView to bPaths
   put the result into settingsArray
   --
   put the stack_Name of hexView into stackName
   display_Tool settingsArray, stackName, "Settings Array"
end menu_AddStandaloneBehaviors

on menu_DisplayStandaloneSettings hexView
   put the standalone_SettingsArray of hexView into settingsArray
   --
   put the stack_Name of hexView into stackName
   display_Tool settingsArray, stackName, "Standalone Settings"
end menu_DisplayStandaloneSettings

on menu_CraftHtml hexView
   put wasm_FetchSnippet ("html_snip.txt") into htmlSnip
   --
   put wasm_FetchSnippet ("body_snip.txt") into bodySnip
   put wasm_FetchSnippet ("head_snip.txt") into headSnip
   put wasm_FetchSnippet ("css_snip.css") into wasmCss
   put wasm_FetchSnippet ("body_script.txt") into bodyScript
   --
   put "Wasm Title" into wasmTitle
   put "standalone-10.0.2-rc-4" into standaloneStem
   put standaloneStem & ".js" into standaloneShortJs
   --
   -- put merge ()
end menu_CraftHtml

function wasm_GetSnippet shortFile
   put merge ("https://david.livecode.wiki/assets/wasm/live_wasm_snips/[[shortFile]]") into someURL
   put url someURL into htmlSnip
   return htmlSnip
end wasm_GetSnippet

function wasm_FetchSnippet shortFile
   put merge ("https://david.livecode.wiki/assets/wasm/live_wasm_snips/[[shortFile]]") into someURL
   put url someURL into htmlSnip
   return htmlSnip
end wasm_FetchSnippet

on submenu_Dev
   return menu_DevTitle ("Global | Governance | Hex | Menu")
end submenu_Dev
