{ myvars, ... }:
{
  networking.networkmanager.enable = true;
  networking.hostName = myvars.hostname;

  time.timeZone = myvars.timezone;

  i18n.defaultLocale = myvars.defaultLocale;
  console.keyMap = myvars.consoleKeyMap;
}