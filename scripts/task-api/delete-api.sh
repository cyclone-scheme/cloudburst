#!/bin/bash
curl -X DELETE -d "id=$1" http://localhost/task-api/task
