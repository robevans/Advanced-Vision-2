#!/bin/bash

ls *.bmp | cut -d'.' --complement -f2 | xargs -I{} convert {}.bmp {}.png