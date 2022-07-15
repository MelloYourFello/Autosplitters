// This asl was made by MelloYourFello
// feel free to DM me on discord: MelloYourFello#6030
// i think this'll be my final contribution to the CC64 community.

state("CC64EMULATOR") {}

startup
{
    vars.Log = (Action<object>)(output => print("[CC64EMULATOR] " + output));

    #region Helper Setup
    var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
    var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
    vars.Helper = Activator.CreateInstance(type, timer, settings, this);
    vars.Helper.LoadSceneManager = true;
    #endregion

    settings.Add("Any%");
    settings.CurrentDefaultParent = "Any%";
    settings.Add("Work");
    settings.Add("Toyland");
    settings.Add("Grounds 2");
    settings.Add("Work 2");
    settings.Add("Forest");
    settings.Add("Grounds 3");
    settings.Add("Home");

    vars.Helper.AlertGameTime("Catastrophe Crow!");
}

init
{
    vars.Helper.Load();
}


update
{
    if (!vars.Helper.Update())
        return false;

    current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
    // vars.Log(current.Scene);
}

start
{
    return current.Scene == "GROUNDS_V1";
}

split
{
    if (settings["Work"] && current.Scene == "HUB_V3" && old.Scene == "GROUNDS_V1"){
        return true;
    }
    
    if (settings["Toyland"] && current.Scene == "TOYS_V6" && old.Scene == "HUB_V3"){
        return true;
    }

    if (settings["Grounds 2"] && current.Scene == "GROUNDS_334007424" && old.Scene == "homeglitch"){
        return true;
    }

    if (settings["Work 2"] && current.Scene == "HUB_V5_334007424" && old.Scene == "GROUNDS_334007424"){
        return true;
    }

    if (settings["Forest"] && current.Scene == "FOREST_V4" && old.Scene == "HUB_V5_334007424"){
        return true;
    }

    if (settings["Grounds 3"] && current.Scene == "GROUNDS_334007424un" && old.Scene == "homeglitch2"){
        return true;
    }

    if (settings["Home"] && current.Scene == "HOME_V2" && old.Scene == "GROUNDS_334007424un"){
        return true;
    }

    if (current.Scene == "HOME_V5" && old.Scene == "HOME_V2"){
        return true;
    }
}

reset
{
    return current.Scene == "INTRO";
}

exit
{
    vars.Helper.Dispose(); 
}

shutdown
{
    vars.Helper.Dispose();
} 
