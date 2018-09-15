#!/bin/bash

grep config.vm.define Vagrantfile | awk -F'"' '{print $2}' | xargs -P4 -I {} vagrant up {}

