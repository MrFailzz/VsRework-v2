Msg("VERSUS++ Extras\n");


// Reduce bonus when medkits used
function OnGameEvent_heal_success(params)
{
	Convars.SetValue("vs_survival_bonus", survivorBonus - 2);
	survivorBonus -= 2;

	// Do not let survival bonus go below 0
	if (Convars.GetFloat("vs_survival_bonus") < 0)
		Convars.SetValue("vs_survival_bonus", 0);
}

// Reduce bonus when defibs used
function OnGameEvent_defibrillator_used(params)
{
	Convars.SetValue("vs_survival_bonus", survivorBonus - 2);
	survivorBonus -= 2;
	
	// Do not let survival bonus go below 0
	if (Convars.GetFloat("vs_survival_bonus") < 0)
		Convars.SetValue("vs_survival_bonus", 0);
}

// CS Molotov
// Precache detonate snd
if (!IsSoundPrecached("weapons/molotov/molotov_detonate_swt_01.wav"))
	PrecacheSound("weapons/molotov/molotov_detonate_swt_01.wav");

function OnGameEvent_molotov_thrown(params)
{
	local player = GetPlayerFromUserID(params["userid"]);

	if (player.ValidateScriptScope())
	{
		local player_entityscript = player.GetScriptScope();
		player_entityscript["TickCount"] <- 0;
        player_entityscript["MolotovKill"] <- function()
		{
			if (player_entityscript["TickCount"] == 10)
			{
                local molotov_projectile = null;
                if ((molotov_projectile = Entities.FindByClassname(molotov_projectile, "molotov_projectile")) != null)
                {
                    //Explosion VFX
                    local molotov_origin = molotov_projectile.GetOrigin();
                    local explEnt = SpawnEntityFromTable("info_particle_system",
                    {
                        targetname = "explEnt",
                        origin = molotov_origin,
                        start_active = 1,
                        effect_name = "fire_large_01"
                    });

                    EmitSoundOn("weapons/molotov/molotov_detonate_swt_01.wav", molotov_projectile);
                    molotov_projectile.Kill();
                }
			}
            else if (player_entityscript["TickCount"] >= 11)
            {
                EntFire("explEnt", "Kill");
                return
            }
			player_entityscript["TickCount"]++;
			return
		}
        AddThinkToEnt(player, "MolotovKill");
	}
}


// Spawns
function OnGameEvent_round_start(params)
{
	local weapon_awp = null;
	local weapon_launcher = null;

	// Remove AWP spawns
	while(weapon_awp = Entities.FindByModel(weapon_awp, "models/w_models/weapons/w_sniper_awp.mdl"))
		weapon_awp.Kill();                

	// Replace grenade launcher with AWP
	while(weapon_launcher = Entities.FindByModel(weapon_launcher, "models/w_models/weapons/w_grenade_launcher.mdl"))
    {
		local weapon_originX = weapon_launcher.GetOrigin().x;
        local weapon_originY = weapon_launcher.GetOrigin().y;
	    local weapon_originZ = weapon_launcher.GetOrigin().z;
	    local weapon_angleX = weapon_launcher.GetAngles().x;
	    local weapon_angleY = weapon_launcher.GetAngles().y;
	    local weaponName = "AWP_spawn";
	    local weaponSpawn = SpawnEntityFromTable("weapon_sniper_awp",
	    {
		    targetname = weaponName,
		    origin = Vector(weapon_originX, weapon_originY, weapon_originZ),
		    angles = Vector(weapon_angleX, weapon_angleY, 0)
		    solid = 0,
		    disableshadows = 1,
            ammo = 20,
	    });

		// Remove grenade launcher spawns
		weapon_launcher.Kill();                
    }
}

Msg("VERSUS++ Scoring\n");

////////////////////////
// Globals
////////////////////////
ScoreTable <-
{
	campaignScoreA = 0,
	campaignScoreB = 0,
}

medkitsUsed <- 0;
survivorBonus <- 200;
survivorBonusA <- 0;
survivorBonusB <- 0;

////////////////////////
// CVAR tweaks 
////////////////////////
Convars.SetValue("vs_survival_bonus", 200)
Convars.SetValue("vs_defib_penalty", 0)

