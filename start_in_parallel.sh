#!/bin/bash

grep config.vm.define Vagrantfile | awk -F'"' '{print $2}' | xargs -P2 -I {} vagrant up {}

