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

	settings.Add("Any%");

	settings.Add("start", true, "Sacrifice", "Any%");
	settings.Add("esc", true, "Escape", "Any%");
	settings.Add("base", true, "Base", "Any%");

	settings.Add("dw", true, "Darkwood", "Any%");
	settings.Add("anu", true, "Anura", "Any%");
	settings.Add("sc", true, "Silk Cradle", "Any%");
	settings.Add("ad", true, "Anchordeep", "Any%");

	settings.Add("100%");

	vars.Helper.AlertGameTime("Cult Of The Lamb");

	vars.CompletedSplits = new List<string>();
}

init
{
    vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
    {
        var li = mono.GetClass("LoadingIcon");

        return true;
    });

    vars.Helper.Load();
}

onStart
{

}

update
{
    if (!vars.Helper.Update())
        return false; 

}


split
{

}

start
{
	
}

isLoading
{
	
}
