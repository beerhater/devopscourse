#!/bin/bash
test -f ~/tf-modules/modules/app-config/main.tf &&
test -f ~/tf-modules/modules/app-config/variables.tf &&
test -f ~/tf-modules/modules/app-config/outputs.tf
