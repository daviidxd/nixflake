{
    programs.ghostty.enable = true;

    programs.ghostty.settings = {
        theme = "Embers Dark";
        command = "zsh";
        font-family = "Meslo";
      
        # Keybind Config
        keybind = [
        "ctrl+r=reload_config"
        "ctrl+n=new_tab"
        "ctrl+a=new_split:left"
        "ctrl+d=new_split:right"
        "ctrl+w=close_tab:this"
        
        "ctrl+,=resize_split:left,10"
        "ctrl+.=resize_split:right,10"

        # Tab Navigation
        "alt+1=previous_tab"
        "alt+2=next_tab"
        ];
    };
}
