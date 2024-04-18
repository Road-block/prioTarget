-- GLOBALS: BINDING_HEADER_PRIOTARGET_HEADER,SLASH_PRIOTARGET1,SLASH_PRIOTARGET2
local ADDON,private = ...
private.functions,private.data = {},{}
local Fn, D = private.functions,private.data
Fn.GUI, Fn.UTILS, Fn.API = {},{},{}

local L = PriorityTarget_Localization
D._unload = CreateAtlasMarkup("common-icon-rotateleft",18,18,0,-2)
D.Presets,D.PresetLoaders,D.PresetLinks,D.Tooltip = {},{},{},{}

D.Tree = {
  {value = L["Menu_General_Value"], text = L["Menu_General"]}, -- 1
  {
    value = L["Menu_Lists_Value"],
    text = L["Menu_Lists"],
    children = {},
  }, -- 2
  {value = L["Menu_Loaders_Value"], text = L["Menu_Loaders"]}, -- 3
}
local gui_lists = D.Tree[2].children
local DBName,DBPCName,DB,DBPC = format("%sDB",ADDON), format("%sDBPC",ADDON)
local DBVersion = 3 -- change this if we need to upgrade/reset variables
local label = format("|TInterface\\AddOns\\%s\\Reticule:0:|t|cff996666%s|r",ADDON,ADDON)
local pName = UnitName("player")
local theButton,timer
local AG = LibStub("AceGUI-3.0")
local ACM = LibStub("AceComm-3.0")
local ASZ = LibStub("AceSerializer-3.0")
local LDI = LibStub("LibDBIcon-1.0", true)
local LDB = LibStub("LibDataBroker-1.1", true)
local defaults = {
  Lists = {},
  Loaders = {},
  Exact = true,
  SafeTargeting = false,
  AutoAccept = false,
  DBVersion = DBVersion
}
local defaultsPC = {
  Linked = {},
  Minimap = true,
  Visible = true,
  AutoLoad = false
}
local events = CreateFrame("Frame")
events.ON_EVENT = function(self,event,...)
  return self[event] and self[event](...)
end
events:SetScript("OnEvent",events.ON_EVENT)
events:RegisterEvent("ADDON_LOADED")
local combat_queue, delay_queue = {},{}
-- delayed execution
events.OnFinished = function(self,requested)
  while next(delay_queue) do
    if events.nocombat then
      events.CombatCheck(tremove(delay_queue, 1))
    else
      tremove(delay_queue, 1)()
    end
  end
end
events.ag = events:CreateAnimationGroup()
events.ag:SetLooping("NONE")
events.ag.timer = events.ag:CreateAnimation("Animation")
events.timer = events.ag.timer
events.timer:SetScript("OnFinished",events.OnFinished)
events.RunAfter = function(seconds,nocombat)
  events.nocombat = nocombat
  if not events.ag:IsPlaying() then
    events.timer:SetDuration(seconds)
    events.ag:Play()
  end
end
-- combat queue: FIFO
events.PLAYER_REGEN_ENABLED = function()
  while next(combat_queue) do
    tremove(combat_queue, 1)()
  end
  events:UnregisterEvent("PLAYER_REGEN_ENABLED")
end
events.CombatCheck = function(func)
  if Fn.InCombat() then
    if not tContains(combat_queue,func) then
      tinsert(combat_queue,func)
      events:RegisterEvent("PLAYER_REGEN_ENABLED")
    end
  else
    func()
  end
end
events.ADDON_LOADED = function(addonName)
  if addonName == ADDON then
    if IsLoggedIn() then
      events.PLAYER_LOGIN()
    else
      events:RegisterEvent("PLAYER_LOGIN")
    end
    events:UnregisterEvent("ADDON_LOADED")
  end
  if addonName == "ElvUI" then
    Fn.SkinButton()
  end
end
events.PLAYER_LOGIN = function()
  _G[DBName] = _G[DBName] or CopyTable(defaults)
  _G[DBPCName] = _G[DBPCName] or CopyTable(defaultsPC)
  DB,DBPC = _G[DBName], _G[DBPCName]
  DB.Lists = DB.Lists or {}
  DB.Loaders = DB.Loaders or {}
  Fn.MigrateDB()
  Fn.CopyPresets()
  SlashCmdList["PRIOTARGET"] = Fn.Slasher
  SLASH_PRIOTARGET1 = "/ptarget"
  SLASH_PRIOTARGET2 = "/priotarget"
  events.CombatCheck(Fn.theButton)
  ACM.RegisterComm(Fn,ADDON,"OnListReceived")
  if LDB then
    D.Broker = LDB:NewDataObject(ADDON, {
      type = "launcher",
      label = ADDON,
      icon = format("Interface\\AddOns\\%s\\Reticule",ADDON),
      OnClick = function(self, mbutton)
        if mbutton == "RightButton" then
          Fn.OptionsGUI()
        elseif (mbutton == "MiddleButton") or IsControlKeyDown() then
          Fn.unloadList()
        else
          Fn.ToggleButton()
        end
      end,
      OnEnter = function(self)
        GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT")
        GameTooltip:SetText(label,1,1,1)
        GameTooltip:AddLine(L["Minimap_Click"])
        GameTooltip:AddLine(L["Minimap_RightClick"])
        GameTooltip:AddLine(L["Minimap_MiddleClick"])
        GameTooltip:Show()
      end,
      OnLeave = function(self)
        if GameTooltip:IsOwned(self) then GameTooltip_Hide() end
      end,
    })
  end
  if LDI then
    LDI:Register(ADDON, D.Broker, DBPC)
    Fn.GUI.MinimapIcon()
  end
end
events.UPDATE_BINDINGS = function()
  if theButton then
    local key1, key2 = GetBindingKey("CLICK prioTarget:LeftButton")
    local keytext = ""
    if key1 then
      keytext = GetBindingText(key1,nil,1)
    elseif key2 then
      keytext = GetBindingText(key2,nil,1)
    end
    theButton.hotkey:SetText(keytext)
  end
end
events.ZONE_CHANGED_NEW_AREA = function()
  Fn.CheckForLoad("loc")
end
events.ZONE_CHANGED = events.ZONE_CHANGED_NEW_AREA
events.UNIT_TARGET = function()
  Fn.CheckForLoad("npc")
end
events.PLAYER_TARGET_CHANGED = events.UNIT_TARGET
events.UPDATE_MOUSEOVER_UNIT = events.UNIT_TARGET
local numTemp = {}
Fn.UTILS.Numerize = function(empty,...)
  wipe(numTemp)
  for i=1,select("#",...) do
    local arg_raw = (select(i,...))
    local arg_num
    if arg_raw == "" then arg_raw = empty end
    arg_num = tonumber(arg_raw)
    if arg_num then
      tinsert(numTemp,arg_num)
    else
      tinsert(numTemp,arg_raw)
    end
  end
  return unpack(numTemp)
end
local sortTbl,sortIter = {}
Fn.UTILS.sortedpairs = function(t)
  wipe(sortTbl)
  for k in pairs(t) do
    tinsert(sortTbl,k)
  end
  sort(sortTbl)
  local i = 0
  sortIter = function()
    i = i+1
    local key = sortTbl[i]
    if key then return key,t[key] end
  end
  return sortIter
end
Fn.UTILS.TargetIndexByName = function(list,targetName)
  for idx, target in ipairs(list) do
    if target.Name == targetName then return idx end
  end
end
Fn.UTILS.validateInput = function(text)
  return true
--  does not work with utf-8
--    local chError = strmatch(text,"[^%w_%-:\' %(%)]")
--    if chError then
--        return false,chError
--    else
--        return true
--    end
end
Fn.UTILS.targetListContains = function(list, targetName)
  for _, name in ipairs(list) do
    if name == targetName then
      return true
    end
  end
end
Fn.SVtoGUIList = function()
  wipe(gui_lists)
  local sortedpairs = Fn.UTILS.sortedpairs
  for key,list in sortedpairs(DB.Lists) do
  -- for key,list in pairs(DB.Lists) do
    tinsert(gui_lists,{value=key,text=key})
  end
end
Fn.unloadList = function()
  DB.Selected = D._unload
  events.CombatCheck(Fn.SetMacro)
  if D.OptionsFrame and D.OptionsFrame.Tree then
    D.OptionsFrame.Tree:SelectByValue(L["Menu_Lists_Value"])
  end
