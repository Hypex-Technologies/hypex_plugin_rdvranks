--[[
    Config Explainer:
    ["PROMOTER BRANCH NAME"] = {
        ["PROMOTEE BRANCH NAME"] = MAX PROMOTE RANK NUMBER,
    }

    Config Example:
    ["Jedi Command"] = {
        ["Clone Troopers"] = 5,
    }
]]
HPXRP.BranchPromos = {
    ["High Command"] = {
        ["Clone Troopers"] = 2,
        ["501st Legion"] = 2,
        ["212th Attack"] = 14,
    },
    ["Navy"] = {
        ["Clone Troopers"] = 2,
    },
}

--[[
    On the Branch configuration you need to set the
    rank "Officer" value to true if this is turned on.
    Otherwise it will block the promotion.
]]
HPXRP.OfficerRequired = true