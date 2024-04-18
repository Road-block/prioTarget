if GetLocale() ~= "ruRU" then
    return
end

PriorityTarget_Localization = PriorityTarget_Localization or {}
local L = PriorityTarget_Localization

L["OptionsFrame_Width"]                                    = 680
L["OptionsFrame_Height"]                                   = 455

L["Menu_General"]                                          = "Основные"
L["Menu_Lists"]                                            = "Списки приоритетов"
L["Menu_Loaders"]                                          = "Загрузчики"

L["Menu_General_Value"]                                    = "Основные"
L["Menu_Lists_Value"]                                      = "Списки"
L["Menu_Loaders_Value"]                                    = "Загрузчики"

L["Minimap_Click"]                                         = "|cffFF6600Кликните|r чтобы отобразить/скрыть кнопку prioTarget"
L["Minimap_RightClick"]                                    = "|cffFF6600Кликните правой кнопкой|r чтобы открыть/закрыть окно настроек"
L["Minimap_MiddleClick"]                                   = "|cffFF6600Middle Click|r to unload current list" -- needs translation

L["CommandHelp_Button"]                                    = "          /ptarget but[ton] (показать/скрыть кнопку)"
L["CommandHelp_Options"]                                   = "          /ptarget opt[ions] (открыть окно настроек)"
L["CommandHelp_Clear"]                                     = "          /ptarget cl[ear] (unload the current prio list)" -- needs translation

L["HelpText"] =
[=[    Наведите курсор на кнопку prioTarget для отображения текущего загруженного списка целей. Нажатие на кнопку prioTarget или на назначенную ей клавишу выберет наивысшую допустимую цель в списке приоритетов.

Логика выбора целей также может быть использована в макросах наподобие следующего:    
    /click prioTarget
    /cast <ИмяЗаклинания>
ИмяЗаклинания - название способности без символов <>; условия макросов также допустимы, напр. /click [mod:ctrl] prioTarget
    
Выберите пункт 'Список приоритетов' для управления списком через правую панель. Разверните дерево и выберите дочерний пункт для управление целями в списке.]=]

L["AccountSettings"]                                       = "Настройки учётной записи"


L["ExactTargetMatchingCheckBox_Width"]                     = 140

L["ExactTargetMatchingCheckBox_Tooltip"]                   = "Правила выбора цели"
L["ExactTargetMatchingCheckBox_Tooltip_Checked"]           = "Вкл.: Строгий выбор (/targetexact, |cff00ff00рекомендовано|r)"
L["ExactTargetMatchingCheckBox_Tooltip_Unchecked"]         = "Выкл.: Свободный выбор (/target)"
L["ExactTargetMatchingCheckBox_Label"]                     = "Строгий выбор"

L["SafeTargetingCheckBox_Width"] = 150

L["SafeTargetingCheckBox_Tooltip"]                         = "Безопасный выбор цели"
L["SafeTargetingCheckBox_Tooltip_Checked"]                 = "Вкл.: Восстановить текущую цель в случае неудачи. |cffff0000Включайте только если не используете запоминание цели (/focus).|r"
L["SafeTargetingCheckBox_Tooltip_Unchecked"]               = "Выкл.: В случае неудачи, текущая цель останется пустой."
L["SafeTargetingCheckBox_Label"]                           = "Безопасный выбор"

L["AutoAcceptCheckBox_Width"]                              = 130

L["AutoAcceptCheckBox_Tooltip"]                            = "Списки, отправляемые лидером группы"
L["AutoAcceptCheckBox_Tooltip_Checked"]                    = "Вкл.: Принимать автоматически"
L["AutoAcceptCheckBox_Tooltip_Unchecked"]                  = "Выкл.: Запрашивать подтверждение"
L["AutoAcceptCheckBox_Label"]                              = "Авто-приём"

L["PresetsButton_Width"]                                   = 120

L["Presets"]                                               = "Преднастройки"
L["Presets_Tooltip"]                                       = "Перезагрузить преднастройки"
L["Presets_Tooltip_Detail"]                                = "Восстановить преднастроенные списки"

L["Keybind"]                                               = "Назначение клавиш"

L["CharacterSettings"]                                     = "Настройки персонажа"

L["ButtonCheckBox_Width"]                                  = 120

L["ButtonCheckBox_Tooltip"]                                = "Кнопка prioTarget"
L["ButtonCheckBox_Tooltip_Checked"]                        = "Вкл.: Отображается"
L["ButtonCheckBox_Tooltip_Unchecked"]                      = "Выкл.: Скрыта"
L["ButtonCheckBox_Label"]                                  = "Кнопка"

