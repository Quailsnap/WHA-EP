//====================================================================================
//
//	wh_ep_compileAction.sqf - Sets up "put in" and "remove" earplug actions.
//
//	@ /u/Whalen207 | Whale #5963
//
//====================================================================================

//------------------------------------------------------------------------------------
//	Parameters:
//	1. _acePresent (BOOL) - Presence of ACE addon in mission. Default: false
//------------------------------------------------------------------------------------

params [["_acePresent",false]];


//------------------------------------------------------------------------------------
//	If ACE is present, setup the ACE self-interact actions.
//------------------------------------------------------------------------------------

if _acePresent then
{

//	Action definition for putting in the earplugs.
WH_EP_ACT_INSERTPLUGS = 
[
	"earplugs",	// Variable name.
	"Insert Earplugs",	// Title to be displayed.
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",	// Icon in menus.
	{ WH_EP_MANUAL = true; call wh_ep_fnc_insert; },	// Code run upon use.
	{true}	// Condition required to be useable.
] call ace_interact_menu_fnc_createAction;

//	Action definition for removing earplugs.
WH_EP_ACT_REMOVEPLUGS = 
[
	"earplugs",	// Variable name.
	"Remove Earplugs",	// Title to be displayed.
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Icon in menus.
	{ WH_EP_MANUAL = false; call wh_ep_fnc_remove; },	// Code run upon use.
	{true}	// Condition required to be useable.
] call ace_interact_menu_fnc_createAction;

//	Save code that will toggle actions.
//	CompileFinal evaluates string code expressions
wh_ep_fnc_updateAction = compileFinal
"
	if (!(player getVariable 'WH_EP_EARPLUGS_IN')) then
	{
		[player, 1,['ACE_SelfActions','ACE_Equipment','earplugs']] call ace_interact_menu_fnc_removeActionFromObject;

		if (WH_EP_EARPLUGS && {WH_EP_ACTION}) then
		{ [player, 1, ['ACE_SelfActions','ACE_Equipment'], WH_EP_ACT_INSERTPLUGS] call ace_interact_menu_fnc_addActionToObject; };
	}
	else
	{
		[player, 1,['ACE_SelfActions','ACE_Equipment','earplugs']] call ace_interact_menu_fnc_removeActionFromObject;
		[player, 1, ['ACE_SelfActions','ACE_Equipment'], WH_EP_ACT_REMOVEPLUGS] call ace_interact_menu_fnc_addActionToObject;
	};
"
}


//------------------------------------------------------------------------------------
//	Otherwise, setup vanilla addActions.
//------------------------------------------------------------------------------------

else
{
//	Save code that will toggle actions.
//	CompileFinal evaluates string code expressions
wh_ep_fnc_updateAction = compileFinal
"
	if (!(player getVariable 'WH_EP_EARPLUGS_IN')) then
	{
		if (!isNil 'WH_EP_ACT') then { player removeAction WH_EP_ACT; };
		
		if (WH_EP_EARPLUGS && {WH_EP_ACTION}) then
		{ WH_EP_ACT = player addAction [WH_EP_ACTION_IN,{ WH_EP_MANUAL = true; call wh_ep_fnc_insert; }, [], 0.5, false]; };
	}
	else
	{
		if (!isNil 'WH_EP_ACT') then { player removeAction WH_EP_ACT; };
		
		if (WH_EP_ACTION) then
		{ WH_EP_ACT = player addAction [WH_EP_ACTION_OUT, { WH_EP_MANUAL = false; call wh_ep_fnc_remove; }, [], 0.5, false]; };
	};
"
};