#!/bin/bash

# https://www.makedeb.org/

if ! hash makedeb &> /dev/null; then
    bash -ci "$(wget -qO - 'https://shlink.makedeb.org/install')"
fi
