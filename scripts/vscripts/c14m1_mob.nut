Msg("Junkyard mob spawn.\n")
JunkyardCommonLimit <- 25;
JunkyardMobSize <- 20;

DirectorScript.MapScript.LocalScript.DirectorOptions.CommonLimit <- JunkyardCommonLimit;
DirectorScript.MapScript.LocalScript.DirectorOptions.MobSize <- JunkyardMobSize;
ZSpawn({ type = 10, pos = Vector(0,0,0) });

function c14m1_junkyard_end()
{
    Msg("Junkyard end.\n")
    delete DirectorScript.MapScript.LocalScript.DirectorOptions.CommonLimit;
    delete DirectorScript.MapScript.LocalScript.DirectorOptions.MobSize;
}