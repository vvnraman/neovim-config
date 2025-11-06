import subprocess
from pathlib import Path

import typer

PROJECT_NAME = "nvim-config"
CURRENT_FILE = Path(__file__)
PROJECT_DIR = CURRENT_FILE.parent.parent.parent
DOCS_DIR = (PROJECT_DIR / "docs").relative_to(PROJECT_DIR)
BUILD_DIR = DOCS_DIR / "_build"
HTML_DIR = BUILD_DIR / "html"

A: str = "══"
B: str = "──"
C: str = "┄┄"
S: str = " "
E: str = " "

app = typer.Typer()


@app.command()
def info():
    print(f"{A} Project         = {PROJECT_NAME}")
    print(f"{B} Project dir     = {PROJECT_DIR}")
    print(f"{B} Docs dir        = {DOCS_DIR}")
    print(f"{B} Build dir       = {BUILD_DIR}")
    print(f"{B} HTML dir        = {HTML_DIR}")


@app.command()
def docs():
    print(f"{A} Building docs for {PROJECT_NAME}")
    args = ["sphinx-build", "--builder", "html", str(DOCS_DIR), str(BUILD_DIR)]
    _ = subprocess.run(args)


@app.command()
def live():
    print(f"{A} Building livedocs for {PROJECT_NAME}")
    args = ["sphinx-autobuild", "--port", "0", str(DOCS_DIR), str(HTML_DIR)]
    _ = subprocess.run(args)


@app.command()
def clean():
    print(f"{A} Cleaning docs for {PROJECT_NAME}")
    args = ["sphinx-build", "-M", "clean", str(DOCS_DIR), str(BUILD_DIR)]
    _ = subprocess.run(args)


@app.command()
def init_docs():
    print(f"{A} Setting up sphinx docs structure for {PROJECT_NAME}")
    sphinx_files = [DOCS_DIR / "conf.py", DOCS_DIR / "index.rst"]
    if all([file.exists() for file in sphinx_files]):
        print(f"{E} sphinx files already exists at '{str(DOCS_DIR)}'")
        return
    args = [
        "sphinx-quickstart",
        "--quiet",
        "--no-sep",
        "--project",
        "Prateek's Neovim config",
        "--author",
        "Prateek Raman",
        "--release",
        "0.1.0",
        str(DOCS_DIR),
    ]
    _ = subprocess.run(args)


if __name__ == "__main__":
    app()
