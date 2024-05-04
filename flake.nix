{
  # A helpful description of your flake
  description = "A fork of passmenu that uses fuzzel";

  # Flake inputs
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      # Helpers for producing system-specific outputs
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f (nixpkgs.legacyPackages.${system}));

      # Package
      src = builtins.path { name = "jpassmenu"; path = ./jpassmenu; };
      package = pkgs: pkgs.writers.writeBashBin "jpassmenu" (builtins.readFile src);
    in
    {
      packages = forEachSupportedSystem (pkgs: let jpassmenu = package pkgs; in { inherit jpassmenu; default = jpassmenu; });

      overlays.default = final: prev: { jpassmenu = package prev; };

      formatter = forEachSupportedSystem (pkgs: pkgs.nixpkgs-fmt);
    };
}
