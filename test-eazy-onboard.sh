source ./eazy-onboard-funcs.sh
source onboarding-inventory

function begin_testing() {
    echo "begin testing, please ignore yes/no prompts...\n"
}

function test_install_brew() {
    install_brew > /dev/null
    test -e $(which brew)
}

function test_install_oh_my_zsh() {
    install_oh_my_zsh > /dev/null
}

function verify_alias() {
    if ! grep -q $1 $HOME/.zshrc; then
        echo "$1 not found in $HOME/.zshrc"
        exit
    fi
}

function test_config_terraform() {
    echo "" | config_terraform > /dev/null
    terraform version | grep $DEFAULT_TF_VERSION > /dev/null || TF_TEST_PASS=false
    if [ "$TF_TEST_PASS" = false ]; then
        echo "terraform version not $TF_VERSION"
        exit
    fi
}

function test_config_awesome_vim() {
    config_awesome_vim 2> /dev/null
    if [[ ! -d "$HOME/.vim_runtime" ]]; then
        echo "expecting $HOME/.vim_runtime, but it does not exist"
        exit
    fi
}

function test_aliases() {
    test_add_kube_aliases
    test_add_more_aliases
}

function test_add_kube_aliases() {
    add_kube_aliases > /dev/null
    if ! grep -q "kubectl_aliases" $HOME/.zshrc; then
        echo "aliases not found in $HOME/.zshrc"
        exit
    fi
    reload_zsh_config 2> /dev/null
    if ! command -v klo > /dev/null; then
        echo "kube aliases not found"
        exit
    fi
}

function test_add_more_aliases() {
    add_more_aliases > /dev/null
    reload_zsh_config 2> /dev/null
    verify_alias "stern" 
}

function test_add_gopath_to_path() {
    add_gopath_to_path > /dev/null
    reload_zsh_config 2> /dev/null
    if ! grep -q "export GOPATH" $HOME/.zshrc; then
        echo "\$GOPATH not found in path"
        exit
    fi
}

function complete_testing() {
    echo "\ntesting completed."
}

begin_testing
test_install_brew
test_install_oh_my_zsh
test_config_terraform
test_config_awesome_vim
test_aliases
test_add_gopath_to_path
complete_testing