L["MinimapIconCheckBox_Width"]                             = 180

L["MinimapIconCheckBox_Tooltip"]                           = "Иконка у миникарты"
L["MinimapIconCheckBox_Tooltip_Checked"]                   = "Вкл.: Отображается"
L["MinimapIconCheckBox_Tooltip_Unchecked"]                 = "Выкл.: Скрыта"
L["MinimapIconCheckBox_Label"]                             = "Иконка у миникарты"

L["AutoLoadCheckBox_Width"]                                = 100

L["AutoLoadCheckBox_Tooltip"]                              = "Авто-загрузка"
L["AutoLoadCheckBox_Tooltip_Checked"]                      = "Вкл.: Автоматически загружать списки приоритетов, связанные с НИПами или местоположениями"
L["AutoLoadCheckBox_Tooltip_Unchecked"]                    = "Выкл.: Сохранить текущие приоритеты, вручную загружать списки приоритетов"
L["AutoLoadCheckBox_Label"]                                = "Авто-загрузка"

L["AutoLoadOptions_Text"]                                  = "Настройки автозагрузки"

L["AutoLoadOptions_LinkToNPC"]                             = "Связать с НИП"
L["AutoLoadOptions_LinkToLocation"]                        = "Связать с местоположением"

L["AutoLoadOptions_UnlinkButton_Tooltip"]                  = "Отвязать"
L["AutoLoadOptions_UnlinkButton_Tooltip_Detail"]           = "Очистить загрузчики %s"
L["AutoLoadOptions_UnlinkButton_Label"]                    = "Отвязать"

L["AutoLoadOptions_NPC_Label"]                             = "ID:%s    Ссылка:%s%s|r\nИмя: %s"
L["AutoLoadOptions_NPCWowheadLink"]                        = "|cff0099CC www.wowhead.com/npc="

L["AutoLoadOptions_Location_Label"]                        = "ID:%s    Границы: W=%s N=%s E=%s S=%s\n%s%s\nName: %s"
L["AutoLoadOptions_NotSaved"]                              = "|cffff0000не сохранено|r"

L["AutoLoadOptions_LoadByNPC"]                             = "Загрузка по НИП"

L["AutoLoadOptions_InvalidInput"]                          = "%s: Введено некорретное значение %q"

L["AutoLoadOptions_LoaderName_Tooltip"]                    = "Название загружчика"
L["AutoLoadOptions_LoaderName_Tooltip_Detail"]             = "Для сохранения загрузчика введите название и нажмите Ввод"
L["AutoLoadOptions_SaveLoader"]                            = "Сохранить загрузчик"

L["AutoLoadOptions_NPCID_Label"]                           = "id НИПа"
L["AutoLoadOptions_NPCID_Tooltip"]                         = "id НИПа"
L["AutoLoadOptions_NPCID_Tooltip_Detail1"]                 = "Введите имя НИПа или используйте кнопку для добавления текущей цели"
L["AutoLoadOptions_NPCID_Tooltip_Detail2"]                 = "Нажмите ввод для установки id в загрузчик..."
L["AutoLoadOptions_NPCID_Tooltip_Detail3"]                 = "... затем введите имя загрузчика в следующем поле"

L["AutoLoadOptions_TargetNPCID_Tooltip"]                   = "id НИПа"
L["AutoLoadOptions_TargetNPCID_Tooltip_Detail"]            = "Выберите НИПа и нажмите эту кнопку для получения его ID"

L["AutoLoadOptions_LoadByLocation"]                        = "Загрузка по местоположению"

L["AutoLoadOptions_Location_Tooltip"]                      = "Местоположение"
L["AutoLoadOptions_Location_Tooltip_Detail1"]              = "Нажатие этой кнопки при закрытой карте внесёт ваше текущее местоположение"
L["AutoLoadOptions_Location_Tooltip_Detail2"]              = "Откройте карту мира (уменьшенную) и перейдите к местоположению, которое вы хотите сохранить (|cff00ff00рекомендовано|r)"
L["AutoLoadOptions_Location_Tooltip_Detail3"]              = "Нажмите эту кнопку, чтобы получить описание из карты"

L["AutoLoadOptions_MapOverlay_Tooltip"]                    = "|cffFF6600Кликните|r, перетащите и отпустите кнопку мыши для получения координат выбранной области."

