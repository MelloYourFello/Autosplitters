state("Cult Of The Lamb"){}

startup
{
	vars.Log = (Action<object>)(output => print("[Cult of the Lamb] " + output));

	#region Helper Setup
	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
	var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
	vars.Helper = Activator.CreateInstance(type, timer, this);
	vars.Helper.LoadSceneManager = true;
	#endregion

	vars.Splits = new Dictionary<string, string>();	
	vars.SceneLevels = new Dictionary<string, int>();

	vars.Difficulties = new[] { "Easy", "Medium", "Hard", "Extra Hard" };

	#region Any% Settings
	settings.Add("Any%", true);

	settings.Add("start", true, "Sacrifice", "Any%");
	settings.Add("esc", true, "Escape", "Any%");
	settings.Add("base", true, "Base", "Any%");

	settings.Add("dw", true, "Darkwood", "Any%");
	settings.Add("lesh", true, "Leshy", "Any%");

	settings.Add("anu", true, "Anura", "Any%");
	settings.Add("heke", true, "Heket", "Any%");

	settings.Add("sc", true, "Silk Cradle", "Any%");
	settings.Add("sha", true, "Shamura", "Any%");

	settings.Add("ad", true, "Anchordeep", "Any%");
	settings.Add("kal", true, "Kallamar", "Any%");

	settings.Add("oww", true, "The One Who Waits", "Any%");
	#endregion

	#region 100% Settings
	settings.Add("100%", false);

	settings.Add("leshy", false, "Split on Leshy Killed", "100%");
	settings.Add("heket", false, "Split on Heket Killed", "100%");
	settings.Add("shamura", false, "Split on Shamura Killed", "100%");
	settings.Add("kallamar", false, "Split on Kallamar Killed", "100%");
	settings.Add("toww", false, "Split on The One Who Waits Killed", "100%");

	settings.Add("deco", false, "Split on All Decorations Collected", "100%");
	settings.Add("fleece", false, "Split on All Fleeces Collected", "100%");
	settings.Add("quests", false, "Split on All Quests Completed", "100%");
	#endregion

	vars.Helper.AlertGameTime("Cult Of The Lamb");

	vars.CompletedSplits = new List<string>();
}

init
{
    vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
    {
        var uim = mono.GetClass("UIManager", 1);
        vars.Helper["isPaused"] = uim.Make<bool>("_instance", "IsPaused");
		var DataManager = mono.GetClass("DataManager");
        vars.Helper["BossesCompleted"] = DataManager.MakeList<int>("instance", "BossesCompleted");
        vars.Helper["DeathCatBeaten"] = DataManager.Make<bool>("instance", "DeathCatBeaten");

        return true;
    });

    vars.Helper.Load();

	vars.CurrentScene = vars.Helper.Scenes.Active.Name;
}

update
{
    if (!vars.Helper.Update())
        return false; 

	current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
	vars.OldScene = vars.CurrentScene;
    vars.CurrentScene = vars.Helper.Scenes.Active.Name;
	current.IsPaused = vars.Helper["isPaused"].Current;
	vars.Log(current.Scene);
}


split
{
	 if (vars.CurrentScene == "Main Menu")
        return false;

    return (settings["oww"] && vars.OldScene != "Credits" && vars.CurrentScene == "Credits")
        || (settings["oww"] && !vars.Helper["DeathCatBeaten"].Old && vars.Helper["DeathCatBeaten"].Current)
        || (settings["lesh"] && !vars.Helper["BossesCompleted"].Old.Contains(7)  && vars.Helper["BossesCompleted"].Current.Contains(7))
        || (settings["heke"] && !vars.Helper["BossesCompleted"].Old.Contains(8)  && vars.Helper["BossesCompleted"].Current.Contains(8))
        || (settings["kal"] && !vars.Helper["BossesCompleted"].Old.Contains(9)  && vars.Helper["BossesCompleted"].Current.Contains(9))
        || (settings["sha"] && !vars.Helper["BossesCompleted"].Old.Contains(10) && vars.Helper["BossesCompleted"].Current.Contains(10));
}

start
{
	return current.Scene == "Game Biome Intro";
}

isLoading
{
	return string.IsNullOrEmpty(vars.CurrentScene) || vars.CurrentScene == "BufferScene" || current.IsPaused;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}

reset
{
	return current.Scene == "Main Menu";
}
