
This fork uses github.com/ZachGoldberg/bluetti_mqtt.git which is a fork of https://github.com/bxm6306/bluetti_mqtt which is a fork of https://github.com/warhammerkid/bluetti_mqtt.

The goal of these forks is to incorporate bxm6306's work supporting the AC60/AC70 for home assistant, and to include a bugfix pinning the version of paho-mqtt to 1.6.1

# Bluetti2MQTT

![update-badge](https://img.shields.io/github/last-commit/SSMCD/bluetti2mqtt?label=Last%20Updated)

## Installation
To add this repository to Home Assistant use the badge below:

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FSSMCD%2Fbluetti2mqtt)

or add it manually by navigating to `Settings` > `Add-ons` > `Add-on Store`

Select the three dot menu in the upper right, choose `Repositories`, and add the following url:
```
https://github.com/SSMCD/bluetti2mqtt
```

Refresh the page (hard refresh may be required), scroll down to Bluetti2MQTT and install the add-on.

## Add-ons

This repository contains the following add-ons:

### [Bluetti2MQTT](./bluetti2mqtt)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg

_MQTT bridge between Bluetti and Home Assistant._