L["AutoLoadOptions_ManageLoaders"]                         = "Управление загрузчиками"
L["AutoLoadOptions_ManageLoaders_SavedLoaders"]            = "Сохранённые загрузчики"
L["AutoLoadOptions_ManageLoaders_DeleteButton"]            = "Удалить"
L["AutoLoadOptions_ManageLoaders_ErrorDeletePreset"]       = "%s: Нельзя удалять преднастройки"

L["PriorityLists_Element_Width"] = 280

L["PriorityLists_ListName_Tooltip"]                        = "Название списка приоритетов"
L["PriorityLists_ListName_Tooltip_Detail1"]                = "Введите название списка и нажмите Ввод для создания пустого списка, или ..."
L["PriorityLists_ListName_Tooltip_Detail2"]                = "|cffFF6600Кликните правой кнопкой |r по существующему списку, чтобы переименовать его."

L["PriorityLists_NewRenameList_Header"]                    = "Создать новый/переименовать список"
L["PriorityLists_ListButton_Tooltip"]                      = "Список приоритетов"
L["PriorityLists_ListButton_Tooltip_Detail1"]              = "|cffFF6600Кликните|r для загрузки"
L["PriorityLists_ListButton_Tooltip_Detail2"]              = "|cffFF6600Кликните правой кнопкий|r для управления"

L["PriorityLists_ButtonMenu_Rename"]                       = "Переименовать"
L["PriorityLists_ButtonMenu_ManagetTargets"]               = "Настроить цели"
L["PriorityLists_ButtonMenu_Loaders"]                      = "Загрузчики"
L["PriorityLists_ButtonMenu_Delete"]                       = "Удалить"

L["PriorityLists_MenuAction_RenamePreset_Error"]           = "%s: Нельзя переименовывать преднастройки."
L["PriorityLists_MenuAction_DeletePreset_Error"]           = "%s: Нельзя удалять преднастройки."

L["ManageTargets_NewTarget"]                               = "Новая цель"
L["ManageTargets_NewTarget_Tooltip"]                       = "Имя новой цели"
L["ManageTargets_NewTarget_Tooltip_Detail"]                = "Вручную введите имя врага или выберите врага в цель и используйте кнопку 'Добавить цель'"
L["ManageTargets_NewTarget_AddTarget"]                     = "Добавить цель"

L["ManageTargets_Target_Tooltip"]                          = "Имя цели"
L["ManageTargets_Target_Tooltip_Detail"]                   = "|cffFF6600Кликните|r для управления"
L["ManageTargets_Target_Menu_RaisePriority"]               = "Повысить приоритет"
L["ManageTargets_Target_Menu_LowerPriority"]               = "Понизить приоритеть"
L["ManageTargets_Target_Menu_Delete"]                      = "|cffff0000Удалить|r"

L["Managetargets_TargetEnabledCheckBox_Tooltip_Detail1"]   = "Вкл. - цель включена в список"
L["Managetargets_TargetEnabledCheckBox_Tooltip_Detail2"]   = "Выкл. - цель исключена из списка"

L["ManageTargets_SendToGroup"]                             = "Отправить группе"
L["ManageTargets_SendToGroup_Tooltip"]                     = "Отправить группе"
L["ManageTargets_SendToGroup_Tooltip_Detail_Leader"]       = "|cffFF6600Кликните|r чтобы отправить этот список вашей группе."
L["ManageTargets_SendToGroup_Tooltip_Detail_NotLeader"]    = "|cffff0000Вы должны быть лидером|r"

L["ReceiveListPrompt"]                                     = "<%s> хочет отправить вам список целей <%s>"

L["Error_GUIOptions_InCombat"]                             = "%s: Нельзя отобразить интерфейс настроек в бою."
L["Error_ButtonVisibility_InCombat"]                       = "%s: Нельзя изменить видимость кнопки в бою."

L["ActionButton_Tooltip"]                                  = "|cffFF6600Alt + Клик|r для перемещения"
L["ActionButton_Binding_Text"]                             = "Выбрать приоритетную цель"

L["OptionsFrame_StatusText"]                               = "Настройки %s"

L["Hellfire_Assault"]                                      = "Штурми Цитадели Адского Пламени"
L["Hellfire_High_Council"]                                 = "Верховный Совет Адского Пламени"
L["Socretar_the_Eternal"]                                  = "Сокретар Вечный"

L["Presets_Loaded"]                                        = "Загружены преднастройки (списки/загрузчики/связки): %d/%d/%d."
L["List_Sent"]                                             = "Список \"%s\" был отправлен вашей группе."