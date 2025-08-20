#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# 如果任何命令以非零状态退出，则立即退出脚本。
set -e

# --- Helper Functions --- #

# A function to print colored text.
# 用于打印彩色文本的函数。
print_info() {
    # macOS's `sed` is different from GNU `sed`, so we use `printf` for compatibility.
    printf "\033[34m%s\033[0m\n" "$1"
}

print_success() {
    printf "\033[32m%s\033[0m\n" "$1"
}

print_error() {
    printf "\033[31m%s\033[0m\n" "$1" >&2
}

# --- Main Script --- #

# 1. Welcome Message
print_info "🚀 Welcome to the Python Project Initializer!"
print_info "This script will set up your new project based on this template."

# 2. Check for `uv`
if ! command -v uv &> /dev/null; then
    print_error "'uv' is not installed or not in your PATH."
    print_info "Please install it first. See: https://github.com/astral-sh/uv"
    print_info "You can usually install it with:"
    print_info "  curl -LsSf https://astral.sh/uv/install.sh | sh"
    print_info "  or"
    print_info "  pip install uv"
    exit 1
fi

# 3. Get Project Information (Interactive)
DEFAULT_PROJECT_NAME="my-new-project"
DEFAULT_VERSION="0.1.0"
DEFAULT_PYTHON_VERSION="3.11"

read -p "Enter project name [${DEFAULT_PROJECT_NAME}]: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}

read -p "Enter project version [${DEFAULT_VERSION}]: " PROJECT_VERSION
PROJECT_VERSION=${PROJECT_VERSION:-$DEFAULT_VERSION}

read -p "Enter Python version for uv [${DEFAULT_PYTHON_VERSION}]: " PYTHON_VERSION
PYTHON_VERSION=${PYTHON_VERSION:-$DEFAULT_PYTHON_VERSION}

# Convert project name to a valid Python package name (replace hyphens with underscores).
# 将项目名称转换为有效的Python包名（用下划线替换连字符）。
PROJECT_NAME_PKG=$(echo "$PROJECT_NAME" | tr '-' '_')

print_info "🔧 Configuring project '${PROJECT_NAME}'..."

# 4. Update Project Metadata
# Use a temporary file for `sed` to ensure compatibility on both Linux and macOS.
# 使用临时文件以确保`sed`在Linux和macOS上的兼容性。

print_info "- Updating pyproject.toml..."
sed -i.bak "s/^name = .*/name = \"$PROJECT_NAME\"/" pyproject.toml
sed -i.bak "s/^version = .*/version = \"$PROJECT_VERSION\"/" pyproject.toml
sed -i.bak "s/^requires-python = .*/requires-python = \">=$PYTHON_VERSION\"/" pyproject.toml
sed -i.bak "s/\"my_project_template\"/\"$PROJECT_NAME_PKG\"/" pyproject.toml
rm pyproject.toml.bak

print_info "- Updating README.md..."
sed -i.bak "s/^# My Project Template/# $PROJECT_NAME/" README.md
rm README.md.bak

# 5. Rename Source Directory
print_info "- Renaming source directory to 'src/$PROJECT_NAME_PKG'..."
mv src/my_project_template "src/$PROJECT_NAME_PKG"

# 6. Initialize `uv` Environment
print_info "- Creating virtual environment with 'uv venv'..."
uv venv -p "python${PYTHON_VERSION}"

print_info "- Installing dependencies with 'uv sync'..."
uv sync --dev

# 7. Clean up
print_info "- Cleaning up initialization script..."
rm -- "$0"

# 8. Final Instructions
print_success "✅ Project setup complete!"
print_info "Next steps:"
print_info "  1. Activate the virtual environment: source .venv/bin/activate"
print_info "  2. Run tests: uv run pytest"
print_info "  3. Check formatting: uv run ruff check ."
print_info "  4. Start coding in 'src/$PROJECT_NAME_PKG'"