////////////////////////
// SCORING
////////////////////////
function OnGameEvent_player_first_spawn(params)
{
	RestoreTable("ScoreTable", ScoreTable);

	//NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000", ScoreTable["campaignScoreA"]);
	//NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001", ScoreTable["campaignScoreB"]);

}
function OnGameEvent_round_end(params)
{
	local infectedDmgA = (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterDamage.000"));
	local infectedDmgB = (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterDamage.001"));
	local dmgDiff = (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusDistancePerSurvivor"));
	printl(dmgDiff);

		if (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInSecondHalfOfRound") == 0)
		{
			if (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bAreTeamsFlipped") == 0)
			{
				// Get chapter and campaign scores (these are separate)
				local chapterScore = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.000");
				local campaignScore = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000");

				if (survivorBonusA > 0)
				{
					NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusDefibsUsed.000", 0);
				}
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusSurvivalMultiplier.000", 1);									// How many survivors are "alive"
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iSurvivorScore.000", survivorBonusA);								// Number of bonus points per survivor
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.000", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.000") - 800) + survivorBonusA);			// Total scores seem to ignore changing the SurvivalMultipler, so assume it gave 4x
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000") - 800) + survivorBonusA);

				//ScoreTable["campaignScoreA"] = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000");
				SaveTable("ScoreTable", ScoreTable);
			}
			else
			{
				local chapterScore = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.001");
				local campaignScore = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001");
				
				if (survivorBonusA > 0)
				{
					NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusDefibsUsed.001", 0);
				}
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusSurvivalMultiplier.001", 1);
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iSurvivorScore.001", survivorBonusB);
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.001", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.001") - 800) + survivorBonusB);
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001") - 800) + survivorBonusB);
				
				//ScoreTable["campaignScoreB"] = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001");
				SaveTable("ScoreTable", ScoreTable);
			}
		}
		else
		{
				// Get chapter and campaign scores (these are separate)
				local chapterScore0 = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.000");
				local campaignScore0 = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000");
				local chapterScore1 = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.001");
				local campaignScore1 = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001");

				if (survivorBonusA > 0)
				{
					NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusDefibsUsed.000", 0);
				}
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusSurvivalMultiplier.000", 1);									// How many survivors are "alive"
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iSurvivorScore.000", survivorBonusA);								// Number of bonus points per survivor
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.000", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.000") - 800) + survivorBonusA);			// Total scores seem to ignore changing the SurvivalMultipler, so assume it gave 4x
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000") - 800) + survivorBonusA);

				//ScoreTable["campaignScoreA"] = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.000");
				
				if (survivorBonusA > 0)
				{
					NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusDefibsUsed.001", 0);
				}
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iVersusSurvivalMultiplier.001", 1);
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iSurvivorScore.001", survivorBonusB);
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.001", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iChapterScore.001") - 800) + survivorBonusB);
				NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001", (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001") - 800) + survivorBonusB);
				
				//ScoreTable["campaignScoreB"] = NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_iCampaignScore.001");
				SaveTable("ScoreTable", ScoreTable);		
		}


	if (dmgDiff > 50 || dmgDiff < -50 )
		Convars.SetValue("vs_tiebreak_bonus", 25);
	else if (dmgDiff > 100 || dmgDiff < -100 )
		Convars.SetValue("vs_tiebreak_bonus", 30);
	else if (dmgDiff > 150 || dmgDiff < -150 )
		Convars.SetValue("vs_tiebreak_bonus", 35);
	else if (dmgDiff > 200 || dmgDiff < -200 )
		Convars.SetValue("vs_tiebreak_bonus", 40);
	else if (dmgDiff > 250 || dmgDiff < -250 )
		Convars.SetValue("vs_tiebreak_bonus", 45);
	else if (dmgDiff > 300 || dmgDiff < -300 )
		Convars.SetValue("vs_tiebreak_bonus", 50);
}

// Reduce bonus when medkits used
function OnGameEvent_heal_success(params)
{
	if (NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bAreTeamsFlipped") == 0)
	{
		Convars.SetValue("vs_defib_penalty", survivorBonusA - 5);
		survivorBonusA += 5;
	}
	else
	{
		Convars.SetValue("vs_defib_penalty", survivorBonusB - 5);
		survivorBonusB += 5;
	}

	// Do not let survival bonus go below 0
	if (Convars.GetFloat("vs_survival_bonus") > 200)
		Convars.SetValue("vs_survival_bonus", 200);
}

// Tiebreaker tweaks
/*
if (Director.GetMapNumber() == 0)
	Convars.SetValue("vs_tiebreak_bonus", 20);

else if (Director.GetMapNumber() == 1)
	Convars.SetValue("vs_tiebreak_bonus", 25);

else if (Director.GetMapNumber() == 2)
	Convars.SetValue("vs_tiebreak_bonus", 30);

else if (Director.GetMapNumber() == 3)
	Convars.SetValue("vs_tiebreak_bonus", 35);
	
else if (Director.GetMapNumber() == 4)
	Convars.SetValue("vs_tiebreak_bonus", 40);
*/
