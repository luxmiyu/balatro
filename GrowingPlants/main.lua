SMODS.Atlas {
  key = "growingplants",
  path = "growingplants.png",
  px = 71,
  py = 95,
}

SMODS.Challenge {
  key = "plants",
  loc_txt = {
    name = 'All Growing Plants',
  },
  jokers = {
    {
      id = 'j_growingplants_mult',
    },
    {
      id = 'j_growingplants_chips',
    },
    {
      id = 'j_growingplants_lucky',
    },
    {
      id = 'j_growingplants_money',
    },
  },
}

SMODS.Joker {
  key = "mult",
  loc_txt = {
    name = 'Mult Plant',
    text = {
      "{C:mult}+6{} Mult per {C:green}Growth{}",
      "{C:green}+2{} Growth per {C:gold}Ace{} or {C:gold}face{} card scored",
      "{C:green}-1{} Growth per {C:gold}2{}-{C:gold}10{} card scored",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { growth = 0 } },
  rarity = 1,
  cost = 4,
  atlas = "growingplants",
  pos = {
    x = 1,
    y = 0,
  },
  loc_vars = function(self, infoqueue, card)
    return { vars = { card.ability.extra.growth } }
  end,
  calculate = function(self, card, context)
    if self.debuff then return nil end
    if context.before and not context.blueprint then
      local growth_modifier = 0

      for i, other_card in ipairs(scoring_hand) do
        local id = other_card:get_id()

        if id == 11 or id == 12 or id == 13 or id == 14 then
          growth_modifier = growth_modifier + 2
        else
          growth_modifier = growth_modifier - 1
        end
      end

      card.ability.extra.growth = card.ability.extra.growth + growth_modifier
      if card.ability.extra.growth < 0 then
        card.ability.extra.growth = 0
      end

      if growth_modifier == 0 then
        return {
          message = 'Unchanged',
          colour = G.C.INACTIVE,
        }
      elseif growth_modifier > 0 then
        return {
          message = '+' .. growth_modifier .. ' Growth',
          colour = G.C.GREEN,
        }
      elseif growth_modifier < 0 then
        return {
          message = growth_modifier .. ' Growth',
          colour = G.C.RED,
        }
      end
    end
    if context.joker_main then
      return {
        mult = card.ability.extra.growth * 6,
      }
    end
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
}

SMODS.Joker {
  key = "chips",
  loc_txt = {
    name = 'Chips Plant',
    text = {
      "{C:chips}+60{} Chips per {C:green}Growth{}",
      "{C:green}+2{} Growth per {C:gold}Ace{} or {C:gold}face{} card scored",
      "{C:green}-1{} Growth per {C:gold}2{}-{C:gold}10{} card scored",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { growth = 0 } },
  rarity = 1,
  cost = 4,
  atlas = "growingplants",
  pos = {
    x = 2,
    y = 0,
  },
  loc_vars = function(self, infoqueue, card)
    return { vars = { card.ability.extra.growth } }
  end,
  calculate = function(self, card, context)
    if self.debuff then return nil end
    if context.before and not context.blueprint then
      local growth_modifier = 0

      for i, other_card in ipairs(scoring_hand) do
        local id = other_card:get_id()
        print('id', id)

        if id == 11 or id == 12 or id == 13 or id == 14 then
          growth_modifier = growth_modifier + 2
        else
          growth_modifier = growth_modifier - 1
        end
      end

      card.ability.extra.growth = card.ability.extra.growth + growth_modifier
      if card.ability.extra.growth < 0 then
        card.ability.extra.growth = 0
      end

      if growth_modifier == 0 then
        return {
          message = 'Unchanged',
          colour = G.C.INACTIVE,
        }
      elseif growth_modifier > 0 then
        return {
          message = '+' .. growth_modifier .. ' Growth',
          colour = G.C.GREEN,
        }
      elseif growth_modifier < 0 then
        return {
          message = growth_modifier .. ' Growth',
          colour = G.C.RED,
        }
      end
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.growth * 60,
      }
    end
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
}

SMODS.Joker {
  key = "lucky",
  loc_txt = {
    name = 'Lucky Plant',
    text = {
      "{C:green}1 in 3{} chance to get {C:mult}+#2#{} Mult{}/{C:chips}+#3#{} Chips",
      "{C:mult}+2{} Mult per {C:gold}Ace{} or {C:gold}King{} scored",
      "{C:chips}+10{} Chips per {C:gold}Queen{} or {C:gold}Jack{} scored",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { mult = 2, chips = 10, growth = 0 } },
  rarity = 1,
  cost = 4,
  atlas = "growingplants",
  pos = {
    x = 0,
    y = 0,
  },
  loc_vars = function(self, infoqueue, card)
    return { vars = { card.ability.extra.growth, card.ability.extra.mult, card.ability.extra.chips } }
  end,
  calculate = function(self, card, context)
    if self.debuff then return nil end
    if context.before and not context.blueprint then
      local mult_modifier = 0
      local chips_modifier = 0

      for i, other_card in ipairs(scoring_hand) do
        local id = other_card:get_id()
        if id == 14 or id == 13 then
          mult_modifier = mult_modifier + 2
        elseif id == 11 or id == 12 then
          chips_modifier = chips_modifier + 10
        end
      end

      card.ability.extra.mult = card.ability.extra.mult + mult_modifier
      card.ability.extra.chips = card.ability.extra.chips + chips_modifier

      if mult_modifier > 0 or chips_modifier > 0 then
        card.ability.extra.growth = card.ability.extra.growth + 1
      end

      if mult_modifier == 0 and chips_modifier == 0 then
        return {
          message = 'Unchanged',
          colour = G.C.INACTIVE,
        }
      elseif mult_modifier == 0 then
        return {
          message = '+' .. chips_modifier .. ' Chips',
          colour = G.C.CHIPS,
        }
      elseif chips_modifier == 0 then
        return {
          message = '+' .. mult_modifier .. ' Mult',
          colour = G.C.MULT,
        }
      else
        return {
          message = '+' .. mult_modifier .. ' Mult / +' .. chips_modifier .. ' Chips',
          colour = G.C.GREEN,
        }
      end
    end
    if context.joker_main then
      local luck_pass = math.random(3) == 1

      if luck_pass then
        return {
          mult = card.ability.extra.mult,
          chips = card.ability.extra.chips,
        }
      else
        return {
          message = 'Unlucky',
          colour = G.C.PURPLE
        }
      end
    end
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
}

SMODS.Joker {
  key = "money",
  loc_txt = {
    name = 'Money Plant',
    text = {
      "Earn {C:gold}$#2#{} at end of round",
      "{C:gold}+$1{} when playing a hand",
      "{C:gold}+$5{} if an {C:gold}Ace{} is scored",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { dollars = 0, growth = 0 } },
  rarity = 1,
  cost = 4,
  atlas = "growingplants",
  pos = {
    x = 3,
    y = 0,
  },
  loc_vars = function(self, infoqueue, card)
    return { vars = { card.ability.extra.growth, card.ability.extra.dollars } }
  end,
  calculate = function(self, card, context)
    if self.debuff then return nil end
    if context.before and not context.blueprint then
      local found_ace = false
      local dollars_modifier = 1

      for i, other_card in ipairs(scoring_hand) do
        if other_card:get_id() == 14 then
          found_ace = true
        end
      end

      card.ability.extra.growth = card.ability.extra.growth + 1

      if found_ace then
        dollars_modifier = dollars_modifier + 5
      end

      card.ability.extra.dollars = card.ability.extra.dollars + dollars_modifier

      if dollars_modifier == 0 then
        return {
          message = 'Unchanged',
          colour = G.C.INACTIVE,
        }
      else
        return {
          message = '+$' .. dollars_modifier,
          colour = G.C.GOLD,
        }
      end
    end
    if context.end_of_round and context.cardarea == G.jokers then
      return {
        dollars = card.ability.extra.dollars,
      }
    end
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
}
