# My Project Template

<!-- This README is a template. The init.sh script will update the title. -->
<!-- 这个 README 是一个模板。init.sh 脚本会更新标题。 -->

## Overview

This is a new Python project generated from a template. Provide a brief overview of your project here.

## Features

- **Modern Tooling**: Uses `uv` for fast dependency management and virtual environments.
- **SRC Layout**: Follows the `src` layout for clean project structure.
- **Quality Tools**: Pre-configured with `pytest`, `ruff`, `black`, and `mypy`.

## Getting Started

### Prerequisites

- Python 3.10+
- `uv` (see installation instructions below)

### Initialization

To set up your project for the first time, run the initialization script:

```bash
./init.sh
```

This script will guide you through setting up the project name, version, and Python environment.

### Activate Virtual Environment

Once initialization is complete, activate the virtual environment:

```bash
source .venv/bin/activate
```

## Usage

- **Run tests**:

  ```bash
  uv run pytest
  ```

- **Check code formatting and linting**:

  ```bash
  uv run ruff check .
  ```

- **Apply formatting fixes**:

  ```bash
  uv run ruff format .
  uv run black .
  ```

- **Run static type checking**:

  ```bash
  uv run mypy src
  ```
