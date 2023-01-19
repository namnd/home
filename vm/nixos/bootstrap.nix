{ pkgs, ... }: 
{
  users.users.username = {
    isNormalUser = true;
    home = "/home/username";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8HjC+29D66x0zOMMwrleHKHN4bD5hBmIqKzc3FALQo" ];
  };

  networking.hostName = "vm_hostname";
  time.timeZone = "Australia/Brisbane";
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    git
    gnumake
    vim
    xclip
    gnupg
  ];

  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "tty";
    enableSSHSupport = true;
  };


}
