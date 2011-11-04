#!/bin/sh
nohup ruby sina_main.rb >> sina_main.log &
nohup ruby worker.rb >> worker.log &

