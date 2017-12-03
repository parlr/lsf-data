#!/usr/bin/env bash

git checkout gh-pages
git reset --hard master
yarn build
git add dist/
yarn version
git push --force
git push --tags
git checkout master
