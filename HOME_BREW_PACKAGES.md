# Homebrew Packages

## Formulae
Install with `brew install --formula` or `brew install`:
- aom
- apr
- apr-util
- argon2
- aribb24
- autoconf
- bash-completion
- bat
- brotli
- c-ares
- ca-certificates
- cairo
- cjson
- cloudflared
- composer
- curl
- dav1d
- deno
- docker-credential-helper
- doctl
- elixir
- entr
- erlang
- eza
- fd
- ffmpeg
- ffmpegthumbnailer
- flac
- flyctl
- fontconfig
- freetds
- freetype
- frei0r
- fribidi
- fzf
- gd
- gemini-cli
- gettext
- giflib
- glib
- gmp
- gnupg
- gnutls
- go
- gpgme
- gpgmepp
- graphite2
- harfbuzz
- helix
- highway
- icu4c
- icu4c@77
- icu4c@78
- imath
- jpeg-turbo
- jpeg-xl
- jq
- krb5
- lame
- lazydocker
- lazygit
- leptonica
- libarchive
- libass
- libassuan
- libavif
- libb2
- libbluray
- libdeflate
- libevent
- libgcrypt
- libgit2
- libgpg-error
- libidn2
- libksba
- libmicrohttpd
- libnghttp2
- libnghttp3
- libngtcp2
- libogg
- libpng
- libpq
- librist
- libsamplerate
- libsndfile
- libsodium
- libsoxr
- libssh
- libssh2
- libtasn1
- libtiff
- libtool
- libunibreak
- libunistring
- libusb
- libuv
- libvidstab
- libvmaf
- libvorbis
- libvpx
- libvterm
- libx11
- libxau
- libxcb
- libxdmcp
- libxext
- libxrender
- libzip
- little-cms2
- lpeg
- luajit
- luv
- lz4
- lzo
- m4
- mbedtls
- mpdecimal
- mpg123
- msgpack
- nats
- neonctl
- neovim
- net-snmp
- nettle
- node
- npth
- nspr
- nss
- nx
- oniguruma
- opencode
- opencore-amr
- openexr
- openjpeg
- openjph
- openldap
- openssl@3
- opus
- p11-kit
- pango
- pcre2
- php
- pinentry
- pixman
- pnpm
- podman
- poppler
- postgresql@14
- powerlevel10k
- python@3.12
- qrencode
- railway
- rav1e
- readline
- ripgrep
- rtmpdump
- rubberband
- sdl2
- simdjson
- snappy
- speex
- sqlite
- srt
- stow
- supabase
- surreal
- svt-av1
- terraform
- tesseract
- theora
- tidy-html5
- tree-sitter
- unar
- unbound
- unibilium
- unixodbc
- uvwasi
- webp
- wget
- wxwidgets
- x264
- x265
- xorgproto
- xvid
- xz
- yarn
- yazi
- zeromq
- zimg
- zoxide
- zsh-autosuggestions
- zsh-syntax-highlighting
- zstd

## Casks
Install with `brew install --cask`:
- bitwarden
- claude-code
- codex
- font-symbols-only-nerd-font
- macfuse
- podman-desktop
- wezterm

## Replay Instructions
1. Install Homebrew if missing via `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`.
2. Reinstall the formulae with:
   ```sh
   grep -A999 '^## Formulae' HOME_BREW_PACKAGES.md \
     | sed -n '2,/^## Casks/p' \
     | grep -oP '(?<=^- )\S+' \
     | xargs brew install
   ```
3. Reinstall the GUI apps with:
   ```sh
   grep -A999 '^## Casks' HOME_BREW_PACKAGES.md \
     | grep -oP '(?<=^- )\S+' \
     | xargs brew install --cask
   ```
4. Pin or re-link versioned formulae such as `icu4c@77` and `postgresql@14` after installation if needed.
