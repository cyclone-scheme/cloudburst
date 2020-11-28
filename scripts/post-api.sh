#!/bin/bash
curl -X POST -d "key=k&value=val%20ue" http://localhost/demo-api/key-value
echo
curl -X POST -d "key=val%2520u+%26e&x=y" http://localhost/demo-api/key-value
echo
