#!/bin/bash

systemctl enable ssh || systemctl enable sshd
systemctl restart ssh || systemctl restart sshd

tail -f /dev/null
