#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Bluetti3MQTT
# MQTT bridge between Bluetti and Home Assistant with nano2dev support
# ==============================================================================

# Global constants
readonly VENV_PATH="/venv"
readonly PYTHON_EXE="${VENV_PATH}/bin/python3"
readonly APP_PATH="/bluetti2mqtt"
readonly SHARE_PATH="/share/bluetti2mqtt"

# Global variables
DEBUG_MODE=false
PYTHON_LOGLEVEL="INFO"

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

# Log helper functions
log_info() {
    bashio::log.info "$1"
}

log_warn() {
    bashio::log.warning "$1"
}

log_error() {
    bashio::log.error "$1"
}

log_debug() {
    if [[ "${DEBUG_MODE}" == "true" ]]; then
        bashio::log.info "[DEBUG] $1"
    fi
}

# ==============================================================================
# ENVIRONMENT SETUP FUNCTIONS
# ==============================================================================

# Set up Python environment variables
setup_python_environment() {
    log_info "Setting up Python environment..."
    export PYTHONPATH="${APP_PATH}:${PYTHONPATH:-}"
    export PYTHON_LOGLEVEL="${PYTHON_LOGLEVEL}"
    log_debug "PYTHONPATH set to: ${PYTHONPATH}"
}

# Create and configure virtual environment
setup_virtual_environment() {
    if [[ -x "${PYTHON_EXE}" ]]; then
        log_debug "Virtual environment already exists at ${VENV_PATH}"
        return 0
    fi

    log_warn "Virtual environment not found, creating at ${VENV_PATH}..."
    
    # Create virtual environment
    if ! python3 -m venv "${VENV_PATH}"; then
        log_error "Failed to create virtual environment"
        return 1
    fi

    # Upgrade pip
    log_info "Upgrading pip in virtual environment..."
    if ! "${PYTHON_EXE}" -m pip install --upgrade pip; then
        log_error "Failed to upgrade pip"
        return 1
    fi

    log_info "Virtual environment created successfully"
    return 0
}

# Install Python dependencies
install_dependencies() {
    local requirements_file="${APP_PATH}/requirements.txt"
    local setup_file="${APP_PATH}/setup.py"

    log_debug "Looking for requirements.txt at: ${requirements_file}"
    log_debug "Looking for setup.py at: ${setup_file}"
    
    # List what's actually in the APP_PATH
    log_debug "Contents of ${APP_PATH}:"
    ls -la "${APP_PATH}/" || log_error "Failed to list ${APP_PATH}"

    # Install requirements.txt if it exists
    if [[ -f "${requirements_file}" ]]; then
        log_info "Installing dependencies from requirements.txt..."
        if ! "${PYTHON_EXE}" -m pip install --no-cache-dir -r "${requirements_file}"; then
            log_error "Failed to install requirements from ${requirements_file}"
            return 1
        fi
        log_info "Requirements installed successfully"
    else
        log_info "No requirements.txt found, skipping external dependencies"
    fi

    # Install local package in editable mode if setup.py exists
    if [[ -f "${setup_file}" ]]; then
        log_info "Installing local bluetti_mqtt package in editable mode..."
        if ! "${PYTHON_EXE}" -m pip install --no-cache-dir -e "${APP_PATH}"; then
            log_error "Failed to install local package from ${setup_file}"
            return 1
        fi
        log_info "Local package installed successfully"
    else
        log_info "No setup.py found, installing bluetti_mqtt from GitHub..."
        # Run the installation script created in Dockerfile
        if [[ -f "/install_bluetti.sh" ]]; then
            if ! /install_bluetti.sh; then
                log_error "Failed to install bluetti_mqtt from GitHub"
                return 1
            fi
            log_info "bluetti_mqtt installed from GitHub successfully"
        else
            log_error "No installation method available for bluetti_mqtt"
            return 1
        fi
    fi

    return 0
}

