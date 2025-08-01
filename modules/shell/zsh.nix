#
#  Shell
#

{ pkgs, vars, my_dotfiles, inputs, lib, ... }:

let
  my_p10k_config = builtins.readFile (builtins.toPath "${my_dotfiles}/files/p10k/.p10k.zsh");
  my_zsh_config = builtins.readFile (builtins.toPath "${my_dotfiles}/files/zsh/.config/zsh/aliasrc");
  zsh_init = builtins.readFile ./.zshrc-init;
in
{
  users.users.${vars.user} = with pkgs; {
    shell = zsh;
  };
  programs.zsh.enable = true;

  home-manager.users.${vars.user} = {

    home.file.".p10k.zsh".text = my_p10k_config;

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        history.size = 100000;
        dotDir = "/home/${vars.user}/.config/zsh";

        initContent = lib.mkMerge [
          (lib.mkOrder 550 zsh_init)
          (lib.mkOrder 1000 my_zsh_config)
        ];

        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "sudo" ];
        };
        plugins = [
          {
            name = "zsh-powerlevel10k";
            src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
            file = "powerlevel10k.zsh-theme";
          }
        ];
      };
    };
  };
}
