{pkgs, ...}:
{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;


    initContent = ''
    echo -e "\e[35m"
        .---.
      / o v o \
     ( <     > )
      '--^^--'
    EOF
    echo -e "\e[0m"
    '';

    };
    
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
  };

    programs.bat.enable = true;

    programs.eza = {
        enable = true;
        git = true;
    };

    programs.fd.enable = true;

}
