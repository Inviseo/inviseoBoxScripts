#!/bin/bash
su -
ln /usr/sbin/usermod /usr/bin
usermod -aG sudo vincent
newgrp sudo

