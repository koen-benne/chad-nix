# Example usage of nixgl-desktop module
# Add this to your host configuration to enable nixGL-wrapped desktop entries

{
  # Enable the nixGL desktop entries module
  my.nixgl-desktop.enable = true;
  
  # Configure applications that need nixGL wrapping
  my.nixgl-desktop.applications = {
    # Example: Firefox with nixGL
    firefox = {
      name = "Firefox (nixGL)";
      exec = "firefox";
      icon = "firefox";
      comment = "Firefox web browser with hardware acceleration";
      categories = ["Network" "WebBrowser"];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      nixGLVariant = "nixGLIntel"; # or "nixGLNvidia" or "nixGLMesa"
    };
    
    # Example: VS Code with nixGL
    vscode = {
      name = "Visual Studio Code (nixGL)";
      exec = "code";
      icon = "code";
      comment = "Code editor with hardware acceleration";
      categories = ["Development" "TextEditor"];
      nixGLVariant = "nixGLIntel";
    };
    
    # Example: Steam with nixGL (needs Nvidia variant typically)
    steam = {
      name = "Steam (nixGL)";
      exec = "steam";
      icon = "steam";
      comment = "Steam gaming platform with hardware acceleration";
      categories = ["Game"];
      nixGLVariant = "nixGLNvidia"; # Usually needs Nvidia variant for gaming
    };
  };
}