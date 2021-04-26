# Eazy Onboard

## Synopsis

This script is created to simplify the onboarding experience for a new engineer on a **MacOS** device (devops focused!)

## Rationale

As a new hire, onboarding typically takes hours or even days because of the following:
- Find and locate (correct) onboarding docs
- **Download software**
- **Clone repos**
- Get application access

Using this script, it will download software and clone some repos in just a few minutes. :blush:

## Prerequisite

- This is for MacOS only. Sorry Windows and Linux users :disappointed:

## How to Run

Simply run `make run`. As the script runs, part of the setups will prompt you to enter things like username, passwords, etc.

## What Does it Actually Do?

The script would do the following, in this order (if they don't already exist):
1. generate an ssh keypair and instruct you to upload the public key to Github
1. install homebrew
1. install a number of apps via homebrew (for a full list, see [onboarding-inventory](./onboarding-inventory))
1. install a few VS Code extensions (for a full list, see [onboarding-inventory](./onboarding-inventory))
1. install [oh_my_zsh](https://ohmyz.sh/) and [awesome vim](https://github.com/amix/vimrc)
1. install Docker for Mac (MacOS Security may block the initial start. Instructions provided on how to resolve it in Systems Preferences) and config it
1. configure git to resolve some common errors
1. configure terraform to use the correct version
1. configure AWS locally
1. use AWS creds to configure kubeconfig
1. ~~clone useful repos (for a full list of repos, see [onboarding-inventory](./onboarding-inventory))~~
1. install kubectl aliases (see https://github.com/ahmetb/kubectl-aliases/blob/master/.kubectl_aliases)
1. add even more aliases

## How to Contribute

- We realize that the goodies here may not be for everyone. In [eazy-onboard.sh](./eazh-onboard.sh), you may add another `elif` statement to include your own functions only
- Feel free to add or remove items from the lists of apps, VS Code extensions, and team repos in [onboarding-inventory](./onboarding-inventory))
- Please add unit tests if possible to `test-eazy-onboard.sh`, then run `make test`. More unit tests will be added over time
- Add your feature to this readme

## Contributors
Gary Cheung