#!/bin/bash
curl -X PUT -d "id=$1&body=new%20body" http://localhost/task-api/task
