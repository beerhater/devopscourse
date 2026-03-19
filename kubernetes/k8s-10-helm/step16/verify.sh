#!/bin/bash
helm list 2>/dev/null | grep -q 'devapp-release'