end
Fn.CheckForLoad = function(loaderType)
  if not DBPC.AutoLoad then return end
  if loaderType == "npc" then
    local unitID = "mouseover"
    if not UnitExists(unitID) then unitID = "target" end
    if not UnitExists(unitID) then return end
    local npcid = Fn.GetNPCID(unitID)
    local loader = npcid and format("%s:%d",loaderType,npcid)
    if loader and DBPC.Linked[loader] then
      local listname = DBPC.Linked[loader]
      if DB.Selected ~= listname then
        DB.Selected = listname
        print(format("%s: %s > |cff00ff00%s|r",label,DB.Loaders[loader],listname))
        events.CombatCheck(Fn.SetMacro)
        if D.OptionsFrame and D.OptionsFrame.Tree then
          D.OptionsFrame.Tree:SelectByValue(L["Menu_Lists_Value"])
        end
      end
    end
  elseif loaderType == "loc" then
    if WorldMapFrame:IsVisible() then return end
    local mapID,mapname = Fn.GetMapData()
    local posData = mapID and C_Map.GetPlayerMapPosition(mapID,"player") or nil
    local pX, pY
    if posData then
      pX,pY = posData:GetXY()
    else
      px,pY = 0, 0
    end
    if not pX then pX,pY = 0,0 end
    pX, pY = pX*100, pY*100
    for loader,listname in pairs(DBPC.Linked) do
      local l_mapID,west,east,north,south = Fn.UTILS.Numerize("0",strmatch(loader,"loc:(%d+):?(%d*):?(%d*):?(%d*):?(%d*)"))
      if l_mapID then
        if mapID == l_mapID then
          local out_bounds =
            (west~=0 and pX < west) or
            (east~=0 and pX > east) or
            (north~=0 and pY < north) or
            (south~=0 and pY > south)
          if not out_bounds then
            if DB.Selected ~= listname then
              DB.Selected = listname
              print(format("%s: %s > |cff00ff00%s|r",label,DB.Loaders[loader],listname))
              events.CombatCheck(Fn.SetMacro)
              if D.OptionsFrame and D.OptionsFrame.Tree then
                D.OptionsFrame.Tree:SelectByValue(L["Menu_Lists_Value"])
              end
            end
            return
          end
        end
      end
    end
  end
end
Fn.GetNPCID = function(unitid)
  local npcGUID = not UnitIsPlayer(unitid) and UnitGUID(unitid)

  if npcGUID then
    local _, _, _, _, _, npcID = strsplit("-",npcGUID)
    return tonumber(npcID)
  end

  return false
end
Fn.GetMapData = function()
  local mapID,mapname
  if WorldMapFrame:IsVisible() then
    mapID = WorldMapFrame:GetMapID()
    if mapID and C_Map.MapHasArt(mapID) then
        local mapInfo = mapID and C_Map.GetMapInfo(mapID)
        mapname = mapInfo and mapInfo.name
    end
  else
    mapID = C_Map.GetBestMapForUnit("player")
    local mapInfo = mapID and C_Map.GetMapInfo(mapID)
    mapname = mapInfo and mapInfo.name
  end
  return mapID,mapname
end
Fn.UnLink = function(listname)
  if not DBPC.Linked then return end
  if not next(DBPC.Linked) then return end
  for loader,list in pairs(DBPC.Linked) do
    if list == listname then
      DBPC.Linked[loader] = nil
    end
  end
end
Fn.MoveLink = function(sourselist,destlist)
  for loaderkey,list in pairs(DBPC.Linked) do
    if list == sourselist then
      DBPC.Linked[sourselist] = nil
      DBPC.Linked[destlist] = loaderkey
    end
  end
end
Fn.PrintMessage = function(message)
  print(format("%s: %s", label, message))
end
Fn.CopyPresets = function(replace)
  listsCopied, loadersCopied, linksCopied = Fn.CopyListPresets(replace), Fn.CopyLoaderPresets(replace), Fn.CopyLinkPresets(replace)
  if listsCopied > 0 or loadersCopied > 0 or linksCopied > 0 then
     Fn.PrintMessage(format(L["Presets_Loaded"],listsCopied,loadersCopied,linksCopied))
  end
