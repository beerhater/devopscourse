#!/bin/bash
test -f ~/tf-variables/locals.tf && grep -q 'name_prefix' ~/tf-variables/locals.tf
