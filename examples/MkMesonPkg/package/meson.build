project('builder-test-suite', 'c',
  version: '1.0.0',
  default_options: ['c_std=c11']
)

# 1. Test Dependency Resolution (verifies nix's build inputs / pkg-config paths)
zlib_dep = dependency('zlib', required: true)

# 2. Test Compile Time Flag Processing
c_args = []
if get_option('enable_feature')
  c_args += '-DTEST_FEATURE_ENABLED=1'
endif

# 3. Target Executable
exe = executable('test_app', 
  'main.c',
  dependencies: zlib_dep,
  c_args: c_args,
  install: true
)

# 4. Test Phase Functionality (verifies your builder's 'checkPhase' / 'meson test')
test('functional_check', exe)
