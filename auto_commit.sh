#!/bin/bash
echo "In Path :"
pwd
echo "pull from rep"
git pull origin main --allow-unrelated-histories
echo "push to rep"
git add .
git commit -m "auto commit - trip_go"
git branch -M main
git push -u origin main