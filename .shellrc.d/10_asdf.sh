# ASDF software manager setup

function install_asdf {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    cd ~/.asdf
    git checkout "$(git describe --abbrev=0 --tags)"
    cd -

    # Install tools
    if [ -f ~/.tool-versions ]; then
        cut -d' ' -f1 .tool-versions | xargs -r asdf plugin add
        asdf install
    fi
}

function update_asdf {
    asdf update
}

function uninstall_asdf {
    rm -rf ${ASDF_DATA_DIR:-$HOME/.asdf} #~/.tool-versions
}

# Install it if not present
if [ ! -d ~/.asdf ]; then
    install_asdf
fi

# Load it
if [ -f ~/.asdf/asdf.sh ]; then
    . ~/.asdf/asdf.sh
fi
