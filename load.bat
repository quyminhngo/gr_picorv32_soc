@echo off
cd fw\fw-flash
make all
cd ..\..
make program
