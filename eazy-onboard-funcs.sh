source onboarding-inventory

function welcome() {
    echo "welcome, $USER, to the onboarding script! This script has been created to automate most of the downloads, configs, etc."
    echo "please see the readme for what this script will do to you."
    sleep 1
    echo
}

function generate_ssh() {
    if [ -f "$HOME/.ssh/id_rsa.pub" ]; then 
        BLUE='\033[0;32m'
        NC='\033[0m' # No Color
        echo "An ssh keypair has already been generated on this machine. If it needs to be regenerated, run ${BLUE}rm ~/.ssh/id_rsa*${NC} and then rerun this script." 
    else
        echo "we will now be generating the ssh key for you..."
        ssh-keygen -t rsa -b 4096 -C $USER
        echo "ssh generated. Please add your public key (e.g. ~/.ssh/id_rsa.pub) to https://github.com/settings/keys."
        read -p "Once you have done that, please press enter to continue"
    fi
    echo
}

function install_brew() {
    if ! command -v brew &> /dev/null; then
        echo "installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        echo "homebrew already installed."
    fi
    echo
}

function install_brew_apps() {
    echo "begin installing the apps via brew..."
    brew tap liamg/tfsec
    brew install $BREW_APPS
    echo "app installation completed."
    echo
}

function install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then 
        echo exit | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        sed -i '' 's/plugins=(git)/plugins=(brew git aws)/g' ~/.zshrc
    fi 
}

function install_code_extensions() {
    echo "installing useful VSCode extensions..."
    for ext in "${VSCODE_EXTENSIONS[@]}"; do
        code --install-extension $ext
    done
    echo
}

function install_docker() {
    # downloading and installing Docker for Mac is a little hacky. 
    # but...Docker for Mac is easier to use as a consumer than using brew to install docker and docker-machine
    if ! command -v docker > /dev/null; then
        echo "downloading and installing Docker for Mac (downloading may take a minute)..."
        echo "note: you may be prompted to enter your computer password as sudo is needed to attach and detach the img file..."
        curl -s -O https://desktop.docker.com/mac/stable/Docker.dmg
        sudo hdiutil attach Docker.dmg > /dev/null
        cp -r /Volumes/Docker/Docker.app /Applications
        sudo hdiutil detach /Volumes/Docker > /dev/null
        rm Docker.dmg
        open -a Docker
        echo "if you see an error message saying that the app cannot be trusted,"
        echo "click cancel, open 'Security & Privacy', then click 'Open Anyway' into trust the app"
        echo "then you can manually reopen Docker"
        echo
    fi
}

function config_docker() {
    if [ -f $HOME/.docker/config.json ]; then
        cat > $HOME/.docker/config.json <<-EOF
{
    "auths": {
        "077264122337.dkr.ecr.us-east-1.amazonaws.com": {},
        "https://077264122337.dkr.ecr.us-east-1.amazonaws.com": {}
    },
    "HttpHeaders": {
        "User-Agent": "Docker-Client/19.03.1 (darwin)"
    },
    "credsStore": "desktop"
}
EOF
    fi
}

function config_git() {
    # cloning a private repo sometimes gives out the following error:
    # `fatal: could not read Username for 'https://github.com': terminal prompts disabled
    # package github.com/examplesite/myprivaterepo: exit status 128`
    # this is the workaround to use SSH instead of username/password
    # ref: https://stackoverflow.com/questions/32232655/go-get-results-in-terminal-prompts-disabled-error-for-github-private-repo
    git config --global --add url."git@github.com:".insteadOf "https://github.com/"
}

function config_terraform() {
    read -p "which Terraform version would you like to use? (default: $DEFAULT_TF_VERSION): " TF_VERSION
    if [ ! $TF_VERSION ]; then
        TV=$DEFAULT_TF_VERSION
    fi
    tfswitch $TV
    echo
}

function config_awesome_vim() {
    if [ ! -f ~/.vim_runtime/install_awesome_vimrc.sh ]; then
        git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
        sh ~/.vim_runtime/install_awesome_vimrc.sh
        echo
    fi
}

function add_kube_aliases() {
    if [ ! -f $HOME/.zshrc ]; then
        touch ~/.zshrc
    fi
    if [ ! -f $HOME/.kubectl_aliases ]; then
        curl -o $HOME/.kubectl_aliases https://raw.githubusercontent.com/ahmetb/kubectl-alias/master/.kubectl_aliases 
    fi
    if ! grep -q "kubectl_aliases" $HOME/.zshrc; then
        echo "adding some kubectl aliases (see https://github.com/ahmetb/kubectl-aliases/blob/master/.kubectl_aliases)..."
        echo "[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases\n" >> $HOME/.zshrc
    fi
    if ! grep -q "KUBECONFIG" $HOME/.zshrc; then
        echo "export KUBECONFIG=$HOME/.kube/config\n" >> $HOME/.zshrc
    fi
    echo
}

function add_more_aliases() {
    if [ ! -f $HOME/.zshrc ]; then
        touch ~/.zshrc
    fi
    echo "adding more aliases..."

    if ! grep -q "stern" $HOME/.zshrc; then
        echo 'source <(stern --completion=zsh)' >> ~/.zshrc
    fi

    if ! grep -q "kube-ps1" $HOME/.zshrc; then
        echo "
source \"$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh\"
PS1='\$(kube_ps1)'\$PS1" >> ~/.zshrc
    fi
    
    if ! grep -q "ZSH_HIGHLIGHT_HIGHLIGHTERS" $HOME/.zshrc; then
            echo '
export VIRTUAL_ENV_DISABLE_PROMPT=
export LC_CTYPE=en_GB.UTF-8
export TERM="xterm-256color"
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
    fi
    echo
}

function add_gopath_to_path() {
    if [ ! -f $HOME/.zshrc ]; then
        touch ~/.zshrc
    fi
    echo "adding gopath..."
    if ! grep -q "GOPATH" $HOME/.zshrc; then
        echo "export GOPATH=$HOME/go\nexport PATH=\$PATH:\$GOPATH/bin\n" >> $HOME/.zshrc
    fi
    echo
}

function reload_zsh_config() {
    source ~/.zshrc 2> /dev/null
}

function byebye() {
    echo "installation has been completed :) Thank you for your patience and have a wonderful day!"
    # TODO: maybe add some links showing what to do next
}
