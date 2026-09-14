{ ... }:
{
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = "1";
    "kernel.dmesg_restrict" = "1";
    "net.ipv4.conf.all.rp_filter" = "1";
    "net.ipv4.conf.default.rp_filter" = "1";
    "net.ipv4.tcp_syncookies" = "1";
    "net.ipv4.icmp_echo_ignore_broadcasts" = "1";
  };

  security.protectKernelImage = true;

  security.lockKernelModules = true;

  networking.firewall.enable = true;
}