#!/bin/bash

#vagrant global-status | grep running | awk {'print $2'}
vagrant status | grep running | awk {'print $1'}

