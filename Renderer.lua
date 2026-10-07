local FC = _G.ForeverCompanion

-- RC11 deliberately uses the older 4x4 high-resolution sheet rather than the
-- 8x16 pseudo-animation atlas. Each state has roughly 2x the source resolution,
-- and transitions are crossfaded instead of flipping through mismatched poses.
local COLS = 4
local ROWS = 4

local stateCell = {
    idle = 1,
    talk = 2,
    laugh = 4,
    think = 6,
    point = 5,
    shrug = 16,
    flirty = 12,
    celebrate = 11,
    playful = 12,
    worried = 7,
    angry = 8,
    facepalm = 10,
    sleep = 14,
    sleepy = 14,
    relaxed = 15,
    magic = 13,
    combat = 13,
    recover = 1,
    death = 10,
    wake = 1,
}

local alias = {
    comeback = "playful",
    newplayer = "talk",
    charswitch = "playful",
    questdone = "playful",
    questpile = "point",
    lowhealth = "worried",
    zone = "talk",
    level = "celebrate",
}

local function setCell(texture, index)
    if not texture then return end

    index = math.max(1, math.min(COLS * ROWS, tonumber(index) or 1)) - 1
    local col = index % COLS
    local row = math.floor(index / COLS)
    local pad = 0.003

    texture:SetTexCoord(
        (col / COLS) + pad,
        ((col + 1) / COLS) - pad,
        (row / ROWS) + pad,
        ((row + 1) / ROWS) - pad
    )
end

local function easeOutCubic(t)
    local p = 1 - math.max(0, math.min(1, t))
    return 1 - p * p * p
end

function FC:CreateRenderer(parent)
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetPoint("TOPLEFT", 0, 0)
    holder:SetPoint("TOPRIGHT", 0, 0)
    holder:SetHeight(240)
    self.modelHolder = holder

    local appearance = self.db and self.db.appearance or {}
    local renderer = appearance.renderer or "sprite"
    renderer = renderer == "model" and "model" or "sprite"

    if renderer == "model" then
        local model = CreateFrame("PlayerModel", nil, holder)
        model:SetAllPoints()
        self.model = model
        self.spriteTexture = nil
        pcall(function() model:SetUnit("player") end)
        self.state.renderer = "PlayerModel"
        return holder
    end

    local textureA = holder:CreateTexture(nil, "ARTWORK")
    local textureB = holder:CreateTexture(nil, "ARTWORK")

    self.spriteTexture = textureA
    self.spriteTextureA = textureA
    self.spriteTextureB = textureB
    self.spriteFront = textureA
    self.spriteBack = textureB
    self.model = nil

    for _, texture in ipairs({ textureA, textureB }) do
        texture:SetPoint("BOTTOM", holder, "BOTTOM", 0, -8)
        texture:SetSize(244, 244)
        texture:SetTexture("Interface/AddOns/ForeverCompanion/Media/VexaSpriteSheet.tga")
        texture:SetBlendMode("BLEND")
    end

    setCell(textureA, stateCell.idle)
    setCell(textureB, stateCell.idle)
    textureA:SetAlpha(1)
    textureB:SetAlpha(0)

    self.state.renderer = "SpriteHD"
    self.spriteState = "idle"
    self.spriteTransition = nil
    self.spriteMotionClock = 0

    holder:SetScript("OnUpdate", function(_, elapsed)
        FC:UpdateSpriteRenderer(elapsed)
    end)

    return holder
end

function FC:UpdateSpriteRenderer(elapsed)
    if not self.spriteFront or not self.spriteBack or not self.modelHolder then return end

    self.spriteMotionClock = (self.spriteMotionClock or 0) + elapsed

    local appearance = self.db and self.db.appearance or {}
    local motion = math.max(0, math.min(0.35, tonumber(appearance.motion) or 0.18))

    -- Small vertical breathing only. No horizontal motion, no pose-flipping.
    local activeScale = 1
    local bob = 0
    if motion > 0 then
        local speed = self.spriteState == "talk" and 2.0 or 1.15
        bob = math.sin(self.spriteMotionClock * speed) * (0.45 + motion * 2.0)
        activeScale = 1 + math.sin(self.spriteMotionClock * speed * 0.72) * (0.0018 + motion * 0.003)
    end

    local baseSize = self.spriteBaseSize or 244
    local size = baseSize * activeScale
    for _, texture in ipairs({ self.spriteFront, self.spriteBack }) do
        texture:ClearAllPoints()
        texture:SetPoint("BOTTOM", self.modelHolder, "BOTTOM", 0, -8 + bob)
        texture:SetSize(size, size)
    end

    local transition = self.spriteTransition
    if transition then
        transition.elapsed = transition.elapsed + elapsed
        local t = easeOutCubic(transition.elapsed / transition.duration)
        self.spriteFront:SetAlpha(1 - t)
        self.spriteBack:SetAlpha(t)

        if t >= 1 then
            local oldFront = self.spriteFront
            self.spriteFront = self.spriteBack
            self.spriteBack = oldFront
            self.spriteFront:SetAlpha(1)
            self.spriteBack:SetAlpha(0)
            self.spriteTexture = self.spriteFront
            self.spriteTransition = nil
        end
    end
end

function FC:SetSpriteBaseSize(size)
    self.spriteBaseSize = tonumber(size) or 244
end

function FC:SetAnimation(kind)
    kind = alias[kind] or kind or "idle"

    if self.spriteFront and self.spriteBack then
        local targetCell = stateCell[kind] or stateCell.talk
        if kind == self.spriteState and not self.spriteTransition then return end

        setCell(self.spriteBack, targetCell)
        self.spriteBack:SetAlpha(0)
        self.spriteTransition = {
            elapsed = 0,
            duration = (kind == "idle") and 0.28 or 0.18,
        }
        self.spriteState = kind
        return
    end

    if self.model then
        local anim = {
            idle = 0,
            talk = 60,
            celebrate = 69,
            think = 4,
            point = 67,
            angry = 64,
            sleep = 97,
            death = 1,
            laugh = 70,
        }
        local id = anim[kind] or 0
        pcall(function()
            if self.model.HasAnimation and not self.model:HasAnimation(id) then id = 0 end
            self.model:SetAnimation(id)
        end)
    end
end

function FC:ApplyModelLab()
    if self.spriteFront then return end
    if not self.model then return end

    local appearance = self.db.appearance or {}
    if appearance.displayID and self.model.SetDisplayInfo then
        pcall(self.model.SetDisplayInfo, self.model, tonumber(appearance.displayID))
    elseif self.model.SetUnit then
        pcall(self.model.SetUnit, self.model, "player")
    end

    if self.model.SetFacing then
        pcall(self.model.SetFacing, self.model, tonumber(appearance.rotation) or 0)
    end
    if self.model.SetCamDistanceScale then
        pcall(self.model.SetCamDistanceScale, self.model, tonumber(appearance.modelScale) or 1)
    end
end

function FC:RendererStatus()
    if self.state.renderer == "SpriteHD" then
        return "HD state art  •  crossfaded reactions  •  procedural breathing"
    end

    local caps = self.state.capabilities or {}
    return (self.state.renderer or "unknown")
        .. "  •  ModelScene detected: " .. tostring(caps.modelScene)
        .. "  •  PlayerModel: " .. tostring(caps.playerModel)
end
