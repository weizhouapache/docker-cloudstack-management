#!/bin/bash

systemctl enable ssh || systemctl enable sshd

exec /sbin/init
