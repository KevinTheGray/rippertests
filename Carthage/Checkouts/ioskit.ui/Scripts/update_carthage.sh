#!/bin/sh
rm -rf Carthage
rm -f Cartfile.resolved
carthage update --platform ios
