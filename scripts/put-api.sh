#!/bin/bash
curl -X PUT -d "key=k&value=val%20ue\&" http://localhost/demo-api/key-value