# Run comprehensive environment diagnostics
run_diagnostics() {
    if [[ "${DEBUG_MODE}" != "true" ]]; then
        return 0
    fi

    log_info "Running environment diagnostics..."

    # Check what files are actually in the APP_PATH
    log_debug "Checking contents of ${APP_PATH}..."
    if [[ -d "${APP_PATH}" ]]; then
        ls -la "${APP_PATH}/" | head -20
    else
        log_error "${APP_PATH} directory not found!"
    fi

    # Check virtual environment
    log_debug "Checking virtual environment structure..."
    if [[ -d "${VENV_PATH}/bin" ]]; then
        ls -la "${VENV_PATH}/bin" | head -10
    else
        log_error "Virtual environment bin directory not found!"
    fi

    # Test Python installation
    log_debug "Testing Python installation..."
    if ! "${PYTHON_EXE}" -c "import sys; print(f'Python version: {sys.version}')"; then
        log_error "Failed to run Python from virtual environment"
        return 1
    fi

    # Check Python path
    log_debug "Checking Python import path..."
    "${PYTHON_EXE}" -c "import sys; print('Python path:', sys.path)"

    # Test bluetti_mqtt module import
    log_debug "Testing bluetti_mqtt module import..."
    if "${PYTHON_EXE}" -c "import bluetti_mqtt; print('✓ bluetti_mqtt module found')"; then
        log_info "bluetti_mqtt module is available"
    else
        log_error "bluetti_mqtt module not found - check setup.py installation"
    fi

    # Test module execution
    log_debug "Testing bluetti_mqtt module execution..."
    if "${PYTHON_EXE}" -m bluetti_mqtt --help >/dev/null 2>&1; then
        log_info "bluetti_mqtt module can be executed"
    else
        log_error "bluetti_mqtt module execution failed"
    fi

    # Check for legacy entry points (should not be used)
    if ls /usr/local/bin/bluetti-* >/dev/null 2>&1; then
        log_warn "Legacy entry points found in /usr/local/bin/ - using venv version instead"
    fi

    return 0
}

# ==============================================================================
# CONFIGURATION FUNCTIONS
# ==============================================================================

# Load and validate configuration
load_configuration() {
    log_info "Loading configuration settings..."

    # Set debug mode and logging level
    if [[ "$(bashio::config 'debug')" == "true" ]]; then
        DEBUG_MODE=true
        PYTHON_LOGLEVEL="DEBUG"
        export DEBUG=true
        log_info "Debug mode enabled"
    fi

    # Load basic configuration
    MODE=$(bashio::config 'mode')
    HA_CONFIG=$(bashio::config 'ha_config')
    BT_MAC=$(bashio::config 'bt_mac')
    POLL_SEC=$(bashio::config 'poll_sec')
    SCAN=$(bashio::config 'scan')

    log_debug "Configuration loaded: MODE=${MODE}, BT_MAC=${BT_MAC}, POLL_SEC=${POLL_SEC}"
}

# Configure MQTT connection settings
configure_mqtt() {
    log_debug "Configuring MQTT connection..."

    # MQTT Host
    if bashio::config.has_value 'mqtt_host'; then
        MQTT_HOST=$(bashio::config 'mqtt_host')
    else
        MQTT_HOST=$(bashio::services "mqtt" "host")
    fi

    # MQTT Port
    if bashio::config.has_value 'mqtt_port'; then
        MQTT_PORT=$(bashio::config 'mqtt_port')
    else
        MQTT_PORT=$(bashio::services "mqtt" "port")
    fi

    # MQTT Username
    if bashio::config.has_value 'mqtt_username'; then
        MQTT_USERNAME=$(bashio::config 'mqtt_username')
    else
        MQTT_USERNAME=$(bashio::services mqtt "username")
    fi

    # MQTT Password
    if bashio::config.has_value 'mqtt_password'; then
        MQTT_PASSWORD=$(bashio::config 'mqtt_password')
    else
        MQTT_PASSWORD=$(bashio::services "mqtt" "password")
    fi

    log_debug "MQTT configured: ${MQTT_HOST}:${MQTT_PORT}"
}

# ==============================================================================
# APPLICATION EXECUTION FUNCTIONS
# ==============================================================================

