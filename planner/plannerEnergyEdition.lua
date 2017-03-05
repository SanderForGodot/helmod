require "planner/plannerAbstractEdition"

-------------------------------------------------------------------------------
-- Classe to build recipe edition dialog
--
-- @module PlannerEnergyEdition
-- @extends #PlannerDialog
--

PlannerEnergyEdition = setclass("HMPlannerEnergyEdition", PlannerDialog)

-------------------------------------------------------------------------------
-- On initialization
--
-- @function [parent=#PlannerEnergyEdition] on_init
--
-- @param #PlannerController parent parent controller
--
function PlannerEnergyEdition.methods:on_init(parent)
	self.panelCaption = ({"helmod_energy-edition-panel.title"})
	self.player = self.parent.parent
	self.model = self.parent.model
end

-------------------------------------------------------------------------------
-- Get the parent panel
--
-- @function [parent=#PlannerEnergyEdition] getParentPanel
--
-- @param #LuaPlayer player
--
-- @return #LuaGuiElement
--
function PlannerEnergyEdition.methods:getParentPanel(player)
	return self.parent:getDialogPanel(player)
end

-------------------------------------------------------------------------------
-- Get or create panel
--
-- @function [parent=#PlannerEnergyEdition] getPowerPanel
--
-- @param #LuaPlayer player
--
function PlannerEnergyEdition.methods:getPowerPanel(player)
  local panel = self:getPanel(player)
  if panel["power"] ~= nil and panel["power"].valid then
    return panel["power"]
  end
  return self:addGuiFrameV(panel, "power", "helmod_frame_resize_row_width")
end

-------------------------------------------------------------------------------
-- Get or create generator panel
--
-- @function [parent=#PlannerEnergyEdition] getPrimaryPanel
--
-- @param #LuaPlayer player
--
function PlannerEnergyEdition.methods:getPrimaryPanel(player)
  local panel = self:getPanel(player)
  if panel["Primary"] ~= nil and panel["Primary"].valid then
    return panel["Primary"]
  end
  return self:addGuiFlowH(panel, "Primary", "helmod_flow_resize_row_width")
end

-------------------------------------------------------------------------------
-- Get or create info panel
--
-- @function [parent=#PlannerEnergyEdition] getPrimaryInfoPanel
--
-- @param #LuaPlayer player
--
function PlannerEnergyEdition.methods:getPrimaryInfoPanel(player)
  local panel = self:getPrimaryPanel(player)
  if panel["info"] ~= nil and panel["info"].valid then
    return panel["info"]
  end
  return self:addGuiFrameV(panel, "info", "helmod_frame_recipe_factory", ({"helmod_common.primary-generator"}))
end

-------------------------------------------------------------------------------
-- Get or create selector panel
--
-- @function [parent=#PlannerEnergyEdition] getPrimarySelectorPanel
--
-- @param #LuaPlayer player
--
function PlannerEnergyEdition.methods:getPrimarySelectorPanel(player)
  local panel = self:getPrimaryPanel(player)
  if panel["selector"] ~= nil and panel["selector"].valid then
    return panel["selector"]
  end
  return self:addGuiFrameV(panel, "selector", "helmod_frame_recipe_factory", ({"helmod_common.generator"}))
end

-------------------------------------------------------------------------------
-- Build header panel
--
-- @function [parent=#PlannerEnergyEdition] buildHeaderPanel
--
-- @param #LuaPlayer player
--
function PlannerEnergyEdition.methods:buildHeaderPanel(player)
  Logging:debug("PlannerEnergyEdition:buildHeaderPanel():",player)
  self:getPowerPanel(player)
end

-------------------------------------------------------------------------------
-- Build primary panel
--
-- @function [parent=#PlannerEnergyEdition] buildPrimaryPanel
--
-- @param #LuaPlayer player
--
function PlannerEnergyEdition.methods:buildPrimaryPanel(player)
  Logging:debug("PlannerEnergyEdition:buildPrimaryPanel():",player)
  self:getPrimaryInfoPanel(player)
  self:getPrimarySelectorPanel(player)
end

-------------------------------------------------------------------------------
-- Get object
--
-- @function [parent=#PlannerEnergyEdition] getObject
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:getObject(player, element, action, item, item2, item3)
  local model = self.model:getModel(player)
  if  model.powers[item] ~= nil then
    -- return power
    return model.powers[item]
  end
  return nil
end

-------------------------------------------------------------------------------
-- On open
--
-- @function [parent=#PlannerEnergyEdition] on_open
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
-- @return #boolean if true the next call close dialog
--
function PlannerEnergyEdition.methods:on_open(player, element, action, item, item2, item3)
	Logging:debug("PlannerRecipeSelector:on_open():",player, element, action, item, item2, item3)
  local model = self.model:getModel(player)
  local close = true
  if model.guiPowerLast == nil or model.guiPowerLast ~= item then
    close = false
  end
  model.guiPowerLast = item
  model.primaryGroupSelected = nil
  return close
end

-------------------------------------------------------------------------------
-- On close dialog
--
-- @function [parent=#PlannerEnergyEdition] on_close
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:on_close(player, element, action, item, item2, item3)
	local model = self.model:getModel(player)
end

-------------------------------------------------------------------------------
-- After open
--
-- @function [parent=#PlannerEnergyEdition] after_open
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:after_open(player, element, action, item, item2, item3)
  Logging:debug("PlannerEnergyEdition:after_open():",player, element, action, item, item2, item3)
  self.parent:send_event(player, "HMPlannerProductEdition", "CLOSE")
  self.parent:send_event(player, "HMPlannerRecipeSelector", "CLOSE")
  self.parent:send_event(player, "HMPlannerSettings", "CLOSE")
  
  self:buildHeaderPanel(player)
  self:buildPrimaryPanel(player)
end

-------------------------------------------------------------------------------
-- On event
--
-- @function [parent=#PlannerEnergyEdition] on_event
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:on_event(player, element, action, item, item2, item3)
  Logging:debug("PlannerEnergyEdition:on_event():",player, element, action, item, item2, item3)
  local model = self.model:getModel(player)

  if action == "power-update" then
    local inputPanel = self:getPowerPanel(player)["table-input"]
    local options = {}

    if inputPanel["power"] ~= nil then
      options["power"] = self:getInputNumber(inputPanel["power"])
    end

    self.model:updatePower(player, item, options)
    self:updatePowerInfo(player, element, action, item, item2, item3)
    self.parent:refreshDisplayData(player, nil, item, item2)
  end

  if action == "primary-group" then
    model.primaryGroupSelected = item2
    self:updatePrimarySelector(player, element, action, item, item2, item3)
  end

  if action == "primary-select" then
    local object = self:getObject(player, element, action, item, item2, item3)
    if object ~= nil then
      local power = self.model:addPrimaryPower(player, item, item2)
    else
      local power = self.model:addPrimaryPower(player, nil, item2)
      item = power.id
    end
    self.model:computePower(player, item)
    self.parent:refreshDisplayData(player)
    self:send_event(player, element, "CLOSE", item, item2, item3)
    self:send_event(player, element, "OPEN", item, item2, item3)
  end
end

-------------------------------------------------------------------------------
-- On update
--
-- @function [parent=#PlannerEnergyEdition] on_update
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:on_update(player, element, action, item, item2, item3)
  self:updatePowerInfo(player, element, action, item, item2, item3)
  self:updatePrimary(player, element, action, item, item2, item3)
end

-------------------------------------------------------------------------------
-- Update information
--
-- @function [parent=#PlannerEnergyEdition] updatePowerInfo
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:updatePowerInfo(player, element, action, item, item2, item3)
  Logging:debug("PlannerEnergyEdition:updatePowerInfo():",player, element, action, item, item2, item3)
  local infoPanel = self:getPowerPanel(player)
  local model = self.model:getModel(player)
  local default = self.model:getDefault(player)

  local model = self.model:getModel(player)
  if  model.powers[item] ~= nil then
    local power = self:getObject(player, element, action, item, item2, item3)
    if power ~= nil then
      Logging:debug("PlannerEnergyEdition:updatePowerInfo():power=",power)
      for k,guiName in pairs(infoPanel.children_names) do
        infoPanel[guiName].destroy()
      end

      local tablePanel = self:addGuiTable(infoPanel,"table-input",2)

      self:addGuiLabel(tablePanel, "label-power", ({"helmod_energy-edition-panel.power"}))
      self:addGuiText(tablePanel, "power", math.ceil(power.power/1000)/1000, "helmod_textfield")

      self:addGuiButton(tablePanel, self:classname().."=power-update=ID="..item.."=", power.id, "helmod_button_default", ({"helmod_button.update"}))    --
    end
  end
end
-------------------------------------------------------------------------------
-- Update Primary
--
-- @function [parent=#PlannerEnergyEdition] updatePrimary
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:updatePrimary(player, element, action, item, item2, item3)
  Logging:debug("PlannerEnergyEdition:updatePrimary():",player, element, action, item, item2, item3)
  local model = self.model:getModel(player)

  self:updatePrimaryInfo(player, element, action, item, item2, item3)
  self:updatePrimarySelector(player, element, action, item, item2, item3)
end

-------------------------------------------------------------------------------
-- Update information
--
-- @function [parent=#PlannerEnergyEdition] updatePrimaryInfo
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:updatePrimaryInfo(player, element, action, item, item2, item3)
  Logging:debug("PlannerEnergyEdition:updatePrimaryInfo():",player, element, action, item, item2, item3)
  local infoPanel = self:getPrimaryInfoPanel(player)
  local object = self:getObject(player, element, action, item, item2, item3)
  local model = self.model:getModel(player)
  
  for k,guiName in pairs(infoPanel.children_names) do
    infoPanel[guiName].destroy()
  end

  if object ~= nil then
    Logging:debug("PlannerEnergyEdition:updatePrimaryInfo():object:",object)
    local primary = object.primary
    local _generator = self.player:getItemPrototype(primary.name)

    local headerPanel = self:addGuiTable(infoPanel,"table-header",2)
    local tooltip = ({"tooltip.selector-module"})
    if model.module_panel == true then tooltip = ({"tooltip.selector-factory"}) end
    self:addGuiButtonSprite(headerPanel, self:classname().."=do-nothing=ID=", self.player:getIconType(primary), primary.name, primary.name, tooltip)
    if _generator == nil then
      self:addGuiLabel(headerPanel, "label", primary.name)
    else
      self:addGuiLabel(headerPanel, "label", _generator.localised_name)
    end

    local inputPanel = self:addGuiTable(infoPanel,"table-input",2)

    self:addGuiLabel(inputPanel, "label-energy-nominal", ({"helmod_label.energy-nominal"}))
    self:addGuiLabel(inputPanel, "energy-nominal", primary.energy_nominal)

    self:addGuiLabel(inputPanel, "label-fluid-usage", ({"helmod_label.fluid-usage"}))
    self:addGuiLabel(inputPanel, "fluid-usage", primary.fluid_usage)

    self:addGuiLabel(inputPanel, "label-effectivity", ({"helmod_label.effectivity"}))
    self:addGuiLabel(inputPanel, "effectivity", primary.effectivity)

--    self:addGuiLabel(inputPanel, "label-energy", ({"helmod_label.energy"}))
--    local sign = "+"
--    if factory.effects.consumption < 0 then sign = "-" end
--    self:addGuiLabel(inputPanel, "energy", factory.energy.." ("..sign..self:formatPercent(factory.effects.consumption).."%)")
--
--    local sign = "+"
--    if factory.effects.speed < 0 then sign = "-" end
--    self:addGuiLabel(inputPanel, "label-speed", ({"helmod_label.speed"}))
--    self:addGuiLabel(inputPanel, "speed", factory.speed.." ("..sign..self:formatPercent(factory.effects.speed).."%)")
--
--    local sign = "+"
--    if factory.effects.productivity < 0 then sign = "-" end
--    self:addGuiLabel(inputPanel, "label-productivity", ({"helmod_label.productivity"}))
--    self:addGuiLabel(inputPanel, "productivity", sign..self:formatPercent(factory.effects.productivity).."%")
--
--    self:addGuiLabel(inputPanel, "label-limit", ({"helmod_label.limit"}))
--    self:addGuiText(inputPanel, "limit", factory.limit, "helmod_textfield")
--
--    self:addGuiButton(infoPanel, self:classname().."=factory-update=ID="..item.."=", object.name, "helmod_button_default", ({"helmod_button.update"}))
  end
end

-------------------------------------------------------------------------------
-- Update selector
--
-- @function [parent=#PlannerEnergyEdition] updatePrimarySelector
--
-- @param #LuaPlayer player
-- @param #LuaGuiElement element button
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function PlannerEnergyEdition.methods:updatePrimarySelector(player, element, action, item, item2, item3)
  Logging:debug("PlannerEnergyEdition:updatePrimarySelector():",player, element, action, item, item2, item3)
  local globalSettings = self.player:getGlobal(player, "settings")
  local selectorPanel = self:getPrimarySelectorPanel(player)
  local model = self.model:getModel(player)

  if selectorPanel["scroll-primary"] ~= nil and selectorPanel["scroll-primary"].valid then
    selectorPanel["scroll-primary"].destroy()
  end
  local scrollPanel = self:addGuiScrollPane(selectorPanel, "scroll-primary", "helmod_scroll_recipe_factories", "auto", "auto")

  local object = self:getObject(player, element, action, item, item2, item3)

  local groupsPanel = self:addGuiTable(scrollPanel, "primary-groups", 1)
  
  local category = "primary"
  if globalSettings.model_filter_generator ~= nil and globalSettings.model_filter_generator == false then category = nil end
  -- ajouter de la table des groupes de recipe
  local factories = self.player:getGenerators()
  Logging:debug("factories:",factories)


  if category == nil then
    local subgroups = {}
    for key, factory in pairs(factories) do
      local subgroup = factory.subgroup.name
      if subgroup ~= nil then
        if subgroups[subgroup] == nil then
          subgroups[subgroup] = 1
        else
          subgroups[subgroup] = subgroups[subgroup] + 1
        end
      end
    end

    for group, count in pairs(subgroups) do
      -- set le groupe
      if model.primaryGroupSelected == nil then model.primaryGroupSelected = group end
      -- ajoute les icons de groupe
      local action = self:addGuiButton(groupsPanel, self:classname().."=primary-group=ID="..item.."=", group, "helmod_button_default", group)
    end
  end

  local tablePanel = self:addGuiTable(scrollPanel, "primary-table", 5)
  --Logging:debug("factories:",self.player:getProductions())
  for key, element in pairs(factories) do
    if category ~= nil or (element.subgroup ~= nil and element.subgroup.name == model.primaryGroupSelected) then
      local localised_name = element.localised_name
      if globalSettings.real_name == true then
        localised_name = element.name
      end
      self:addGuiButtonSelectSprite(tablePanel, self:classname().."=primary-select=ID="..item.."=", "item", element.name, element.name, localised_name)
    end
  end
end
