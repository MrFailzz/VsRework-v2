Msg("c14m1_junkyard script\n");

// Fuel button to start junkyard event
local fuel_button = Entities.FindByName( null, "fuel_button" );
local drop_button = Entities.FindByName( null, "fuel_button" );

// Function to replace panic event inputs with new scripts
function Junkyard_Rework()
{
    if ( fuel_button )
    {
        EntityOutputs.RemoveOutput( fuel_button, "OnPressed", "director", "ForcePanicEvent", "" );
        EntityOutputs.AddOutput( fuel_button, "OnPressed", "director", "BeginScript", "c14_junkyard_crescendo", 2, -1 );
        EntityOutputs.AddOutput( fuel_button, "OnPressed", "director", "BeginScript", "c14_junkyard_cooldown", 13.5, -1 );
    }
    if ( drop_button )
        EntityOutputs.RemoveOutput( drop_button, "OnPressed", "director", "RunScriptFile", "c14m1_mob" );
}

// Run function
Junkyard_Rework();