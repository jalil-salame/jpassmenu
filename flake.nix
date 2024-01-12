{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      src = builtins.path { name = "jpassmenu"; path = ./jpassmenu; };
      jpassmenu-unwrapped = pkgs.writers.writeBashBin "jpassmenu" (builtins.readFile src);
      wrapperPath = pkgs.lib.makeBinPath [
        pkgs.fuzzel
        pkgs.ydotool
        pkgs.coreutils
        pkgs.findutils
        pkgs.getopt
        pkgs.git
        pkgs.gnugrep
        pkgs.gnupg
        pkgs.gnused
        pkgs.tree
        pkgs.which
        pkgs.openssh
        pkgs.procps
        pkgs.qrencode
      ];
      jpassmenu = jpassmenu-unwrapped.overrideAttrs (final: prev: {
        postFixup = ''
          wrapProgram $out/bin/passmenu \
            --prefix PATH : "$out/bin:${wrapperPath}"
        '';
      });
      jpassmenu-overlay = final: prev: { inherit jpassmenu; };
    in
    {
      packages = {
        inherit jpassmenu;
        default = jpassmenu;
      };
      overlays.jpassmenu = jpassmenu-overlay;
      overlays.default = jpassmenu-overlay;
        formatter = pkgs.nixpkgs-fmt;
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ jpassmenu ];
      };
    });
}
