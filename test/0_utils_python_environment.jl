const TEST_DIR = @__DIR__
const VENV_DIR = joinpath(TEST_DIR, ".venv")
const PYTHON = joinpath(VENV_DIR, "bin", "python")

if !isfile(PYTHON)
    error("Python test environment not found at $VENV_DIR")
end

@info "Expected Python interpreter" PYTHON
@info "PyCall Python interpreter" PyCall.python

if realpath(PyCall.python) != realpath(PYTHON)
    error("PyCall is using the wrong Python interpreter")
end

# Install dependencies into the same interpreter PyCall uses.
run(`$PYTHON -m pip install -r $(joinpath(TEST_DIR, "requirements-python.txt"))`)

# Verify Python dependencies.
run(`$PYTHON -c "import pandas; import twowayfeweights; print('Python dependencies OK')"`)

# Continue with the existing Julia tests...