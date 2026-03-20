#!/bin/bash
test -f /tmp/tf-chain/manifest.txt && grep -q 'project_id' /tmp/tf-chain/manifest.txt
