{ cfg, ... }:

{

  addKeysToAgent = "yes";
  controlMaster = "auto";
  controlPersist = "yes";
  controlPath = "${cfg.home}/.ssh/sockets/%p-%h-%r";
  forwardAgent = true;

  matchBlocks = {
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
      host = "stellar* tigressdata*";
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

    stellar-amd = {
      host = "stellar-amd.princeton.edu stellar-amd";
      hostname = "stellar-amd.princeton.edu";
    };

    non-pu = {
      host = "frontera ginsburg insomnia";
      forwardAgent = false;
      forwardX11 = false;
    };

    frontera = {
      host = "frontera";
      hostname = "frontera.tacc.utexas.edu";
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

    perlmutter = {
      host = "perlmutter";
      hostname = "perlmutter.nersc.gov";
      user = "hayk";
    };

  };

}