# Build common arguments for all modes
build_base_arguments() {
    local -n args_ref=$1
    args_ref=()

    # Add scan flag if enabled
    if [[ "${SCAN}" == "true" ]]; then
        args_ref+=(--scan)
        log_debug "Scan mode enabled"
    fi
}

# Execute MQTT mode
execute_mqtt_mode() {
    local args
    build_base_arguments args

    log_info "Starting Bluetti MQTT bridge..."
    
    # Add MQTT-specific arguments
    args+=(--broker "${MQTT_HOST}" --port "${MQTT_PORT}")
    
    if [[ -n "${MQTT_USERNAME}" ]]; then
        args+=(--username "${MQTT_USERNAME}")
        log_debug "MQTT username configured"
    fi
    
    if [[ -n "${MQTT_PASSWORD}" ]]; then
        args+=(--password "${MQTT_PASSWORD}")
        log_debug "MQTT password configured"
    fi
    
    args+=(--interval "${POLL_SEC}" --ha-config "${HA_CONFIG}" "${BT_MAC}")
    
    log_debug "Executing: ${PYTHON_EXE} -m bluetti_mqtt ${args[*]}"
    exec "${PYTHON_EXE}" -m bluetti_mqtt "${args[@]}"
}

# Execute discovery mode
execute_discovery_mode() {
    local args
    build_base_arguments args

    log_info "Starting Bluetti device discovery..."
    log_info "Messages will NOT be published to MQTT broker in discovery mode"
    
    # Ensure share directory exists
    mkdir -p "${SHARE_PATH}"
    
    # Add discovery-specific arguments
    local timestamp=$(date "+%m%d%y%H%M%S")
    args+=(--log "${SHARE_PATH}/discovery_${timestamp}.log" "${BT_MAC}")
    
    log_debug "Executing: ${PYTHON_EXE} -m bluetti_mqtt.discovery ${args[*]}"
    exec "${PYTHON_EXE}" -m bluetti_mqtt.discovery "${args[@]}"
}

# Execute logger mode
execute_logger_mode() {
    local args
    build_base_arguments args

    log_info "Starting Bluetti data logger..."
    log_info "Messages will NOT be published to MQTT broker in logger mode"
    
    # Ensure share directory exists
    mkdir -p "${SHARE_PATH}"
    
    # Add logger-specific arguments
    local timestamp=$(date "+%m%d%y%H%M%S")
    args+=(--log "${SHARE_PATH}/logger_${timestamp}.log" "${BT_MAC}")
    
    log_debug "Executing: ${PYTHON_EXE} -m bluetti_mqtt.logger ${args[*]}"
    exec "${PYTHON_EXE}" -m bluetti_mqtt.logger "${args[@]}"
}

# Execute the selected mode
execute_application() {
    case "${MODE}" in
        mqtt)
            execute_mqtt_mode
            ;;
        discovery)
            execute_discovery_mode
            ;;
        logger)
            execute_logger_mode
            ;;
        *)
            log_error "Invalid mode: '${MODE}'. Please choose 'mqtt', 'discovery', or 'logger'"
            exit 1
            ;;
    esac
}

# ==============================================================================
# MAIN EXECUTION FLOW
# ==============================================================================

main() {
    log_info "Starting Bluetti3MQTT Add-on..."

    # Step 1: Load configuration
    load_configuration || {
        log_error "Failed to load configuration"
        exit 1
    }

    # Step 2: Set up Python environment
    setup_python_environment || {
        log_error "Failed to set up Python environment"
        exit 1
    }

    # Step 3: Set up virtual environment
    setup_virtual_environment || {
        log_error "Failed to set up virtual environment"
        exit 1
    }

    # Step 4: Install dependencies
    install_dependencies || {
        log_error "Failed to install dependencies"
        exit 1
    }

    # Step 5: Configure MQTT if needed
    configure_mqtt || {
        log_error "Failed to configure MQTT"
        exit 1
    }

    # Step 6: Run diagnostics in debug mode
    run_diagnostics || {
        log_error "Diagnostic checks failed"
        exit 1
    }

    # Step 7: Execute the application
    log_info "Environment setup complete, starting application..."
    execute_application
}

# Execute main function
main "$@"
