#!/usr/bin/zsh

main() {
  git -C ~/Documents/tui/obsidian/ add . && git -C ~/Documents/tui/obsidian/ commit -m "Update"
  git -C ~/Documents/barcelo/barcelo_vault/ add . && git -C ~/Documents/barcelo/barcelo_vault/ commit -m "Update"

  git -C ~/Documents/tui/obsidian/ archive --format=zip --output=/media/veracrypt1/obsidian.zip master
  git -C ~/Documents/barcelo/barcelo_vault/ archive --format=zip --output=/media/veracrypt1/barcelo_vault.zip main
}


main
