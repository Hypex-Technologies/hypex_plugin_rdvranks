local msgtypes = {[1] = "INFO",[2] = "FAIL",[3] = "ERROR",}
local msg = function(msg,mtype)
   print("[HYPEX] [" .. msgtypes[mtype] .. "] " .. msg)
end
HPXRP = HPXRP or {}
HPXRP.Util = HPXRP.Util or {}
RDV.RANK.LANG.LIST["eng"]["notSameRankStructure"] = "This player does not have the same rank structure as you or you cannot promote to this rank."
include("rdvranks/config.lua")
function HPXRP.Util.FindVal(tbl, val)
    for k, v in pairs(tbl) do
        if v == val then return k end
    end
    return nil
end
function HPXRP.CanCrossPromote(ply, promotee, rank)
    local PROMOTERBRNAME = HPXRP.Util.FindVal(RDV.RANK.Branches, RDV.RANK.Branches[RDV.RANK.GetPlayerRankTree(ply)])
    if not HPXRP.BranchPromos[PROMOTERBRNAME] then return false end
    if HPXRP.OfficerRequired and not RDV.RANK.GetPlayerIsOfficer(ply) then return false end
    local PROMOTEEBRNAME = HPXRP.Util.FindVal(RDV.RANK.Branches, RDV.RANK.Branches[RDV.RANK.GetPlayerRankTree(promotee)])
    if not HPXRP.BranchPromos[PROMOTERBRNAME][PROMOTEEBRNAME] then return false end
    if HPXRP.BranchPromos[PROMOTERBRNAME][PROMOTEEBRNAME] < rank then
        return false
    end
    return true
end

RDV.RANK.CanSetRank = function(self, promotee, rank)
    if not IsValid(promotee) or promotee:IsBot() then
        return false, RDV.RANK.GetLanguage("notValidPlayer")
    end

    if not rank then
        return false, RDV.RANK.GetLanguage("noRankSupplied")
    else
        rank = tonumber(rank)
    end

    if RDV.RANK.CFG.Admins[self:GetUserGroup()] then return true end

    local BRANCH = RDV.RANK.GetPlayerRankTree(promotee)
    local PROMOTER_BRANCH = RDV.RANK.GetPlayerRankTree(self)
    if not BRANCH then
        return false, RDV.RANK.GetLanguage("jobNotRegistered")
    end
    if not PROMOTER_BRANCH then
        return false, RDV.RANK.GetLanguage("promoterJobNotRegistered")
    end

    -- Check to make sure we aren't setting the promotees rank to something he already has.
    local PRE_RANK = RDV.RANK.GetPlayerRank(promotee)

    if PRE_RANK == rank then
        return false, RDV.RANK.GetLanguage("playerRankAlreadySet")
    end
    
    -- Get the players rank tree.
    if RDV.RANK.Branches[BRANCH] then
        BRANCH = RDV.RANK.Branches[BRANCH]
    end

    local RANKS = BRANCH.Ranks

    -- Check that the rank we were given is valid.
    if not RANKS[rank] then
        return false, RDV.RANK.GetLanguage("notValidRank")
    end
    if PROMOTER_BRANCH ~= BRANCH and not HPXRP.CanCrossPromote(self, promotee, rank) then
        return false, RDV.RANK.GetLanguage("notSameRankStructure")
    end

    local PROMOTER_RANKS = RDV.RANK.Branches[PROMOTER_BRANCH]

    if not PROMOTER_RANKS then
        return false, RDV.RANK.GetLanguage("promoterJobNotRegistered")
    end

    local RANK = RDV.RANK.GetPlayerRank(self)

    if PROMOTER_RANKS.Ranks[RANK] then
        RANK = PROMOTER_RANKS.Ranks[RANK]
        
        if PRE_RANK > rank then
            if not RANK.Demote or RANK.Demote > rank then
                return false, RDV.RANK.GetLanguage("unableToChange")
            end
        else
            if not RANK.Promote or RANK.Promote < rank then
                return false, RDV.RANK.GetLanguage("unableToChange")
            end
        end
    else
        return false
    end
    return true
end

msg("[RDVRANK Plugin] Loaded sv_plugin.lua", 1)