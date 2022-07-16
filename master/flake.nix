{
  description = ''Redis connection pool'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-redpool-master.flake = false;
  inputs.src-redpool-master.ref   = "refs/heads/master";
  inputs.src-redpool-master.owner = "zedeus";
  inputs.src-redpool-master.repo  = "redpool";
  inputs.src-redpool-master.type  = "github";
  
  inputs."github.com/zedeus/redis".owner = "nim-nix-pkgs";
  inputs."github.com/zedeus/redis".ref   = "master";
  inputs."github.com/zedeus/redis".repo  = "github.com/zedeus/redis";
  inputs."github.com/zedeus/redis".dir   = "";
  inputs."github.com/zedeus/redis".type  = "github";
  inputs."github.com/zedeus/redis".inputs.nixpkgs.follows = "nixpkgs";
  inputs."github.com/zedeus/redis".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-redpool-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-redpool-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}