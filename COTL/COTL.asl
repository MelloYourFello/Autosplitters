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

	vars.canSplit = false;

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

        return true;
    });

    vars.Helper.Load();
}

update
{
    if (!vars.Helper.Update())
        return false; 

	current.IsPaused = vars.Helper["isPaused"].Current;
}


split
{

}

start
{
	
}

isLoading
{
	return current.IsPaused;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
