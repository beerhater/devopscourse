#!/bin/bash
docker run --rm --network app-network alpine ping -c 1 web > /dev/null 2>&1
