#!/bin/bash
helm history myapp-release 2>/dev/null | grep -q 'rollback\|deployed'
