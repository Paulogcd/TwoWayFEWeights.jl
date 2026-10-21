const TEST_DIR = @__DIR__
const VENV_DIR = joinpath(TEST_DIR, ".venv")
const REQUIREMENTS = joinpath(TEST_DIR, "requirements-python.txt")

const PYTHON = joinpath(VENV_DIR, "bin", "python")

if !isfile(PYTHON)
    error("Python test environment not found at $VENV_DIR")
end

@info "Using Python test environment" PYTHON

# Install dependencies into the same interpreter PyCall will use.
run(`$PYTHON -m pip install -r $REQUIREMENTS`)

# Verify that the required Python packages are available.
run(`$PYTHON -c "import pandas; import twowayfeweights; print('Python dependencies OK')"`)
