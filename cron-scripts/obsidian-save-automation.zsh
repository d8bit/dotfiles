#!/usr/bin/zsh

main() {
  git -C ~/Documents/tui/obsidian/ add . && git -C ~/Documents/tui/obsidian/ commit -m "Update"
  git -C ~/Documents/tui/obsidian/ archive --format=zip --output=/media/david/F5EE-16E5/work/obsidian.zip master
}


main
