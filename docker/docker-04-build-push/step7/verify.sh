#!/bin/bash
curl -s http://localhost:5000/v2/_catalog | grep -q "finalapp"
