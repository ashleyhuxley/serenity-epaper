# Serenity E-Paper Display

Epaper Display for Home Assistant. This is a custom project that uses an ePaper display salvaged from an electronic price tag, the type used in supermarkets.

The display is a GDEY0579Z93 292 x 792 tri colour e-ink display from GoodDisplay.

This project uses the [GxEDP2 library](https://github.com/ZinggJM/GxEPD2) with slight modifications to expose the pixel buffers. Rendering is done off-chip - an external service gathers the data, renders it to an image, and passes the raw red and black pixel data over a TCP socket to an ESP-32 which sends it to the display.

Also included is the OpenSCAD model for the case.
