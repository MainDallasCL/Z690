{ config, ... }:

{
  # Prevent the in-kernel RTW88 driver from claiming the adapter.
  boot.blacklistedKernelModules = [ "rtw88_8822bu" ];

  # Install the external driver for the configured kernel.
  boot.extraModulePackages = [
    config.boot.kernelPackages.rtl88x2bu
  ];

  # Load the external driver at boot.
  boot.kernelModules = [ "88x2bu" ];
  boot.extraModprobeConfig = ''
    options 88x2bu rtw_switch_usb_mode=1
  '';

  # Just a thing for iperf3
  networking.firewall.allowedTCPPorts = [ 5201 ];
  networking.firewall.allowedUDPPorts = [ 5201 ];
}
