PriorityTarget_Localization = {}

local L = PriorityTarget_Localization

L["OptionsFrame_Width"]                                    = 620
L["OptionsFrame_Height"]                                   = 455

L["Menu_General"]                                          = "General"
L["Menu_Lists"]                                            = "Priority Lists"
L["Menu_Loaders"]                                          = "Loaders"

L["Menu_General_Value"]                                    = "General"
L["Menu_Lists_Value"]                                      = "Lists"
L["Menu_Loaders_Value"]                                    = "Loaders"

L["Minimap_Click"]                                         = "|cffFF6600Click|r to toggle prioTarget button"
L["Minimap_RightClick"]                                    = "|cffFF6600Right Click|r to toggle options"

L["CommandHelp_Button"]                                    = "          /ptarget but[ton] (show/hide the button)"
L["CommandHelp_Options"]                                   = "          /ptarget opt[ions] (show options)"

L["HelpText"] =
[=[    Mouseover the prioTarget button to show the currently loaded target list. Clicking the prioTarget button or pressing its keybind will target the highest valid target on the List.
    
The priority target logic can also be used in a macro like:
    /click prioTarget
    /cast <SpellName>
SpellName an actual ability name without the <>; macro conditionals are also accepted eg. /click [mod:ctrl] prioTarget
    
Click the Priority Lists header to manage Lists on the right panel. Expand the tree and click a child to manage the targets in each List.]=]

L["AccountSettings"]                                       = "Account Settings"

L["ExactTargetMatchingCheckBox_Width"]                     = 120

L["ExactTargetMatchingCheckBox_Tooltip"]                   = "Target Matching"
L["ExactTargetMatchingCheckBox_Tooltip_Checked"]           = "Checked: Exact (|cff00ff00recommended|r)"
L["ExactTargetMatchingCheckBox_Tooltip_Unchecked"]         = "Unchecked: Loose"
L["ExactTargetMatchingCheckBox_Label"]                     = "Exact Targeting"

L["SafeTargetingCheckBox_Width"]                           = 120

L["SafeTargetingCheckBox_Tooltip"]                         = "Safe Targeting"
L["SafeTargetingCheckBox_Tooltip_Checked"]                 = "Checked: Restore current target in case of a failure. |cffff0000Enable only if you don't use focus (/focus).|r"
L["SafeTargetingCheckBox_Tooltip_Unchecked"]               = "Unchecked: If target selection fails, current target will remain empty."
L["SafeTargetingCheckBox_Label"]                           = "Safe Targeting"

L["AutoAcceptCheckBox_Width"]                              = 120

L["AutoAcceptCheckBox_Tooltip"]                            = "Lists sent from Group Leader."
L["AutoAcceptCheckBox_Tooltip_Checked"]                    = "Checked: Auto accept"
L["AutoAcceptCheckBox_Tooltip_Unchecked"]                  = "Unchecked: Prompt"
L["AutoAcceptCheckBox_Label"]                              = "Auto Accept"

L["PresetsButton_Width"]                                   = 100

L["Presets"]                                               = "Presets"
L["Presets_Tooltip"]                                       = "Reload Presets"
L["Presets_Tooltip_Detail"]                                = "Restore preset Lists"

L["Keybind"]                                               = "Keybind"

L["CharacterSettings"]                                     = "Character Settings"

L["ButtonCheckBox_Width"]                                  = 100

L["ButtonCheckBox_Tooltip"]                                = "prioTarget button."
L["ButtonCheckBox_Tooltip_Checked"]                        = "Checked: Shown"
L["ButtonCheckBox_Tooltip_Unchecked"]                      = "Unchecked: Hidden"
L["ButtonCheckBox_Label"]                                  = "Button"

L["MinimapIconCheckBox_Width"]                             = 140

