{ pkgs }:

pkgs.writeShellScriptBin "web-search" ''
    declare -A URLS

    URLS=(
      ["🌎 Search"]="https://www.google.com/search?q="
      ["📖 MyAnimeList"]="https://myanimelist.net/search/all?q="
      ["🔥 Hianime"]="https://hianime.to/search?keyword="
      ["❄️  Unstable Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
      ["🎞️ YouTube"]="https://www.youtube.com/results?search_query="
      ["🦥 Arch Wiki"]="https://wiki.archlinux.org/title/"
      ["🐃 Gentoo Wiki"]="https://wiki.gentoo.org/index.php?title="
    )

    # List for rofi
    gen_list() {
      for i in "''${!URLS[@]}"
      do
        echo "$i"
      done
    }

    main() {
      # Pass the list to rofi
      platform=$( (gen_list) | ${pkgs.wofi}/bin/wofi -dmenu )

      if [[ -n "$platform" ]]; then
        query=$( (echo ) | ${pkgs.wofi}/bin/wofi -dmenu )

        if [[ -n "$query" ]]; then
  	      url=''${URLS[$platform]}$query
  	      qutebrowser --target window "$url"
        else
  	      exit
        fi
      else
        exit
      fi
    }

    main

    exit 0
''
