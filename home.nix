{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.davidf = ./david.nix;
            home-manager.backupFileExtension = "bak"; 
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
}
