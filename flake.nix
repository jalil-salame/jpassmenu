{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      src = builtins.path { name = "jpassmenu"; path = ./jpassmenu; };
      jpassmenu = pkgs.writers.writeDashBin "jpassmenu" (builtins.readFile src);
    in
    {
      packages = {
        inherit jpassmenu;
        default = jpassmenu;
      };
      formatter = pkgs.nixpkgs-fmt;
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ jpassmenu ];
      };
    });
}
