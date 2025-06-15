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
      "{C:mult}+2{} Mult per {C:green}Growth{}",
      "{C:green}+2{} Growth per {C:gold}Ace{} scored",
      "{C:green}+1{} Growth per {C:gold}face{} card scored",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { growth = 0 } },
  rarity = 1,
  cost = 6,
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
    if context.before then
      local growth_modifier = 0

      for i, other_card in ipairs(context.scoring_hand) do
        if other_card:get_id() == 14 then
          growth_modifier = growth_modifier + 2
        elseif other_card:is_face() then
          growth_modifier = growth_modifier + 1
        end
      end

      card.ability.extra.growth = card.ability.extra.growth + growth_modifier

      if growth_modifier == 0 then
        return nil
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
        mult = card.ability.extra.growth * 2,
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
      "{C:chips}+20{} Chips per {C:green}Growth{}",
      "{C:green}+2{} Growth per {C:gold}Ace{} scored",
      "{C:green}+1{} Growth per {C:gold}face{} card scored",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { growth = 0 } },
  rarity = 1,
  cost = 6,
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
    if context.before then
      local growth_modifier = 0

      for i, other_card in ipairs(context.scoring_hand) do
        if other_card:get_id() == 14 then
          growth_modifier = growth_modifier + 2
        elseif other_card:is_face() then
          growth_modifier = growth_modifier + 1
        end
      end

      card.ability.extra.growth = card.ability.extra.growth + growth_modifier

      if growth_modifier == 0 then
        return nil
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
        chips = card.ability.extra.growth * 20,
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
      "{C:green}#4# in 100{} chance to {C:chips}+#3#{} Chips/{C:mult}+#2#{} Mult{}",
      "{X:chips,C:white}X2{} Chips if an {C:gold}Ace{} or {C:gold}King{} is scored",
      "{X:mult,C:white}X2{} Mult if a {C:gold}Queen{} or {C:gold}Jack{} is scored",
      "{C:green}+1{} Chance when playing a {C:legendary}hand{}",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { mult = 1, chips = 1, chance = 1, growth = 0 } },
  rarity = 3,
  cost = 6,
  atlas = "growingplants",
  pos = {
    x = 0,
    y = 0,
  },
  loc_vars = function(self, infoqueue, card)
    return {
      vars = {
        card.ability.extra.growth,
        card.ability.extra.mult,
        card.ability.extra.chips,
        card.ability.extra.chance
      }
    }
  end,
  calculate = function(self, card, context)
    if self.debuff then return nil end

    if context.before then
      local changed_mult = false
      local changed_chips = false
      local changed_chance = false

      card.ability.extra.growth = card.ability.extra.growth + 1
      card.ability.extra.chance = card.ability.extra.chance + 1

      if card.ability.extra.chance > 100 then
        card.ability.extra.chance = 100
      end

      for i, other_card in ipairs(context.scoring_hand) do
        if other_card:get_id() == 14 or other_card:get_id() == 13 then
          changed_chips = true
        elseif other_card:get_id() == 12 or other_card:get_id() == 11 then
          changed_mult = true
        end
      end

      if changed_chips then
        card.ability.extra.growth = card.ability.extra.growth + 1
        card.ability.extra.chips = card.ability.extra.chips * 2
      end

      if changed_mult then
        card.ability.extra.growth = card.ability.extra.growth + 1
        card.ability.extra.mult = card.ability.extra.mult * 2
      end

      if not changed_mult and not changed_chips then
        return {
          message = '+1 Chance',
          colour = G.C.GREEN,
        }
      elseif not changed_mult then
        return {
          message = card.ability.extra.chips .. ' Chips',
          colour = G.C.CHIPS,
        }
      elseif not changed_chips then
        return {
          message = card.ability.extra.mult .. ' Mult',
          colour = G.C.MULT,
        }
      else
        return {
          message = card.ability.extra.chips .. ' Chips / ' .. card.ability.extra.mult .. ' Mult',
          colour = G.C.GREEN,
        }
      end
    end

    if context.joker_main then
      local luck_pass = math.random(100) <= card.ability.extra.chance

      if luck_pass then
        return {
          mult = card.ability.extra.mult,
          chips = card.ability.extra.chips,
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
      "{C:gold}+$1{} when playing a {C:legendary}hand{}",
      "{C:gold}+$4{} per {C:gold}Ace{} scored",
      "{C:inactive}(Grown {C:green}#1#{C:inactive} times)",
    }
  },
  config = { extra = { dollars = 0, growth = 0 } },
  rarity = 2,
  cost = 6,
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
    if context.before then
      local growth_modifier = 1
      local dollars_modifier = 1

      for i, other_card in ipairs(context.scoring_hand) do
        if other_card:get_id() == 14 then
          dollars_modifier = dollars_modifier + 4
          growth_modifier = growth_modifier + 1
        end
      end

      card.ability.extra.growth = card.ability.extra.growth + growth_modifier
      card.ability.extra.dollars = card.ability.extra.dollars + dollars_modifier

      if dollars_modifier == 0 then
        return nil
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
