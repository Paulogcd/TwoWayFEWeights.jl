const TEST_DIR = @__DIR__
const REPO_DIR = dirname(TEST_DIR)
const VENV_DIR = joinpath(TEST_DIR, ".venv")
const REQUIREMENTS = joinpath(TEST_DIR, "requirements-python.txt")

# Platform-specific Python executable
const PYTHON = Sys.iswindows() ?
    joinpath(VENV_DIR, "Scripts", "python.exe") :
    joinpath(VENV_DIR, "bin", "python")

# Create the virtual environment if necessary
if !isfile(PYTHON)
    # Find an existing Python interpreter to create the venv
    system_python = Sys.which("python3")

    if system_python === nothing
        system_python = Sys.which("python")
    end

    if system_python === nothing
        error(
            "Python was not found. Install Python 3 and ensure " *
            "'python3' is available on PATH."
        )
    end

    @info "Creating Python virtual environment" VENV_DIR
    run(`$system_python -m venv $VENV_DIR`)
end

# Install the required Python dependencies
@info "Installing Python test dependencies"
run(`$PYTHON -m pip install -r $REQUIREMENTS`)

# Configure PyCall to use this interpreter when it is built.
# This must happen before PyCall is imported.
ENV["PYTHON"] = PYTHON

# PyCall needs to be built against the selected interpreter.
# Do this before importing PyCall.
@info "Configuring PyCall to use the test Python environment"
using Pkg
Pkg.build("PyCall")