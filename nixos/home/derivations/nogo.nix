{
  pkgs ? import <nixpkgs> { },
}:

pkgs.buildGoModule rec {

  pname = "nogo";
  version = "1.6.0";
  author = "haykh";

  src = pkgs.fetchFromGitHub {
    owner = "${author}";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-ItkpkZIhA9a6QgxFVSNN9YGQoML6NT4uoiu9aLsZI9o=";
  };

  vendorHash = "sha256-9aIcu1BImY7+IdNEVb3acgdM3kBamKrWVOyUnaSZXZk=";

  meta = {
    description = "go-based tool to do awesome stuff with notion";
    homepage = "https://github.com/${author}/nogo";
    license = pkgs.lib.licenses.bsd3;
    maintainers = [ author ];
  };

}