end
Fn.CopyListPresets = function(replace)
  local copied = 0
  for key,list in pairs(D.Presets) do
    if not DB.Lists[key] or replace then
      presetList = {}
      DB.Lists[key] = presetList

      for idx, targetName in ipairs(list) do
        presetList[#presetList + 1] = { Name = targetName, Enabled = true }
      end
      copied = copied + 1
    end
  end
  return copied
end
Fn.CopyLoaderPresets = function(replace)
  local copied = 0
  for key,name in pairs(D.PresetLoaders) do
    if not DB.Loaders[key] or replace then
      DB.Loaders[key] = name
      copied = copied + 1
    end
  end
  for key,name in pairs(D.PresetLoaders) do
    if not DB.Loaders[key] or replace then
      DB.Loaders[key] = name
      copied = copied + 1
    end
  end
  return copied
end
Fn.CopyLinkPresets = function(replace)
  local isDirty
  local copied = 0
  for loader,list in pairs(D.PresetLinks) do
    if not DBPC.Linked[loader] or replace then
      DBPC.Linked[loader] = list
      copied = copied + 1
    end
  end
  if isDirty and D.OptionsFrame and D.OptionsFrame.Links:IsShown() then
    D.OptionsFrame.Links:Hide()
  end
  return copied
end
Fn.MigrateDB = function() -- incremental saved variables migration
  if not DB.DBVersion or DB.DBVersion < 2 then
    local migratedLists = {}

    for listName, list in pairs(DB.Lists) do
      local newList = {}

      for _, targetName in pairs(list) do
        newList[#newList + 1] = { Name = targetName, Enabled = true }
      end
      migratedLists[listName] = newList
    end

    DB.Lists = migratedLists
  end

  if DB.DBVersion == 2 then
    DB.Loaders["npc:91809"] = nil -- incorrect HFC Gorefiend id
    DBPC.Linked["npc:91809"] = nil
    DB.Loaders["npc:91809"] = nil -- incorrect HFC Tyran Velhari id
    DBPC.Linked["npc:91809"] = nil
  end

  DB.DBVersion = DBVersion
end
Fn.SetAutoLoad = function(enable)
  if enable then
    events:RegisterEvent("UNIT_TARGET")
    events:RegisterEvent("PLAYER_TARGET_CHANGED")
    events:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    events:RegisterEvent("ZONE_CHANGED")
    Fn.CheckForLoad("loc")
  else
    events:UnregisterEvent("UNIT_TARGET")
    events:UnregisterEvent("PLAYER_TARGET_CHANGED")
    events:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
    events:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
    events:UnregisterEvent("ZONE_CHANGED")
  end
end
Fn.SendListComm = function(listname,list)
  local dist,target
  if UnitIsGroupLeader("player") then
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
      dist = "INSTANCE_CHAT"
    elseif IsInRaid() then
      dist = "RAID"
    elseif IsInGroup() then
      dist = "PARTY"
    end
  end
  if theButton.DEBUG and not dist then dist,target = "WHISPER",pName end
  if not dist then return end
  local strData = ASZ:Serialize(listname,list)
  ACM.SendCommMessage(Fn,ADDON,strData,dist,target)
  Fn.PrintMessage(format(L["List_Sent"],listname))
end
Fn.OnListReceived = function(_, prefix, msg, dist, sender)
  if prefix ~= ADDON then return end
  if sender == pName and not theButton.DEBUG then return end
  if not (UnitIsGroupLeader(sender) or theButton.DEBUG) then return end
  local ok,listname,list = ASZ:Deserialize(msg)
  if ok then
    if not not DB.AutoAccept then
      DB.Lists[listname] = list
      DB.Selected = listname
      Fn.SVtoGUIList()
      D.OptionsFrame.Tree:RefreshTree()
      events.CombatCheck(Fn.SetMacro)
    else
      Fn.GUI.ShowPopup(sender,listname,list)
    end
  end
end
Fn.Slasher = function(cmd)
  cmd = cmd or ""
  local cmdl = strlower(cmd)
  if cmdl == "button" or cmdl == "but" then
    -- show/hide button (ooc only)
    Fn.ToggleButton()
  elseif cmdl == "clear" or cmdl == "cl" then
    Fn.unloadList()
  elseif cmdl == "options" or cmdl == "opt" then
    -- create (ooc to avoid 'script ran too long') or open options
    Fn.OptionsGUI()
  else
    -- help
    print(label)
    print(L["CommandHelp_Button"])
    print(L["CommandHelp_Clear"])
    print(L["CommandHelp_Options"])
  end
end
Fn.GUI.MinimapIcon = function()
  if LDI then
    if DBPC.Minimap then
      LDI:Show(ADDON)
    else
      LDI:Hide(ADDON)
    end
  end
end
Fn.GUI.General = function(widget)
  widget:ReleaseChildren()

  if D.OptionsFrame and D.OptionsFrame.Links and D.OptionsFrame.Links:IsVisible() then
    D.OptionsFrame.Links:Hide()
  end

  local head1 = AG:Create("Heading")
  head1:SetText("Help")
  head1:SetFullWidth(true)

  local help = AG:Create("Label")
  help:SetText(L["HelpText"])
  help:SetFullWidth(true)

  local head2 = AG:Create("Heading")
  head2:SetText(L["AccountSettings"])
  head2:SetFullWidth(true)

  local exact = AG:Create("CheckBox")
  exact.OnValueChanged = function(widget,event,value)
    DB.Exact = not not value
    Fn.SetMacro()
  end
  exact.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["ExactTargetMatchingCheckBox_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["ExactTargetMatchingCheckBox_Tooltip_Checked"])
    GameTooltip:AddLine(L["ExactTargetMatchingCheckBox_Tooltip_Unchecked"])
    GameTooltip:Show()
  end
  exact.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  exact:SetLabel(L["ExactTargetMatchingCheckBox_Label"])
  exact:SetWidth(L["ExactTargetMatchingCheckBox_Width"])
  exact:SetValue(not not DB.Exact) -- cast to boolean
  exact:SetCallback("OnValueChanged",exact.OnValueChanged)
  exact:SetCallback("OnEnter",exact.OnEnter)
  exact:SetCallback("OnLeave",exact.OnLeave)

  local safeTargeting = AG:Create("CheckBox")
  safeTargeting.OnValueChanged = function(widget,event,value)
    DB.SafeTargeting = not not value
    Fn.SetMacro()
  end
  safeTargeting.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["SafeTargetingCheckBox_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["SafeTargetingCheckBox_Tooltip_Checked"])
    GameTooltip:AddLine(L["SafeTargetingCheckBox_Tooltip_Unchecked"])
    GameTooltip:Show()
  end
  safeTargeting.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  safeTargeting:SetLabel(L["SafeTargetingCheckBox_Label"])
  safeTargeting:SetWidth(L["SafeTargetingCheckBox_Width"])
  safeTargeting:SetValue(not not DB.SafeTargeting)
  safeTargeting:SetCallback("OnValueChanged",safeTargeting.OnValueChanged)
  safeTargeting:SetCallback("OnEnter",safeTargeting.OnEnter)
  safeTargeting:SetCallback("OnLeave",safeTargeting.OnLeave)

  local auto = AG:Create("CheckBox")
  auto.OnValueChanged = function(widget,event,value)
    DB.AutoAccept = not not value
  end
  auto.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["AutoAcceptCheckBox_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["AutoAcceptCheckBox_Tooltip_Checked"])
    GameTooltip:AddLine(L["AutoAcceptCheckBox_Tooltip_Unchecked"])
    GameTooltip:Show()
  end
  auto.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  auto:SetLabel(L["AutoAcceptCheckBox_Label"])
  auto:SetWidth(L["AutoAcceptCheckBox_Width"])
  auto:SetValue(not not DB.AutoAccept)
  auto:SetCallback("OnValueChanged",auto.OnValueChanged)
  auto:SetCallback("OnEnter",auto.OnEnter)
  auto:SetCallback("OnLeave",auto.OnLeave)

  local reloadpresets = AG:Create("Button")
  reloadpresets:SetWidth(L["PresetsButton_Width"])
  reloadpresets.OnClick = function(_,event,mbutton)
    Fn.CopyPresets(true)
    if DB.Selected and D.Presets[DB.Selected] then events.CombatCheck(Fn.SetMacro) end
  end
  reloadpresets.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["Presets_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["Presets_Tooltip_Detail"])
    GameTooltip:Show()
  end
  reloadpresets.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  reloadpresets:SetText(L["Presets"])
  reloadpresets:SetCallback("OnClick",reloadpresets.OnClick)
  reloadpresets:SetCallback("OnEnter",reloadpresets.OnEnter)
  reloadpresets:SetCallback("OnLeave",reloadpresets.OnLeave)

  local head3 = AG:Create("Heading")
  head3:SetText(L["Keybind"])
  head3:SetFullWidth(true)

  local keybind = AG:Create("Keybinding")
  keybind.OnKeyChanged = function(widget,event,key)
    local bindingset = GetCurrentBindingSet()
    local isDirty
    local key1,key2 = GetBindingKey("CLICK prioTarget:LeftButton")
    if key and key ~= "" then
      if key2 then
        if key2 == key then
          SetBinding(key1)
          SaveBindings(bindingset)
          return
        else
          SetBinding(key2)
          isDirty = true
        end
      end
      if key1 then
        if key1 ~= key then
          SetBinding(key1)
          isDirty = true
        else
          if isDirty then SaveBindings(bindingset) end
          return
        end
      end
      SetBinding(key,"CLICK prioTarget:LeftButton")
      SaveBindings(bindingset)
    elseif key == "" then
      if key2 then SetBinding(key2);isDirty = true end
      if key1 then SetBinding(key1);isDirty = true end
      if isDirty then SaveBindings(bindingset) end
    end
  end
  local key1,key2 = GetBindingKey("CLICK prioTarget:LeftButton")
  keybind:SetKey(key1 or key2 or "")
  keybind:SetWidth(200)
  keybind:SetCallback("OnKeyChanged",keybind.OnKeyChanged)

  local head4 = AG:Create("Heading")
  head4:SetText(L["CharacterSettings"])
  head4:SetFullWidth(true)

  local visible = AG:Create("CheckBox")
  visible.OnValueChanged = function(widget,event,value)
    DBPC.Visible = not not value
    theButton:SetShown(DBPC.Visible)
  end
  visible.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["ButtonCheckBox_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["ButtonCheckBox_Tooltip_Checked"])
    GameTooltip:AddLine(L["ButtonCheckBox_Tooltip_Unchecked"])
    GameTooltip:Show()
  end
  visible.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  visible:SetLabel(L["ButtonCheckBox_Label"])
  visible:SetWidth(L["ButtonCheckBox_Width"])
  visible:SetValue(not not DBPC.Visible)
  visible:SetCallback("OnValueChanged",visible.OnValueChanged)
  visible:SetCallback("OnEnter",visible.OnEnter)
  visible:SetCallback("OnLeave",visible.OnLeave)

  local minimap = AG:Create("CheckBox")
  minimap.OnValueChanged = function(widget,event,value)
    DBPC.Minimap = not not value
    Fn.GUI.MinimapIcon()
  end
  minimap.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["MinimapIconCheckBox_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["MinimapIconCheckBox_Tooltip_Checked"])
    GameTooltip:AddLine(L["MinimapIconCheckBox_Tooltip_Unchecked"])
    GameTooltip:Show()
  end
  minimap.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  minimap:SetLabel(L["MinimapIconCheckBox_Label"])
  minimap:SetWidth(L["MinimapIconCheckBox_Width"])
  minimap:SetValue(not not DBPC.Minimap)
  minimap:SetCallback("OnValueChanged",minimap.OnValueChanged)
  minimap:SetCallback("OnEnter",minimap.OnEnter)
  minimap:SetCallback("OnLeave",minimap.OnLeave)

  local autoLoad = AG:Create("CheckBox")
  autoLoad.OnValueChanged = function(widget,event,value)
    DBPC.AutoLoad = not not value
    Fn.SetAutoLoad(DBPC.AutoLoad)
  end
  autoLoad.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["AutoLoadCheckBox_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["AutoLoadCheckBox_Tooltip_Checked"],nil,nil,nil,true)
    GameTooltip:AddLine(L["AutoLoadCheckBox_Tooltip_Unchecked"],nil,nil,nil,true)
    GameTooltip:Show()
  end
  autoLoad.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  autoLoad:SetLabel(L["AutoLoadCheckBox_Label"])
  autoLoad:SetWidth(L["AutoLoadCheckBox_Width"])
  autoLoad:SetValue(not not DBPC.AutoLoad)
  autoLoad:SetCallback("OnValueChanged",autoLoad.OnValueChanged)
  autoLoad:SetCallback("OnEnter",autoLoad.OnEnter)
  autoLoad:SetCallback("OnLeave",autoLoad.OnLeave)

  widget:AddChildren(head1,help,head2,exact,safeTargeting,auto,reloadpresets,head3,keybind,head4,visible,minimap,autoLoad)
end
local linkNPCs,linkMaps = {},{}
Fn.GUI.Links = function(listname)
--  if not theButton.DEBUG then return end -- for now
  if not D.OptionsFrame.Links then
    local linkframe = AG:Create("Frame")
    linkframe:SetTitle("")
    linkframe:SetStatusText(L["AutoLoadOptions_Text"])
    linkframe:SetLayout("Fill")
    linkframe:SetWidth(300)
    linkframe:SetHeight(260)
    linkframe:EnableResize(false)
    linkframe:ClearAllPoints()
    linkframe:SetPoint("TOPLEFT",D.OptionsFrame.frame,"TOPRIGHT",0,0)
    linkframe.OnClose = function(widget,event)
      linkframe.Group:ReleaseChildren()
    end
    linkframe:SetCallback("OnClose",linkframe.OnClose)

    local group = AG:Create("InlineGroup")
    group:SetFullWidth(true)
    group:SetFullHeight(true)
    group:SetLayout("Flow")
    linkframe.Group = group
    linkframe:AddChild(group)
    linkframe:Hide()
    D.OptionsFrame.Links = linkframe
  end

  if D.OptionsFrame.Links:IsShown() then
    D.OptionsFrame.Links:Hide()
  else
    local group = D.OptionsFrame.Links.Group
    local npclink = AG:Create("Dropdown")
    npclink:SetWidth(250)
    npclink:SetLabel(L["AutoLoadOptions_LinkToNPC"])
    npclink:SetMultiselect(false)
    npclink.RefreshList = function()
      linkNPCs = wipe(linkNPCs)
      npclink:SetUserData("LOADER",nil)
      linkNPCs["_none"] = NONE
      for loaderkey,name in pairs(DB.Loaders) do
        if strfind(loaderkey,"^npc:") then
          linkNPCs[loaderkey] = name
          if DBPC.Linked[loaderkey] and DBPC.Linked[loaderkey] == listname then
            npclink:SetUserData("LOADER",loaderkey)
          end
        end
      end
      npclink:SetList(linkNPCs)
      local linked = npclink:GetUserData("LOADER")
      if linked then npclink:SetValue(linked) else npclink:SetValue("_none") end
    end
    npclink.OnValueChanged = function(_,event,key)
      if key~="_none" and DB.Loaders[key] then
        DBPC.Linked[key] = listname
        npclink:SetUserData("LOADER",key)
      end
    end
    npclink:SetCallback("OnValueChanged",npclink.OnValueChanged)
    npclink.RefreshList()

    local spacer = AG:Create("Heading")
    spacer:SetFullWidth(true)

    local loclink = AG:Create("Dropdown")
    loclink:SetWidth(250)
    loclink:SetLabel(L["AutoLoadOptions_LinkToLocation"])
    loclink:SetMultiselect(false)
    loclink.RefreshList = function()
      linkMaps = wipe(linkMaps)
      loclink:SetUserData("LOADER",nil)
      linkMaps["_none"] = NONE
      for loaderkey,name in pairs(DB.Loaders) do
        if strfind(loaderkey,"^loc:") then
          linkMaps[loaderkey] = name
          if DBPC.Linked[loaderkey] and DBPC.Linked[loaderkey] == listname then
            loclink:SetUserData("LOADER",loaderkey)
          end
        end
      end
      loclink:SetList(linkMaps)
      local linked = loclink:GetUserData("LOADER")
      if linked then loclink:SetValue(linked) else loclink:SetValue("_none") end
    end
    loclink.OnValueChanged = function(_,event,key)
      if key~="_none" and DB.Loaders[key] then
        DBPC.Linked[key] = listname
        loclink:SetUserData("LOADER",key)
        Fn.CheckForLoad("loc")
      end
    end
    loclink:SetCallback("OnValueChanged",loclink.OnValueChanged)
    loclink.RefreshList()

    local unlink = AG:Create("Button")
    unlink:SetWidth(250)
    unlink.OnClick = function(_,event,mbutton)
      Fn.UnLink(listname)
      npclink.RefreshList()
      loclink:RefreshList()
    end
    unlink.OnEnter = function(widget)
      GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
      GameTooltip:SetText(L["AutoLoadOptions_UnlinkButton_Tooltip"],1,1,1)
      GameTooltip:AddLine(format(L["AutoLoadOptions_UnlinkButton_Tooltip_Detail"],listname))
      GameTooltip:Show()
    end
    unlink.OnLeave = function(widget)
      if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
    end
    unlink:SetText(L["AutoLoadOptions_UnlinkButton_Label"])
    unlink:SetCallback("OnClick",unlink.OnClick)
    unlink:SetCallback("OnEnter",unlink.OnEnter)
    unlink:SetCallback("OnLeave",unlink.OnLeave)

    group:AddChildren(npclink,spacer,loclink,unlink)

    D.OptionsFrame.Links:SetTitle(listname)
    D.OptionsFrame.Links:Show()
  end

end
local fmt_label_npc,s_wowheadnpc = L["AutoLoadOptions_NPC_Label"], L["AutoLoadOptions_NPCWowheadLink"]
local fmt_label_loc,s_notsaved = L["AutoLoadOptions_Location_Label"], L["AutoLoadOptions_NotSaved"]
Fn.GUI.Loaders = function(widget)
  widget:ReleaseChildren()

  widget.RefreshLoaders = function()
    sort(DB.Loaders)
    widget.loaderList:SetList(DB.Loaders)
  end
  local overlay = Fn.MapMonitor()

  local head1 = AG:Create("Heading")
  head1:SetText(L["AutoLoadOptions_LoadByNPC"])
  head1:SetFullWidth(true)

  local npclabel = AG:Create("Label")
  npclabel.SetTextFields = function()
    local id,name = npclabel:GetUserData("NPC_ID"),npclabel:GetUserData("LOADER")
    id = id or ""; name = name or s_notsaved
    npclabel:SetText(format(fmt_label_npc,id,(id~="" and s_wowheadnpc or id),id,name))
  end
  npclabel.ClearData = function()
    wipe(npclabel:GetUserDataTable())
  end
  npclabel:SetFullWidth(true)
  npclabel.SetTextFields()

  local npcloader = AG:Create("EditBox")
  npcloader.OnEnterPressed = function(_,event,text)
    text = strtrim(text)
    text = text:gsub("%[npc%]","")
    if not text or text == "" then
      npcloader:ClearFocus()
      return
    end
    local valid, invalid = Fn.UTILS.validateInput(text)
    if not valid then
      print(format(L["AutoLoadOptions_InvalidInput"],label,invalid))
      return
    end
    if valid then
      local npc_id = npclabel:GetUserData("NPC_ID")
      local loaderkey = npc_id and format("npc:%d",npc_id)
      if loaderkey then
        local loadername = format("[npc]%s",text)
        DB.Loaders[loaderkey] = loadername
        npclabel:SetUserData("LOADER",loadername)
        npclabel.SetTextFields()
        widget.RefreshLoaders()
      end
    end
    npcloader:SetText("")
    npcloader:ClearFocus()
  end
  npcloader.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["AutoLoadOptions_LoaderName_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["AutoLoadOptions_LoaderName_Tooltip_Detail"],nil,nil,nil,true)
    GameTooltip:Show()
  end
  npcloader.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  npcloader:SetMaxLetters(50)
  npcloader:SetWidth(180)
  npcloader:SetCallback("OnEnterPressed",npcloader.OnEnterPressed)
  npcloader:SetCallback("OnEnter",npcloader.OnEnter)
  npcloader:SetCallback("OnLeave",npcloader.OnLeave)
  npcloader:SetLabel(L["AutoLoadOptions_SaveLoader"])

  local npcid = AG:Create("EditBox")
  npcid:SetWidth(120)
  npcid:SetMaxLetters(10)
  npcid:SetLabel(L["AutoLoadOptions_NPCID_Label"])
  npcid.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["AutoLoadOptions_NPCID_Tooltip"],1,1,1)
    local id = npcid:GetText()
    if not id or id == "" then
      GameTooltip:AddLine(L["AutoLoadOptions_NPCID_Tooltip_Detail1"],nil,nil,nil,true)
    end
    GameTooltip:AddLine(L["AutoLoadOptions_NPCID_Tooltip_Detail2"],nil,nil,nil,true)
    GameTooltip:AddLine(L["AutoLoadOptions_NPCID_Tooltip_Detail3"],nil,nil,nil,true)
    GameTooltip:Show()
  end
  npcid.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  npcid.OnEnterPressed = function(_,event,text)
    text = strtrim(text)
    if not text or text == "" then
      npcid:ClearFocus()
      return
    end
    local id = tonumber(text)
    if not id then
      print(format(L["AutoLoadOptions_InvalidInput"],label,text))
      return
    end
    npcid:SetText("")
    npcid:ClearFocus()
    if id then
      npclabel.ClearData()
      npclabel:SetUserData("NPC_ID",id)
      npclabel.SetTextFields()
      npcloader:SetFocus()
    end
  end
  npcid:SetCallback("OnEnterPressed",npcid.OnEnterPressed)
  npcid:SetCallback("OnEnter",npcid.OnEnter)
  npcid:SetCallback("OnLeave",npcid.OnLeave)

  local addnpcid = AG:Create("Icon")
  addnpcid:SetImage("Interface\\ICONS\\INV_Misc_Head_Gnoll_01")
  addnpcid:SetImageSize(22,22)
  addnpcid:SetWidth(25)
  addnpcid:SetHeight(30)
  addnpcid.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOP")
    GameTooltip:SetText(L["AutoLoadOptions_TargetNPCID_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["AutoLoadOptions_TargetNPCID_Tooltip_Detail"],nil,nil,nil,true)
    GameTooltip:Show()
  end
  addnpcid.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  addnpcid.OnClick = function(_,event,mbutton)
    if UnitExists("target") then
      local npc_id = Fn.GetNPCID("target")
      npclabel.ClearData()
      npclabel.SetTextFields()
      if npc_id then
        npcid:SetText(npc_id)
        npcid:SetFocus()
      else
        npcid:SetText("")
      end
    end
  end
  -- addnpcid:SetCallback("OnClick",addnpcid.OnClick) -- icon widget calls AceGUI:ClearFocus() after firing the OnClick callback...
  addnpcid:SetCallback("OnEnter",addnpcid.OnEnter)
  addnpcid:SetCallback("OnLeave",addnpcid.OnLeave)
  addnpcid.frame:SetScript("PostClick",addnpcid.OnClick)

  local head2 = AG:Create("Heading")
  head2:SetText(L["AutoLoadOptions_LoadByLocation"])
  head2:SetFullWidth(true)

  local loclabel = AG:Create("Label")
  loclabel.SetTextFields = function()
    local id,name = loclabel:GetUserData("MAP_ID"),loclabel:GetUserData("LOADER")
    local mapname = loclabel:GetUserData("MAP_NAME")
    mapname = mapname or ""
    id = id or ""; name = name or s_notsaved
    local w,n,e,s = loclabel:GetUserData("BOUND_WEST"),loclabel:GetUserData("BOUND_NORTH"),loclabel:GetUserData("BOUND_EAST"),loclabel:GetUserData("BOUND_SOUTH")
    w = w or ""; n = n or ""; e = e or ""; s = s or ""
    loclabel:SetText(format(fmt_label_loc,id,w,n,e,s,mapname,name))
  end
  loclabel.ClearData = function()
    wipe(loclabel:GetUserDataTable())
  end
  loclabel:SetFullWidth(true)
  loclabel.SetTextFields()

  local locloader = AG:Create("EditBox")
  locloader.OnEnterPressed = function(_,event,text)
    text = strtrim(text)
    text = text:gsub("%[loc%]","")
    if not text or text == "" then
      locloader:ClearFocus()
      return
    end
    local valid, invalid = Fn.UTILS.validateInput(text)
    if not valid then
      print(format(L["AutoLoadOptions_InvalidInput"],label,invalid))
      return
    end
    if valid then
      local map_id,west,north,east,south =
        loclabel:GetUserData("MAP_ID"),loclabel:GetUserData("BOUND_WEST"),loclabel:GetUserData("BOUND_NORTH"),loclabel:GetUserData("BOUND_EAST"),loclabel:GetUserData("BOUND_SOUTH")
      west = west or 0;north = north or 0;east = east or 0;south = south or 0
      local loaderkey = map_id and format("loc:%d:%d:%d:%d:%d",map_id,west,east,north,south)
      if loaderkey then
        local loadername = format("[loc]%s",text)
        DB.Loaders[loaderkey] = loadername
        loclabel:SetUserData("LOADER",loadername)
        loclabel.SetTextFields()
        widget.RefreshLoaders()
      end
    end
    locloader:SetText("")
    locloader:ClearFocus()
  end
  locloader.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["AutoLoadOptions_LoaderName_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["AutoLoadOptions_LoaderName_Tooltip_Detail"],nil,nil,nil,true)
    GameTooltip:Show()
  end
  locloader.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  locloader:SetMaxLetters(50)
  locloader:SetWidth(180)
  locloader:SetCallback("OnEnterPressed",locloader.OnEnterPressed)
  locloader:SetCallback("OnEnter",locloader.OnEnter)
  locloader:SetCallback("OnLeave",locloader.OnLeave)
  locloader:SetLabel(L["AutoLoadOptions_SaveLoader"])

  local addmap = AG:Create("Icon")
  addmap:SetImage("Interface\\ICONS\\INV_Misc_Map02")
  addmap:SetImageSize(22,22)
  addmap:SetWidth(25)
  addmap:SetHeight(30)
  addmap.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOP")
    GameTooltip:SetText(L["AutoLoadOptions_Location_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["AutoLoadOptions_Location_Tooltip_Detail1"],0.6,0.6,0.6,true)
    GameTooltip:AddLine(L["AutoLoadOptions_Location_Tooltip_Detail2"],nil,nil,nil,true)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["AutoLoadOptions_Location_Tooltip_Detail3"])
    GameTooltip:Show()
  end
  addmap.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  addmap.OnClick = function(_,event,mbutton)
    loclabel.ClearData()
    local mapID,mapname = Fn.GetMapData()
    loclabel:SetUserData("MAP_ID",mapID)
    loclabel:SetUserData("MAP_NAME",mapname)
    overlay.Monitoring = loclabel
    overlay.tooltip = L["AutoLoadOptions_MapOverlay_Tooltip"]
    loclabel.SetTextFields()
    locloader:SetFocus()
  end
  -- addmap:SetCallback("OnClick",addmap.OnClick) -- Icon widget calls AceGUI:ClearFocus() AFTER firing the OnClick callback, meaning we can't :SetFocus() in it.
  addmap:SetCallback("OnEnter",addmap.OnEnter)
  addmap:SetCallback("OnLeave",addmap.OnLeave)
  addmap.frame:SetScript("PostClick",addmap.OnClick)

  local head3 = AG:Create("Heading")
  head3:SetText(L["AutoLoadOptions_ManageLoaders"])
  head3:SetFullWidth(true)

  local loaderlist = AG:Create("Dropdown")
  loaderlist:SetWidth(200)
  loaderlist:SetLabel(L["AutoLoadOptions_ManageLoaders_SavedLoaders"])
  loaderlist:SetMultiselect(false)
  loaderlist.OnValueChanged = function(_,event,key)
    if key == "_none" then
      npclabel.ClearData()
      npclabel.SetTextFields()
      loclabel.ClearData()
      loclabel.SetTextFields()
      return
    end
    local keytype,id,west,east,north,south = Fn.UTILS.Numerize("0",strmatch(key,"(%l+):(%d+):?(%d*):?(%d*):?(%d*):?(%d*)"))
    if keytype == "npc" then
      npclabel.ClearData()
      npclabel:SetUserData("NPC_ID",id)
      local loaderkey = format("npc:%d",id)
      for lkey,name in pairs(DB.Loaders) do
        if lkey == loaderkey then
          npclabel:SetUserData("LOADER",name)
          break
        end
      end
      npclabel.SetTextFields()
    elseif keytype == "loc" then
      loclabel.ClearData()
      loclabel:SetUserData("MAP_ID",id)
      loclabel:SetUserData("BOUND_WEST",west)
      loclabel:SetUserData("BOUND_NORTH",north)
      loclabel:SetUserData("BOUND_EAST",east)
      loclabel:SetUserData("BOUND_SOUTH",south)
      local loaderkey = format("loc:%d:%d:%d:%d:%d",id,west,east,north,south)
      for lkey,name in pairs(DB.Loaders) do
        if lkey == loaderkey then
          loclabel:SetUserData("LOADER",name)
          break
        end
      end
      loclabel.SetTextFields()
    end
  end
  loaderlist:SetCallback("OnValueChanged",loaderlist.OnValueChanged)
  widget.loaderList = loaderlist
  widget.RefreshLoaders()

  local removeloader = AG:Create("Button")
  removeloader:SetWidth(100)
  removeloader:SetText(L["AutoLoadOptions_ManageLoaders_DeleteButton"])
  removeloader.OnClick = function(_,event,mbutton)
    local loaderkey = loaderlist:GetValue()
    if loaderkey then
      if D.PresetLoaders[loaderkey] then
        print(format(L["AutoLoadOptions_ManageLoaders_ErrorDeletePreset"],label))
      else
        DB.Loaders[loaderkey] = nil
        if DBPC.Linked[loaderkey] then DBPC.Linked[loaderkey] = nil end
        widget.loaderList:SetValue("_none")
        widget.RefreshLoaders()
      end
    end
  end
  removeloader:SetCallback("OnClick",removeloader.OnClick)

  widget:AddChildren(head1,npclabel,npcid,addnpcid,npcloader,head2,loclabel,addmap,locloader,head3,loaderlist,removeloader)


end
Fn.GUI.Lists = function(widget)
  widget:ReleaseChildren()

  local list = AG:Create("EditBox")
  list.ResetData = function()
    list:SetUserData("List",nil)
    list:SetUserData("Button",nil)
  end
  list.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["PriorityLists_ListName_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["PriorityLists_ListName_Tooltip_Detail1"],nil,nil,nil,true)
    GameTooltip:AddLine(L["PriorityLists_ListName_Tooltip_Detail2"])
    GameTooltip:Show()
  end
  list.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  list.OnEnterPressed = function(_,event,text)
    local isDirty
    text = strtrim(text)
    if not text or text == "" then
      list:ClearFocus()
      list.ResetData()
      return
    end
    local valid, invalid = Fn.UTILS.validateInput(text)
    if not valid then
      print(format(L["AutoLoadOptions_InvalidInput"],label,invalid))
      list.ResetData()
      return
    end
    local oldname = list:GetUserData("List")
    if oldname then -- rename
      if oldname ~= text then
        local iBtn = list:GetUserData("Button")
        DB.Lists[text] = CopyTable(DB.Lists[oldname])
        DB.Lists[oldname] = nil
        Fn.MoveLink(oldname,text)
        if DB.Selected == oldname then DB.Selected = text end
        iBtn:SetText(text)
        iBtn:SetUserData("List",text)
        isDirty = true
      end
    end
    if valid and not DB.Lists[text] then
      DB.Lists[text] = {}
      isDirty = true
    end
    list:SetText("")
    list.ResetData()
    list:ClearFocus()
    if isDirty then
      Fn.GUI.Lists(widget)
      Fn.SVtoGUIList()
      D.OptionsFrame.Tree:SelectByValue("Lists")
    end
  end
  list:SetMaxLetters(50)
  list:SetWidth(200)
  list:SetCallback("OnEnterPressed",list.OnEnterPressed)
  list:SetCallback("OnEnter",list.OnEnter)
  list:SetCallback("OnLeave",list.OnLeave)
  list:SetLabel(L["PriorityLists_NewRenameList_Header"])
  widget:AddChild(list)

  local selected = AG:Create("Icon")
  selected.OnClick = function(_,event,mbutton)
    local listname = DB.Selected
    if listname then
      D.OptionsFrame.Tree:SelectByPath("Lists",listname)
    end
  end
  selected.OnEnter = function(widget)
    if widget.tooltip and next(widget.tooltip) then
      GameTooltip:SetOwner(widget.frame,"ANCHOR_RIGHT")
      for i,line in ipairs(widget.tooltip) do
        if i==1 then
          GameTooltip:SetText(line,1,1,1)
        else
          GameTooltip:AddLine(format("%d.%s",i-1,line))
        end
      end
      GameTooltip:Show()
    end
  end
  selected.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  selected:SetImage("Interface\\LootFrame\\LootPanel-Icon") -- alternative Interface\\MINIMAP\\TRACKING\\Target
  selected:SetImageSize(22,22)
  selected:SetWidth(23)
  selected:SetHeight(23)
  selected.tooltip = D.Tooltip
  selected:SetCallback("OnEnter",selected.OnEnter)
  selected:SetCallback("OnLeave",selected.OnLeave)
  selected:SetCallback("OnClick",selected.OnClick)

  local foundselection
  local sortedpairs = Fn.UTILS.sortedpairs
  for listname in sortedpairs(DB.Lists) do
  -- for listname in pairs(DB.Lists) do
    local iBtn = AG:Create("Button")
    iBtn.OnEnter = function(widget)
      GameTooltip:SetOwner(widget.frame,"ANCHOR_RIGHT")
      GameTooltip:SetText(L["PriorityLists_ListButton_Tooltip"] ,1,1,1)
      GameTooltip:AddLine(L["PriorityLists_ListButton_Tooltip_Detail1"])
      GameTooltip:AddLine(L["PriorityLists_ListButton_Tooltip_Detail2"])
      GameTooltip:Show()
    end
    iBtn.OnLeave = function(widget)
      if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
    end
    iBtn.OnClick = function(_,event,mbutton)
      list.ResetData()
      list:SetText("")
      local listname = iBtn:GetUserData("List")
      local ispreset = D.Presets[listname]
      if mbutton == "LeftButton" then
        DB.Selected = listname
        selected:ClearAllPoints()
        selected:SetPoint("LEFT",iBtn.frame,"RIGHT",2,5)
        widget:SetUserData("Selected",iBtn)
        selected.frame:Show()
        events.CombatCheck(Fn.SetMacro)
      elseif mbutton == "RightButton" then
        Fn.GUI.ShowListContext(widget,iBtn,list,ispreset,listname)
      end
    end
    iBtn:SetWidth(200)
    iBtn:SetText(listname)
    iBtn:SetUserData("List",listname)
    iBtn.frame:RegisterForClicks("AnyUp")
    iBtn:SetCallback("OnClick",iBtn.OnClick)
    iBtn:SetCallback("OnEnter",iBtn.OnEnter)
    iBtn:SetCallback("OnLeave",iBtn.OnLeave)
    if DB.Selected and listname == DB.Selected then
      widget:SetUserData("Selected",iBtn)
      foundselection = true
    end
    widget:AddChild(iBtn)
  end

  widget:AddChild(selected)
  widget:PauseLayout() -- needed before the manual anchoring due to quirks with AceGUI ref:
  selected:ClearAllPoints()
  selected.frame:Hide()
  if not DB.Selected or not foundselection then
    widget:SetUserData("Selected",nil)
  else
    local selBtn = widget:GetUserData("Selected")
    selected:SetPoint("LEFT",selBtn.frame,"RIGHT",2,5)
    selected.frame:Show()
  end

end
Fn.GUI.RefreshListTargets = function(container,path)
  Fn.GUI.Targets(container)
  D.OptionsFrame.Tree:SelectByValue(path)
  events.CombatCheck(Fn.SetMacro)
end
Fn.GUI.ShowPopup = function(sender,listname,list)
  local popupName = format("%s_POPUP",ADDON)
  if not StaticPopupDialogs[popupName] then
    StaticPopupDialogs[popupName] = {
      text = L["ReceiveListPrompt"],
      button1 = ACCEPT,
      button2 = DECLINE,
      OnAccept = function(self)
        DB.Lists[self.listname] = self.data
        DB.Selected = self.listname
        Fn.SVtoGUIList()
        D.OptionsFrame.Tree:RefreshTree()
        events.CombatCheck(Fn.SetMacro)
      end,
      OnCancel = function(self) self.data = nil end,
      OnHide = function(self) self.data = nil end,
      hideOnEscape = 1,
      whileDead = 1,
      preferredIndex = STATICPOPUP_NUMDIALOGS,
    }
  end
  local dialog = StaticPopup_Show(popupName,sender,listname,list)
  if (dialog) then dialog.sender = sender;dialog.listname = listname; end
end
Fn.GUI.ShowListContext = function(container,button,listedit,ispreset,listname)
  local listMenu = {
    {
      text = L["PriorityLists_ButtonMenu_Rename"],
      notCheckable = true,
      func = function()
        if ispreset then
          print(format(L["PriorityLists_MenuAction_RenamePreset_Error"],label))
        else
          listedit:SetUserData("List",listname)
          listedit:SetUserData("Button",button)
          listedit:SetText(listname)
          listedit:SetFocus()
        end
      end,
    },
    {
      text = L["PriorityLists_ButtonMenu_ManagetTargets"],
      notCheckable = true,
      func = function()
        D.OptionsFrame.Tree:SelectByPath("Lists",listname)
      end,
    },
    {
      text = L["PriorityLists_ButtonMenu_Loaders"],
      notCheckable = true,
      func = function()
        Fn.GUI.Links(listname)
      end,
    },
    {
      text = L["PriorityLists_ButtonMenu_Delete"],
      notCheckable = true,
      func = function()
        if ispreset then
          print(format(L["PriorityLists_MenuAction_DeletePreset_Error"],label))
        else
          Fn.UnLink(listname)
          DB.Lists[listname] = nil
          if DB.Selected == listname then
            DB.Selected = nil
            events.CombatCheck(Fn.SetMacro)
          end
          Fn.GUI.Lists(container)
          Fn.SVtoGUIList()
          D.OptionsFrame.Tree:SelectByValue("Lists")
        end
      end,
    },
  }

  Fn.GUI.ShowMenu(listMenu, button)
end
Fn.GUI.ShowMenu = function(listMenu)
  local contextName = format("%sContextMenuFrame",ADDON)
  D.OptionsFrame.ContextMenuFrame = D.OptionsFrame.ContextMenuFrame or CreateFrame("Frame",contextName,nil,"UIDropDownMenuTemplate")
  EasyMenu(listMenu,D.OptionsFrame.ContextMenuFrame,"cursor",0,0,"MENU")
end

Fn.GUI.CreateContextMenuFrame = function()
  local contextMenuFrameName = format("%sContextMenuFrame",ADDON)
  local contextMenuFrame = CreateFrame("Frame",contextName)

  return contextMenuFrame
end

Fn.GUI.ShowTargetContext = function(container,button,path,target,list)
  local idx = Fn.UTILS.TargetIndexByName(list,target)

  local targetMenu = {
    {
      text = L["ManageTargets_Target_Menu_RaisePriority"],notCheckable = true,disabled = idx==1,
      func = function()
        tinsert(list,idx-1,(tremove(list,idx)))
        Fn.GUI.RefreshListTargets(container,path)
      end,
    },
    {text = L["ManageTargets_Target_Menu_LowerPriority"],notCheckable = true,disabled = idx == #list,
      func = function()
        tinsert(list,idx+1,(tremove(list,idx)))
        Fn.GUI.RefreshListTargets(container,path)
      end,
    },
    {text = L["ManageTargets_Target_Menu_Delete"],notCheckable = true,
      func = function()
        tremove(list,idx)
        Fn.GUI.RefreshListTargets(container,path)
      end,
    },
  }

  Fn.GUI.ShowMenu(targetMenu, button)
end
Fn.GUI.Targets = function(widget)
  widget:ReleaseChildren()
  -- targets: add/remove/edit, move up/down, send to group (enabled if leader)
  local listname = widget:GetUserData("List")
  local path = widget:GetUserData("Path")
  if not DB.Lists[listname] then return end
  local list = DB.Lists[listname]
  local ispreset = D.Presets[listname]

  local sendtogroup = AG:Create("Button")

  sendtogroup.frame:SetScript("OnEvent",function()
    sendtogroup:SetDisabled(not (UnitIsGroupLeader("player") or theButton.DEBUG))
  end)

  sendtogroup.frame:SetMotionScriptsWhileDisabled(true)
  sendtogroup.frame:RegisterEvent("PARTY_LEADER_CHANGED")
  sendtogroup.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  sendtogroup:SetDisabled(not (UnitIsGroupLeader("player") or theButton.DEBUG))

  sendtogroup.OnClick = function(_,event,mbutton)
    Fn.SendListComm(listname,list)
  end
  sendtogroup.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    local enabled = widget.frame:IsEnabled()

    if enabled then
      GameTooltip:SetText(L["ManageTargets_SendToGroup_Tooltip"],1,1,1)
    else
      GameTooltip:SetText(L["ManageTargets_SendToGroup_Tooltip"],0.5,0.5,0.5)
    end
    GameTooltip:AddLine(enabled and L["ManageTargets_SendToGroup_Tooltip_Detail_Leader"] or L["ManageTargets_SendToGroup_Tooltip_Detail_NotLeader"])
    GameTooltip:Show()
  end
  sendtogroup.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  sendtogroup:SetWidth(L["PriorityLists_Element_Width"])
  sendtogroup:SetText(L["ManageTargets_SendToGroup"])
  sendtogroup:SetCallback("OnClick",sendtogroup.OnClick)
  sendtogroup:SetCallback("OnEnter",sendtogroup.OnEnter)
  sendtogroup:SetCallback("OnLeave",sendtogroup.OnLeave)
  widget:AddChild(sendtogroup)

  local newtarget = AG:Create("EditBox")
  newtarget.OnEnterPressed = function(_,event,text)
    local isDirty
    targetName = strtrim(text)
    if not targetName or targetName == "" then
      newtarget:ClearFocus()
      return
    end
    local valid, invalid = Fn.UTILS.validateInput(targetName)
    if not valid then
      print(format(L["AutoLoadOptions_InvalidInput"],label,invalid))
      return
    end
    if valid and not Fn.UTILS.targetListContains(list,targetName) then
      local target = {Name = targetName, Enabled = true}
      tinsert(list, target)
      isDirty = true
    end
    newtarget:SetText("")
    newtarget:ClearFocus()
    if isDirty then
      Fn.GUI.RefreshListTargets(widget,path)
    end
  end
  newtarget.OnEnter = function(widget)
    GameTooltip:SetOwner(widget.frame,"ANCHOR_TOPLEFT")
    GameTooltip:SetText(L["ManageTargets_NewTarget_Tooltip"],1,1,1)
    GameTooltip:AddLine(L["ManageTargets_NewTarget_Tooltip_Detail"],nil,nil,nil,true)
    GameTooltip:Show()
  end
  newtarget.OnLeave = function(widget)
    if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
  end
  newtarget:SetMaxLetters(50)
  newtarget:SetWidth(L["PriorityLists_Element_Width"])
  newtarget:SetCallback("OnEnterPressed",newtarget.OnEnterPressed)
  newtarget:SetCallback("OnEnter",newtarget.OnEnter)
  newtarget:SetCallback("OnLeave",newtarget.OnLeave)
  newtarget:SetLabel(L["ManageTargets_NewTarget"])
  widget:AddChild(newtarget)

  local addtarget = AG:Create("Button")
  addtarget:SetWidth(120)
  addtarget.OnClick = function(_,event,mbutton)
    if UnitExists("target") and UnitCanAttack("player","target") then
      local target = GetUnitName("target",true)
      newtarget:SetText(target)
      newtarget:SetFocus()
    end
  end
  addtarget:SetText(L["ManageTargets_NewTarget_AddTarget"])
  addtarget:SetCallback("OnClick",addtarget.OnClick)
  widget:AddChild(addtarget)

  for idx, target in ipairs(list) do
    local iBtn = AG:Create("Button")
    iBtn.OnClick = function(_,event,mbutton)
      newtarget:SetText("")
      Fn.GUI.ShowTargetContext(widget,iBtn,path,target.Name,list)
    end
    iBtn.OnEnter = function(widget)
      GameTooltip:SetOwner(widget.frame,"ANCHOR_RIGHT")
      GameTooltip:SetText(L["ManageTargets_Target_Tooltip"],1,1,1)
      GameTooltip:AddLine(L["ManageTargets_Target_Tooltip_Detail"])
      GameTooltip:Show()
    end
    iBtn.OnLeave = function(widget)
      if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
    end
    iBtn:SetWidth(L["PriorityLists_Element_Width"])
    iBtn:SetText(target.Name)
    iBtn.frame:RegisterForClicks("AnyUp")
    iBtn:SetCallback("OnClick",iBtn.OnClick)
    iBtn:SetCallback("OnEnter",iBtn.OnEnter)
    iBtn:SetCallback("OnLeave",iBtn.OnLeave)
    widget:AddChild(iBtn)

    local targetEnabledCheckBox = AG:Create("CheckBox")

    targetEnabledCheckBox.OnValueChanged = function(widget,event,value)
      target.Enabled = not not value
      Fn.SetMacro()
    end
    targetEnabledCheckBox.OnEnter = function(widget)
      GameTooltip:SetOwner(widget.frame,"ANCHOR_RIGHT")
      GameTooltip:SetText(target.Name,1,1,1)
      GameTooltip:AddLine(L["Managetargets_TargetEnabledCheckBox_Tooltip_Detail1"])
      GameTooltip:AddLine(L["Managetargets_TargetEnabledCheckBox_Tooltip_Detail2"])
      GameTooltip:Show()
    end
    targetEnabledCheckBox.OnLeave = function(widget)
      if GameTooltip:IsOwned(widget.frame) then GameTooltip_Hide() end
    end

    targetEnabledCheckBox:SetWidth(30)
    targetEnabledCheckBox:SetLabel("")
    targetEnabledCheckBox:SetValue(target.Enabled)
    targetEnabledCheckBox:SetCallback("OnValueChanged", targetEnabledCheckBox.OnValueChanged)
    targetEnabledCheckBox:SetCallback("OnEnter", targetEnabledCheckBox.OnEnter)
    targetEnabledCheckBox:SetCallback("OnLeave", targetEnabledCheckBox.OnLeave)

    widget:AddChild(targetEnabledCheckBox)
  end
end
Fn.CreateOptionsGUI = function()
  if D.OptionsFrame then return D.OptionsFrame end
  if not Fn.InCombat() then
    Fn.SVtoGUIList()
    -- Create the frame container
    local options = AG:Create("Frame")
    options.OnClose = function(widget,event)
      if D.OptionsFrame then
        if D.OptionsFrame.Links and D.OptionsFrame.Links:IsVisible() then
          D.OptionsFrame.Links:Hide()
        end
        if D.MapOverlay then D.MapOverlay:Hide() end
        CloseDropDownMenus()
      end
    end
    options:SetTitle(label)
    options:SetStatusText(format(L["OptionsFrame_StatusText"], ADDON))
    options:SetLayout("Flow")
    options:SetWidth(L["OptionsFrame_Width"])
    options:SetHeight(L["OptionsFrame_Height"])
    options:EnableResize(false)
    options:SetCallback("OnClose",options.OnClose)

    local tree = AG:Create("TreeGroup")
    tree.OnGroupSelected = function(widget,event,value)
      widget:ReleaseChildren()
      local path = value
      local section, targets = ("\001"):split(value)
      local scrollcontainer = AG:Create("InlineGroup")
      scrollcontainer:SetFullWidth(true)
      scrollcontainer:SetFullHeight(true)
      scrollcontainer:SetLayout("Fill")
      local scroll = AG:Create("ScrollFrame")
      scroll:SetUserData("Path",value)
      scroll:SetLayout("Flow")
      scrollcontainer:AddChild(scroll)
      widget:AddChild(scrollcontainer)
      if section == L["Menu_General_Value"] then
        scrollcontainer:SetTitle(section)
        Fn.GUI.General(scroll)
      elseif section == L["Menu_Lists_Value"] then
        if targets then
          scrollcontainer:SetTitle(targets)
          scroll:SetUserData("List",targets)
          Fn.GUI.Targets(scroll)
        else
          scrollcontainer:SetTitle(section)
          options.listPanel = scroll
          Fn.GUI.Lists(scroll)
        end
      elseif section == L["Menu_Loaders_Value"] then
        scrollcontainer:SetTitle(section)
        Fn.GUI.Loaders(scroll)
      end
    end
    tree:SetLayout("Fill")
    tree:SetCallback("OnGroupSelected",tree.OnGroupSelected)
    tree:SetFullWidth(true)
    tree:SetFullHeight(true)
    tree:SetTree(D.Tree)
    tree:SelectByValue(L["Menu_General_Value"])

    options:AddChild(tree)
    options.Tree = tree


    options:Hide()
    options.frame:SetScript("OnEvent",function() options:Hide() end)
    options.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    local optionsFrameName = format("%sOptionFrame",ADDON)
    _G[optionsFrameName] = options.frame
    UISpecialFrames[#UISpecialFrames+1] = optionsFrameName
    options.frame:SetClampRectInsets(200,-200,20,330)
    options.frame:SetClampedToScreen(true)
    return options
  else
    print(format(L["Error_GUIOptions_InCombat"],label))
    events.CombatCheck(Fn.CreateOptionsGUI)
  end
end
Fn.ToggleButton = function()
  if not Fn.InCombat() then
    if theButton then
      theButton:SetShown(not theButton:IsShown())
      DBPC.Visible = not not theButton:IsShown()
    end
  else
    print(format(L["Error_ButtonVisibility_InCombat"],label))
  end
end
Fn.OptionsGUI = function()
  D.OptionsFrame = D.OptionsFrame or Fn.CreateOptionsGUI()
  if D.OptionsFrame then
    if D.OptionsFrame:IsVisible() then
      D.OptionsFrame:Hide()
    else
      D.OptionsFrame:Show()
    end
  end
end
Fn.MapMonitor = function()
  if D.MapOverlay then return D.MapOverlay end
  local overlayName = format("%s_OVERLAY",ADDON)
  local overlay = CreateFrame("Frame",overlayName,WorldMapFrame)
  overlay:EnableMouse(false)
  local texture = overlay:CreateTexture(nil,"OVERLAY",nil,7)
  texture:SetColorTexture(0.6,0.8,0.8,0.5)
  texture:SetAllPoints()
  overlay.texture = texture
  overlay:SetFrameLevel(10000)
  overlay:SetSize(0,0)
  overlay.lastUpdate = 0
  overlay.Functions = {}
  overlay.Functions.ClearData = function()
    if GameTooltip:IsOwned(overlay) then GameTooltip_Hide() end
    overlay.lastUpdate = 0
    overlay.mapID = nil
    wipe(overlay.Start or {})
    wipe(overlay.End or {})
    wipe(overlay.Current or {})
    overlay.Monitoring = nil
    overlay.tooltip = nil
    overlay:SetSize(0,0)
    overlay:ClearAllPoints()
    overlay:Hide()
  end
  overlay.Functions.CurrentMapPosition = function(status)
    local tStore = overlay[status]
    local x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
    if x and y and x > 0 and y > 0 and MouseIsOver(WorldMapFrame.ScrollContainer) then
      local left, top = WorldMapFrame:GetLeft(), WorldMapFrame:GetTop()
      local width = WorldMapFrame:GetWidth()
      local height = WorldMapFrame:GetHeight()
      local scale = WorldMapFrame:GetEffectiveScale()
      local cposX,cposY = GetCursorPosition()
      local cx,cy = tonumber(floor(x*1000 + 0.5)/10), tonumber(floor(y*1000 + 0.5)/10)
      tStore["x"],tStore["y"] = cx, cy
      if status == "Current" or status == "Start" then
        tStore["xa"],tStore["ya"] = (cposX/scale - left), (top - cposY/scale)
        if status == "Current" then
          tStore["width"],tStore["height"] = width,height
        end
      end
    else
      tStore["x"],tStore["y"] = nil,nil
      return
    end
  end
  overlay.Functions.MapUpdate = function()
    local mapID = WorldMapFrame:GetMapID()
    if (mapID ~= overlay.mapID) then
      overlay:Hide()
      return
    end
  end
  overlay.Functions.StartCapture = function()
    local loclabel = overlay.Monitoring
    overlay.mapID = loclabel:GetUserData("MAP_ID")
    overlay.Start = overlay.Start or {}
    overlay.Functions.CurrentMapPosition("Start")
    overlay:Show()
  end
  overlay.Functions.EndCapture = function()
    local loclabel = overlay.Monitoring
    local mapID = Fn.GetMapData()
    if (mapID ~= overlay.mapID) then
      overlay:Hide()
      return
    end
    overlay.End = overlay.End or {}
    overlay.Functions.CurrentMapPosition("End")
    local west = min(overlay.Start["x"],overlay.End["x"])
    local east = max(overlay.Start["x"],overlay.End["x"])
    local north = min(overlay.Start["y"],overlay.End["y"])
    local south = max(overlay.Start["y"],overlay.End["y"])
    loclabel:SetUserData("BOUND_WEST",west)
    loclabel:SetUserData("BOUND_NORTH",north)
    loclabel:SetUserData("BOUND_EAST",east)
    loclabel:SetUserData("BOUND_SOUTH",south)
    loclabel.SetTextFields()
  end
  overlay.Functions.Update = function(self,elapsed)
    overlay.lastUpdate = overlay.lastUpdate + elapsed
    if not IsMouseButtonDown("LeftButton") then return end
    if overlay.lastUpdate >= TOOLTIP_UPDATE_TIME then
      overlay.Current = overlay.Current or {}
      overlay.Functions.CurrentMapPosition("Current")
      local startX,startY = overlay.Start["xa"],overlay.Start["ya"]
      local endX,endY = overlay.Current["xa"],overlay.Current["ya"]
      local width,height = overlay.Current["width"],overlay.Current["height"]
      local point,offx,offy
      if endY > startY then
        point = "TOP"
        offy = -startY
      else
        point = "BOTTOM"
        offy = height - startY
      end
      if endX > startX then
        point = point.."LEFT"
        offx = startX
      else
        point = point.."RIGHT"
        offx = startX - width
      end
      overlay:ClearAllPoints()
      overlay:SetPoint(point,offx,offy)
      overlay:SetWidth(abs(endX-startX))
      overlay:SetHeight(abs(endY-startY))
    end
  end
  overlay:SetScript("OnUpdate",overlay.Functions.Update)
  WorldMapFrame.ScrollContainer:HookScript("OnMouseDown",function(self,mbutton)
    if mbutton == "LeftButton" and overlay.Monitoring then
      if self:IsMouseOver() then
        overlay.Functions.StartCapture()
      end
    end
  end)
  WorldMapFrame.ScrollContainer:HookScript("OnMouseUp",function(self,mbutton)
    if mbutton == "LeftButton" and overlay.Monitoring then
      if self:IsMouseOver() then
        overlay.Functions.EndCapture()
      end
    end
  end)
  WorldMapFrame.ScrollContainer:HookScript("OnEnter",function(self)
    if overlay.Monitoring and overlay.tooltip then
      GameTooltip:SetOwner(overlay,"ANCHOR_CURSOR",0,-15)
      GameTooltip:SetText(label,1,1,1)
      GameTooltip:AddLine(overlay.tooltip,nil,nil,nil,true)
      GameTooltip:Show()
    end
  end)
  WorldMapFrame.ScrollContainer:HookScript("OnLeave",function(self)
    if GameTooltip:IsOwned(overlay) then GameTooltip_Hide() end
  end)
  WorldMapFrame:HookScript("OnHide",function()
    overlay:SetSize(0,0)
    overlay:ClearAllPoints()
    overlay:Hide()
  end)
  overlay:SetScript("OnHide",function(self)
    overlay.Functions.ClearData()
  end)
  overlay:Hide()
  hooksecurefunc(WorldMapFrame, "OnMapChanged", overlay.Functions.MapUpdate)
  D.MapOverlay = overlay
  return overlay
end
Fn.InCombat = function()
  return InCombatLockdown() or UnitAffectingCombat("player")
end
Fn.PositionSave = function()
  local efscale = theButton:GetEffectiveScale()
  DBPC.posx = theButton:GetLeft() * efscale
  DBPC.posy = theButton:GetTop() * efscale
end
Fn.PositionLoad = function()
  local posx,posy = DBPC.posx, DBPC.posy
  if not (posx and posy) then theButton:Show() return end
  local efscale = theButton:GetEffectiveScale()
  theButton:ClearAllPoints()
  theButton:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",posx/efscale,posy/efscale)
  Fn.SetAutoLoad(DBPC.AutoLoad)
  if not theButton:IsShown() then
    print(format("%s: /ptarget",label))
  end
end
Fn.GetMacroParts = function()
  local preMacro, targetMacro, postMacro = "", "", ""
  local targetCommand = DB.Exact and "/targetexact" or "/targetenemy"

  if not DB.SafeTargeting then
    preMacro = "/cleartarget\n"
    targetMacro = targetCommand .. " [noexists][noharm][dead] %s\n"
  else
    preMacro = "/focus [@target,harm,nodead]\n/cleartarget\n"
    targetMacro = targetCommand .. " %s\n/stopmacro [nodead,harm]\n/cleartarget [dead][noharm]"
    postMacro = "\n/target [@focus,harm,nodead]\n/focus [@none]"
  end

  return preMacro, targetMacro, postMacro
end
Fn.SetMacro = function()
  local preMacro, targetMacro, postMacro = Fn.GetMacroParts()
  local list = DB.Lists[DB.Selected]
  if type(list) == "table" and next(list) then
    local macrotext = ""
    local formatstring = targetMacro

    for i,target in ipairs(list) do
      if target.Enabled then
        macrotext = strlen(macrotext) == 0 and format(formatstring,target.Name) or (macrotext.."\n"..format(formatstring,target.Name))
      end
    end

    if macrotext ~= "" then
      macrotext = format("%s%s%s",preMacro,macrotext,postMacro)
      theButton:SetAttribute("type","macro")
      theButton:SetAttribute("macrotext",macrotext)
      theButton.icon:SetDesaturated(nil)
      Fn.tooltipAdd(DB.Selected,unpack(list))
    end
  else
    theButton:SetAttribute("macrotext",nil)
    theButton.icon:SetDesaturated(1)
    Fn.tooltipAdd(TARGET_TOKEN_NOT_FOUND)
  end
end
Fn.tooltipAdd = function(listName, ...)
  wipe(D.Tooltip)

  tinsert(D.Tooltip, listName)

  for i=1,select("#",...) do
    local target = select(i,...)

    if target.Enabled then
      tinsert(D.Tooltip, target.Name)
    end
  end
end
Fn.SkinButton = function()
  if theButton then
    local E = unpack(ElvUI)
    local AB = E:GetModule('ActionBars')
    AB:StyleButton(theButton)
  end
end
Fn.theButton = function()
  if theButton then return end

  theButton = CreateFrame("Button",ADDON,UIParent,"SecureActionButtonTemplate,ActionButtonTemplate")
  theButton:SetWidth(35)
  theButton:SetHeight(35)
  theButton:ClearAllPoints()
  theButton:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  theButton:EnableMouse(true)
  theButton:RegisterForDrag("LeftButton")
  theButton:RegisterForClicks("AnyUp")
  theButton:SetMovable(true)
  theButton:SetClampedToScreen(true)
  theButton:SetScript("OnDragStart", function(self) if not Fn.InCombat() and IsAltKeyDown() then self:StartMoving() end end)
  theButton:SetScript("OnDragStop", function(self) if not Fn.InCombat() then self:StopMovingOrSizing() Fn.PositionSave() end end)
  theButton:SetScript("OnEnter", function(self)
    if self.tooltip and next(self.tooltip) then
      GameTooltip:SetOwner(self,"ANCHOR_TOP")
      for i,line in ipairs(self.tooltip) do
        if i==1 then
          GameTooltip:SetText(line,1,1,1)
        else
          GameTooltip:AddLine(format("%d.%s",i-1,line))
        end
      end
      GameTooltip:AddLine(L["ActionButton_Tooltip"])
      GameTooltip:Show()
    end
  end)
  theButton:SetScript("OnLeave",function(self) if GameTooltip:IsOwned(self) then GameTooltip_Hide() end end)
  theButton:SetScript("OnHide",function(self) if GameTooltip:IsOwned(self) then GameTooltip_Hide() end end)
  theButton.icon = _G[format("%sIcon",ADDON)]
  theButton.icon:SetTexture(format("Interface\\AddOns\\%s\\Reticule",ADDON))
  theButton.hotkey = _G[format("%sHotKey",ADDON)]
--    theButton.DEBUG = true
  events.UPDATE_BINDINGS()
  events:RegisterEvent("UPDATE_BINDINGS")
  Fn.tooltipAdd(TARGET_TOKEN_NOT_FOUND)
  theButton.tooltip = D.Tooltip
  theButton.icon:SetDesaturated(1)
  theButton:SetShown(not not DBPC.Visible)
  events.CombatCheck(Fn.SetMacro)
  tinsert(delay_queue,Fn.PositionLoad)
  events.RunAfter(2.0,true)

  if IsAddOnLoaded("ElvUI") then
    Fn.SkinButton()
  end
end
_G["BINDING_NAME_CLICK prioTarget:LeftButton"] = L["ActionButton_Binding_Text"]
BINDING_HEADER_PRIOTARGET_HEADER = ADDON
-- _G[ADDON.."API"] = Fn.API
--[[
]]
