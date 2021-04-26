source eazy-onboard-funcs.sh

if [ "$(uname)" != "Darwin" ]; then
echo "I see that you are using $(uname) - this onboarding script is for MacOS only. Bye!"
exit 0
fi

welcome
if [ "$1" == "all" ]; then
generate_ssh
install_brew
install_brew_apps
install_code_extensions
install_oh_my_zsh
config_awesome_vim
install_docker
config_git
config_terraform
add_kube_aliases
add_more_aliases
add_gopath_to_path
reload_zsh_config
byebye
fi