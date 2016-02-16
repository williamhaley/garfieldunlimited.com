#!/bin/bash

CONTAINER_ID=$(docker ps | grep -i 'test-tag1' | cut -d' ' -f1)

docker exec -i -t $CONTAINER_ID /bin/bash
