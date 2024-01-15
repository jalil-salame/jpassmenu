{
  # A helpful description of your flake
  description = "A fork of passmenu that uses fuzzel";

  # Flake inputs
  inputs.flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*.tar.gz";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = { self, nixpkgs, flake-schemas }:
    let
      # Helpers for producing system-specific outputs
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f (import nixpkgs { inherit system; }));

    in
    {
      # Schemas tell Nix about the structure of your flake's outputs
      inherit (flake-schemas) schemas;

      packages = forEachSupportedSystem (pkgs:
        let
          src = builtins.path { name = "jpassmenu"; path = ./jpassmenu; };
          jpassmenu = pkgs.writers.writeBashBin "jpassmenu" (builtins.readFile src);
        in
        {
          inherit jpassmenu; default = jpassmenu;
        }
      );

      formatter = forEachSupportedSystem (pkgs: pkgs.nixpkgs-fmt);
    };
}