L["MinimapIconCheckBox_Tooltip"]                           = "Minimap Icon"
L["MinimapIconCheckBox_Tooltip_Checked"]                   = "Checked: Shown"
L["MinimapIconCheckBox_Tooltip_Unchecked"]                 = "Unchecked: Hidden"
L["MinimapIconCheckBox_Label"]                             = "Minimap Icon"

L["AutoLoadCheckBox_Width"]                                = 100

L["AutoLoadCheckBox_Tooltip"]                              = "Auto Load"
L["AutoLoadCheckBox_Tooltip_Checked"]                      = "Checked: Automatically load priority lists you have linked to NPCs or Locations"
L["AutoLoadCheckBox_Tooltip_Unchecked"]                    = "Unchecked: Keep your current priority, manually load priority lists"
L["AutoLoadCheckBox_Label"]                                = "Auto Load"

L["AutoLoadOptions_Text"]                                  = "Auto Load options"

L["AutoLoadOptions_LinkToNPC"]                             = "Link to NPC"
L["AutoLoadOptions_LinkToLocation"]                        = "Link to Location"

L["AutoLoadOptions_UnlinkButton_Tooltip"]                  = "Unlink"
L["AutoLoadOptions_UnlinkButton_Tooltip_Detail"]           = "Clears Loaders from %s"
L["AutoLoadOptions_UnlinkButton_Label"]                    = "Unlink"

L["AutoLoadOptions_NPC_Label"]                             = "ID:%s    Link:%s%s|r\nName: %s"
L["AutoLoadOptions_NPCWowheadLink"]                        = "|cff0099CC www.wowhead.com/npc="

L["AutoLoadOptions_Location_Label"]                        = "ID:%s    Boundaries: W=%s N=%s E=%s S=%s\n%s\nName: %s"
L["AutoLoadOptions_NotSaved"]                              = "|cffff0000not saved|r"

L["AutoLoadOptions_LoadByNPC"]                             = "Load by NPC"

L["AutoLoadOptions_InvalidInput"]                          = "%s: Invalid input %q"

L["AutoLoadOptions_LoaderName_Tooltip"]                    = "Loader Name"
L["AutoLoadOptions_LoaderName_Tooltip_Detail"]             = "Type in a name and press Enter to save the Loader."
L["AutoLoadOptions_SaveLoader"]                            = "Save Loader"

L["AutoLoadOptions_NPCID_Label"]                           = "NPC id"
L["AutoLoadOptions_NPCID_Tooltip"]                         = "NPC id"
L["AutoLoadOptions_NPCID_Tooltip_Detail1"]                 = "Type in an NPC id or use the button to add your target."
L["AutoLoadOptions_NPCID_Tooltip_Detail2"]                 = "Press Enter to set the id on the Loader..."
L["AutoLoadOptions_NPCID_Tooltip_Detail3"]                 = "... then give the Loader a name on the next box."

L["AutoLoadOptions_TargetNPCID_Tooltip"]                   = "NPC id"
L["AutoLoadOptions_TargetNPCID_Tooltip_Detail"]            = "Target an NPC and press this button to fill its ID"

L["AutoLoadOptions_LoadByLocation"]                        = "Load by Location"

L["AutoLoadOptions_Location_Tooltip"]                      = "Location"
L["AutoLoadOptions_Location_Tooltip_Detail1"]              = "Pressing this button with the map closed will fill in your current location."
L["AutoLoadOptions_Location_Tooltip_Detail2"]              = "Open the world map (minimized) and navigate to the location you wish to save.(|cff00ff00recommended|r)"
L["AutoLoadOptions_Location_Tooltip_Detail3"]              = "Press this button to fill in map details."

L["AutoLoadOptions_MapOverlay_Tooltip"]                    = "|cffFF6600Click|r, Drag and Release to fill in a bounding area coordinates."

L["AutoLoadOptions_ManageLoaders"]                         = "Manage Loaders"
L["AutoLoadOptions_ManageLoaders_SavedLoaders"]            = "Saved Loaders"
L["AutoLoadOptions_ManageLoaders_DeleteButton"]            = "Delete"
L["AutoLoadOptions_ManageLoaders_ErrorDeletePreset"]       = "%s: Cannot delete presets."

