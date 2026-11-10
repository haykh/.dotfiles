{
  config,
  lib,
  cfg,
  ...
}:

let
  this = config.my.programs.ssh;
in
{

  options.my.programs.ssh.enable = lib.mkEnableOption "ssh client config";

  config = lib.mkIf this.enable {

    # controlPath below lives here; if it's missing, ssh exits right after auth
    home.activation.sshSocketsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run install -d -m 700 "${cfg.home}/.ssh/sockets"
    '';

    programs.ssh = {
      enable = true;

      enableDefaultConfig = false;
      settings = {
        "*" = {
          addKeysToAgent = "yes";
          forwardAgent = true;
          controlPersist = "yes";
          controlMaster = "auto";
          controlPath = "${cfg.home}/.ssh/sockets/%p-%h-%r";
          serverAliveInterval = 300;
        };

        pu-global = {
          host = "tigress* stellar*";
          user = "hakobyan";
        };

        pu-gateway = {
          host = "tigressgateway.princeton.edu tigressgateway";
          hostname = "tigressgateway.princeton.edu";
          serverAliveInterval = 300;
        };

        pu-main = {
          host = "stellar* tigressdata* della*";
          proxyJump = "tigressgateway.princeton.edu";
          proxyCommand = "ssh tigressgateway -W %h:%p";
          forwardX11 = true;
          forwardX11Trusted = true;
        };

        stellar-vis2 = {
          host = "stellar-vis2.princeton.edu stellar-vis2";
          hostname = "stellar-vis2.princeton.edu";
        };

        tigressdata = {
          host = "tigressdata.princeton.edu tigressdata";
          hostname = "tigressdata2.princeton.edu";
        };

        stellar = {
          host = "stellar.princeton.edu stellar";
          hostname = "stellar.princeton.edu";
        };

        della = {
          host = "della.princeton.edu della";
          hostname = "della.princeton.edu";
        };

        della-gpu = {
          host = "della-gpu.princeton.edu della-gpu";
          hostname = "della-gpu.princeton.edu";
        };

        della-vis2 = {
          host = "della-vis2.princeton.edu della-vis2";
          hostname = "della-vis2.princeton.edu";
        };

        stellar-amd = {
          host = "stellar-amd.princeton.edu stellar-amd";
          hostname = "stellar-amd.princeton.edu";
        };

        non-pu = {
          host = "vista frontera ginsburg insomnia";
          forwardAgent = false;
          forwardX11 = false;
        };

        frontera = {
          host = "frontera";
          hostname = "frontera.tacc.utexas.edu";
          user = "haykh";
        };

        vista = {
          host = "vista";
          hostname = "vista.tacc.utexas.edu";
          user = "haykh";
        };

        ginsburg = {
          host = "ginsburg";
          hostname = "ginsburg.rcs.columbia.edu";
          user = "hh2941";
        };

        insomnia = {
          host = "insomnia";
          hostname = "insomnia.rcs.columbia.edu";
          user = "hh2941";
        };

        flatiron = {
          host = "flatiron";
          hostname = "gateway.flatironinstitute.org";
          user = "hhakobyan";
          port = 61022;
          forwardX11 = true;
          forwardX11Trusted = true;
        };

        # Flatiron nodes via the gateway: `ssh worker5244`, or Remote-SSH -> worker5244
        # (attr name is the Host pattern; a `host = ...` key would start a new block)
        "worker* rustyamd* rusty" = {
          user = "hhakobyan";
          proxyJump = "flatiron";
        };

        # whichever node my first running Slurm job is on
        rusty-job = {
          user = "hhakobyan";
          proxyCommand = "ssh flatiron -W \"$(ssh rusty 'scontrol show hostnames $(squeue --me -h -t R -o %%N | head -1) | head -1')\":22";
          hostKeyAlias = "rusty"; # all Flatiron nodes share rusty's host key, so verify against it
          controlMaster = "no"; # don't reuse a master pointing at a previous job's node
        };

        perlmutter = {
          host = "perlmutter";
          hostname = "perlmutter.nersc.gov";
          user = "hayk";
        };

      };
    };

  };

}
