## [1.8.7] - 2025-01-30

- Fixed entry point execution error: main() missing required positional argument 'argv'
- Added fallback to Python module execution when entry point fails
- Improved error handling and timeout protection for application startup

## [1.8.6] - 2025-01-30

- Re-added cryptography dependency with --only-binary flag to use pre-compiled wheels
- Fixed ModuleNotFoundError for cryptography module required by bluetti_mqtt
- Avoided source compilation by forcing binary wheel installation

## [1.8.5] - 2025-01-30

- Removed explicit cryptography dependency to avoid compilation issues in Alpine
- Fixed package installation by relying on nano2dev/bluetti_mqtt's included dependencies
- Streamlined requirements.txt to eliminate build failures

## [1.4.1] - 2023-05-13

- Bump bluetti_mqtt to version 0.15.0.

## [1.4.0] - 2023-03-20

- Bump bluetti_mqtt to version 0.12.0.
- Add [discovery mode](https://github.com/warhammerkid/bluetti_mqtt#reverse-engineering).
- Reconfigure configuration parameters.

## [1.3.0] - 2023-03-14

- Add bluez package.
- Add additional documentation.

## [1.2.1] - 2023-03-05

- Update README.
- Add LICENSE.
- Setup workflows.
- Setup dependabot.

## [1.2.0] - 2023-02-15

- Pin bluetti_mqtt to specific version.
- Switch config files from json to yaml.
- Reconfigure run.sh to allow --scan to be run in DEBUG mode.
- Setup MQTT auto-configuration.
- Update docs.

## [1.1.0] - 2023-02-10

- Addon now uses pre-built images.

## [1.0.7] - 2023-02-09

- Update regex config to match multiple mac addresses.
- Add icon and logo.

## [1.0.6] - 2023-02-08

- Update install instructions.
- Update docs with note about bluetti-logger.
- Cleanup add-on config schema.
- Add changelog.

## [1.0.5] - 2023-01-18

- Add support to configure the mqtt port.

## [1.0.4] - 2022-12-01

- Add support for the new --ha-config flag.

## [1.0.3] - 2022-11-23

- Add support for USB bluetooth devices.

## [1.0.2] - 2022-11-06

- Add Debug mode.

## [1.0.1] - 2022-11-01

- Initial upload.
