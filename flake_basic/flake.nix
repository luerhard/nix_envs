{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/7ffd9ae656aec493492b44d0ddfb28e79a1ea25d";
    flake-utils.url = "github:numtide/flake-utils";
    spacypkgs.url = "github:NixOS/nixpkgs/61684d356e41c97f80087e89659283d00fe032ab";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      spacypkgs,
      ...
    }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        spacy = import spacypkgs { inherit system; };

        system_deps = with pkgs; [
          # trying to get rid of error msgs "unable to set locale -- default to 'C'"
          glibcLocales
          python311
          R
        ];

        r_env = with pkgs.rPackages; [
          tidyverse
          jsonlite
          here
          irr
        ];

        python_env = with pkgs.python311Packages; [
          pandas
          openai
          levenshtein
          tqdm
          rpy2
        ];
      in
      {
        defaultPackage = pkgs.mkShell {
          buildInputs = [
            system_deps
            r_env
            python_env
            # spacy needs to be installed from another commit to use a version that works on darwin..
            spacy.python311Packages.spacy
          ];

          shellHook = ''
            echo "THIS RUNS?"
          '';
        };
      }
    );
}