L["PriorityLists_Element_Width"]                           = 200

L["PriorityLists_ListName_Tooltip"]                        = "Priority List Name"
L["PriorityLists_ListName_Tooltip_Detail1"]                = "Type in a list name and press Enter to create a new empty list, or ..."
L["PriorityLists_ListName_Tooltip_Detail2"]                = "|cffFF6600Right Click|r an existing one to rename."

L["PriorityLists_NewRenameList_Header"]                    = "New List / Rename List"
L["PriorityLists_ListButton_Tooltip"]                      = "Priority List"
L["PriorityLists_ListButton_Tooltip_Detail1"]              = "|cffFF6600Click|r to Load"
L["PriorityLists_ListButton_Tooltip_Detail2"]              = "|cffFF6600Right Click|r to Manage"

L["PriorityLists_ButtonMenu_Rename"]                       = "Rename"
L["PriorityLists_ButtonMenu_ManagetTargets"]               = "Manage Targets"
L["PriorityLists_ButtonMenu_Loaders"]                      = "Loaders"
L["PriorityLists_ButtonMenu_Delete"]                       = "Delete"

L["PriorityLists_MenuAction_RenamePreset_Error"]           = "%s: Cannot rename presets."
L["PriorityLists_MenuAction_DeletePreset_Error"]           = "%s: Cannot delete presets."

L["ManageTargets_NewTarget"]                               = "New Target"
L["ManageTargets_NewTarget_Tooltip"]                       = "New Target Name"
L["ManageTargets_NewTarget_Tooltip_Detail"]                = "Manually type in an enemy name or target an enemy and use the Add Target button"
L["ManageTargets_NewTarget_AddTarget"]                     = "Add Target"

L["ManageTargets_Target_Tooltip"]                          = "Target Name"
L["ManageTargets_Target_Tooltip_Detail"]                   = "|cffFF6600Click|r to manage"
L["ManageTargets_Target_Menu_RaisePriority"]               = "Raise Priority"
L["ManageTargets_Target_Menu_LowerPriority"]               = "Lower Priority"
L["ManageTargets_Target_Menu_Delete"]                      = "|cffff0000Delete|r"

L["Managetargets_TargetEnabledCheckBox_Tooltip_Detail1"]   = "Checked - target is included in priorities list"
L["Managetargets_TargetEnabledCheckBox_Tooltip_Detail2"]   = "Unchecked - target is excluded from priorities list"

L["ManageTargets_SendToGroup"]                             = "Send to Group"
L["ManageTargets_SendToGroup_Tooltip"]                     = "Send to Group"
L["ManageTargets_SendToGroup_Tooltip_Detail_Leader"]       = "|cffFF6600Click|r to send this List to your group."
L["ManageTargets_SendToGroup_Tooltip_Detail_NotLeader"]    = "|cffff0000Must be Group Leader|r"

L["ReceiveListPrompt"]                                     = "<%s> is sending you target list <%s>"

L["Error_GUIOptions_InCombat"]                             = "%s:Cannot create options GUI in combat."
L["Error_ButtonVisibility_InCombat"]                       = "%s:Cannot change the button visibility in combat."

L["ActionButton_Tooltip"]                                  = "|cffFF6600Alt Click|r and drag to move"
L["ActionButton_Binding_Text"]                             = "Target Priority Unit"

L["OptionsFrame_StatusText"]                               = "%s Options"

L["Hellfire_Assault"]                                      = "Hellfire Assault"
L["Hellfire_High_Council"]                                 = "Hellfire High Council"
L["Socretar_the_Eternal"]                                  = "Socretar the Eternal"

L["Presets_Loaded"]                                        = "Loaded presets (lists/loaders/links): %d/%d/%d."
L["List_Sent"]                                             = "List \"%s\" has been sent to your group."