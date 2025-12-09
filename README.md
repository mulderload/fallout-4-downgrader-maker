# Fallout 4 Downgrader Maker

## Description

This is NOT a tool to downgrade your Fallout 4 installation.
It is a tool to help me to create and update my Fallout 4 *universal* downgrader.

I open source it to let people see how I built it, and maybe have improvements from the community.

What this project currently does:
- download all depots in current version + oldgen version from Steam
- remove some useless files (note: it could need some tweaking with future updates) to reduce size
- compare files and create .xdelta for modified files
- create archives

You can find the downgrader on my website, www.mulderland.com

## Install

You should have xdelta3.exe in your PATH
I used this one https://github.com/jmacd/xdelta-gpl/releases/download/v3.0.11/xdelta3-3.0.11-x86_64.exe.zip

You should also have 7za.exe (7zip)

## Usage

.\1_download.ps1 (download each depots in depots\123456\new + depots\123456\old)
.\2_shrink.ps1 (reduce size by removing duplicate/useless files)
.\3_compare.ps1 (compare files, create .xdelta, also output a TXT for my NSIS Recipe)
.\4_archive.ps1 (create the archives)

Then I upload them on my server and update my NSIS Recipe @ https://github.com/mulderload/recipes
