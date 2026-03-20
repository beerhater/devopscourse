#!/bin/bash
ssh root@node01 'hostname' 2>/dev/null | grep -q 'node01'
