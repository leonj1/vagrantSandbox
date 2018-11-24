#!/bin/bash

vagrant global-status | grep running | awk {'print $2'}

