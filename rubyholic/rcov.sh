#!/bin/bash

rake test:units:rcov SHOW_ONLY=m
open coverage/units/index.html
rake test:functionals:rcov SHOW_ONLY=c,h
open coverage/functionals/index.html
