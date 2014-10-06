#!/usr/bin/env bash

bash -c "f() { x() { _;}; x() { _;} <<a; }" 2>/dev/null || echo vulnerable

sudo sh -c 'echo "/usr/local/bin/bash" >> /etc/shells'
chsh -s /usr/local/bin/bash
sudo mv /bin/bash /bin/bash-backup
sudo ln -s /usr/local/bin/bash /bin/bash