# ASDF software manager setup

install_asdf() {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf \
    && cd ~/.asdf \
    && git checkout "$(git describe --abbrev=0 --tags)" \
    && cd -
}

update_asdf() {
    asdf update
}

uninstall_asdf() {
    rm -rf ${ASDF_DATA_DIR:-$HOME/.asdf} #~/.tool-versions
}


_asdf_load(){
    if [ -f ~/.asdf/asdf.sh ]; then
        . ~/.asdf/asdf.sh
    fi
}

_asdf_install_tools(){
    if [ -f ~/.tool-versions ]; then
        grep -v '^#' ~/.tool-versions \
        | cut -d' ' -f1 \
        | xargs -r -n1 -I% sh -c \
            'echo Adding plugin % && asdf plugin add % && asdf install'
    fi
}

# Install it if not present
if [ ! -d ~/.asdf ]; then
    install_asdf
    _asdf_load
    _asdf_install_tools
fi

# Always load asdf if present
_asdf_load
