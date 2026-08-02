# PilotDECODER

**Plain-English aviation tools for student and private pilots.**

Live at **[pilotdecoder.com](https://pilotdecoder.com)**

PilotDECODER is a small collection of focused, browser-based tools that make
common aviation tasks easier to understand — decoding weather, converting
time, visualizing aerodynamics, and identifying clouds. No installs, no
accounts, no clutter: open a page and use it.

## The tools

| Tool | What it does |
|------|--------------|
| **[METAR Decoder](https://pilotdecoder.com/metar-decoder/)** | Paste a raw METAR and get a plain-English breakdown of wind, visibility, clouds, temperature, and altimeter. |
| **[Density Altitude Decoder](https://pilotdecoder.com/density-altitude-decoder/)** | Walks through every step of the density-altitude hand calculation — pressure altitude, standard temperature, and the 120 ft/°C rule — with a live chart marking your result. |
| **[Wind Tunnel Decoder](https://pilotdecoder.com/wind-tunnel-decoder/)** | An interactive 2D wind tunnel: watch air flow over a NACA airfoil, change the angle of attack, and see lift, drag, buffet, and stall happen in real time. |
| **[Flight Pattern Decoder](https://pilotdecoder.com/flight-pattern-decoder/)** | Watch the VFR traffic pattern fly itself — closed-traffic circuits, the 45, midfield crosswind, teardrop, and straight-in entries — with AC 90-66 radio calls, live wind, and runway selection. |
| **[Zulu Decoder](https://pilotdecoder.com/zulu-decoder/)** | Convert between Zulu (Coordinated Universal Time) and the four U.S. time zones, in 24- and 12-hour formats, with daylight saving handled automatically. |
| **[Cloud Decoder](https://pilotdecoder.com/cloud-decoder/)** | Upload a photo of the sky and get the cloud type(s) identified from a pilot's perspective, each with a confidence rating and a short plain-English explanation. |

## About

PilotDECODER is a lightweight static website — plain HTML, CSS, and
JavaScript, with no build step and no frameworks — served by GitHub Pages at
the custom domain **[pilotdecoder.com](https://pilotdecoder.com)**. Each tool
lives on its own page and runs entirely in the browser.

The one exception is **Cloud Decoder**, which sends the uploaded photo to a
small private backend (a Cloudflare Worker) that runs the image recognition
and returns the result — so no image-recognition keys ever ship in the page.

Built for student pilots, flight instructors, and anyone learning to fly.
