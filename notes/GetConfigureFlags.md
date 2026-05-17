# Comprehensive Build Options Discovery Snippets

# Meson 
## Meson Introspection (JSON Format)
Sets up a mock build folder, evaluates all conditional logic, and outputs a structured JSON array of every valid option, choice, and default.
```bash
meson setup build_dump && meson introspect build_dump --buildoptions
```

# CMake 
## CMake Cache Evaluation
Generates the internal CMake cache and dumps all defined variables, along with their data types and human-readable help descriptions.
```bash
cmake -S . -B build_dump -LAH
```

# Autotools

## GNU Autotools Flag Extraction
Queries standard GNU configuration scripts for all officially supported compilation feature toggles and external package hooks.
```bash
./configure --help | grep -E "(--enable-|--with-)"
```

# Macro Scan
## C Preprocessor Macro Scan (Universal Fallback)
Bypasses the build system entirely to extract every conditional preprocessor directive used inside the source code files.
```bash
rg -INo "#if(def|ndef)?\s+([A-Z0-9_]+)" --replace '\$2' | sort -u
rg -INo "#if(def|ndef)?\s+([A-Z0-9_]+)" --replace '$2' | sort -u
```

# Compiler Interception
## Compiler Call Interception (Using Bear)

Executes any arbitrary build script or raw Makefile and intercepts every exact flag passed to the compiler, saving them into a unified JSON file.
```bash
bear -- make
cat compile_commands.json
```
