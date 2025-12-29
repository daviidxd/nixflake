    {pkgs,...}:
{
	imports = [./programs/ghostty/ghostty.nix
		./programs/neovim/neovim.nix];
	programs.vesktop.enable = true;
	programs.neovim.enable = true;
	programs.fastfetch.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

	home.stateVersion = "24.11"; 
}
