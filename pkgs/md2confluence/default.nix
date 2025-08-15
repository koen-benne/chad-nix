{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, setuptools
, wheel
, lxml
, markdown
, pymdown-extensions
, pyyaml
, requests
, typing-extensions
, pytestCheckHook
, matplotlib
}:

let
  # json-strong-typing derivation
  json-strong-typing = buildPythonPackage rec {
    pname = "json-strong-typing";
    version = "0.4.0";
    format = "setuptools";

    src = fetchPypi {
      pname = "json_strong_typing";
      inherit version;
      hash = "sha256-vUky1L5KCHJQlu/pUg4beEdXaXuL4QOevtUg7chA62M=";
    };

    nativeBuildInputs = [
      setuptools
      wheel
    ];

    propagatedBuildInputs = [
      typing-extensions
    ];

    doCheck = false;
    pythonImportsCheck = [ ];

    meta = with lib; {
      description = "Type-safe data interchange for Python data classes";
      homepage = "https://pypi.org/project/json-strong-typing/";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = platforms.all;
    };
  };

in buildPythonPackage rec {
  pname = "md2conf";
  version = "1.0.0.dev20250815";  # PEP 440 compliant version format
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hunyadi";
    repo = "md2conf";
    rev = "master";
    hash = "sha256-HSYkbcc9BQxdsz8k/zEoy+j8as269z2gvRQA2mEsm6w=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    json-strong-typing    
    lxml                 
    markdown             
    pymdown-extensions   
    pyyaml              
    requests            
    typing-extensions   
  ];

  # Create our own setup.py and ignore pyproject.toml
  postPatch = ''
    # Remove pyproject.toml to avoid its build requirements
    rm -f pyproject.toml
    
    # Try to get actual version from the package if it exists
    ACTUAL_VERSION="${version}"
    if [ -f md2conf/__init__.py ] && grep -q "__version__" md2conf/__init__.py; then
        ACTUAL_VERSION=$(grep "__version__" md2conf/__init__.py | sed 's/.*"\(.*\)".*/\1/')
        echo "Found version in __init__.py: $ACTUAL_VERSION"
    fi
    
    # Create a simple setup.py based on the project structure
    cat > setup.py << EOF
from setuptools import setup, find_packages

# Find the main package
packages = find_packages()
print(f"Found packages: {packages}")

setup(
    name="md2conf",
    version="$ACTUAL_VERSION",
    description="Publish Markdown files to Confluence wiki",
    author="Levente Hunyadi", 
    url="https://github.com/hunyadi/md2conf",
    packages=packages,
    install_requires=[
        "json_strong_typing >= 0.4",
        "lxml >= 6.0", 
        "markdown >= 3.8",
        "pymdown-extensions >= 10.16",
        "PyYAML >= 6.0",
        "requests >= 2.32",
        "typing-extensions >= 4.14",
    ],
    entry_points={
        "console_scripts": [
            "md2conf=md2conf.__main__:main",
        ],
    },
    python_requires=">=3.9",
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11", 
        "Programming Language :: Python :: 3.12",
    ],
)
EOF
  '';

  doCheck = false;

  pythonImportsCheck = [
    "md2conf"
  ];

  meta = with lib; {
    description = "Publish Markdown files to Confluence Wiki";
    longDescription = ''
      md2conf is a Python package for converting and publishing Markdown files 
      to Confluence wiki pages. It provides tools to convert Markdown syntax 
      to Confluence storage format and can upload content via the Confluence REST API.
      
      Features:
      - Convert Markdown to Confluence storage format
      - Support for tables, code blocks, and other Markdown elements  
      - Direct upload to Confluence via REST API
      - Bulk processing of multiple files
      - Optional formula support with matplotlib
    '';
    homepage = "https://github.com/hunyadi/md2conf";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    mainProgram = "md2conf";
  };
}

