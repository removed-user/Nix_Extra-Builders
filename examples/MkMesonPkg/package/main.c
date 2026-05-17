#include <stdio.h>
#include <zlib.h>

int main() {
    printf("--- Meson Custom Builder Verification Suite ---\n");
    printf("Zlib Version: %s\n", ZLIB_VERSION);

    // Assert that the compile-time flag was injected successfully
    #ifdef TEST_FEATURE_ENABLED
        printf("Flag Check: SUCCESS (enable_feature is true)\n");
        return 0;
    #else
        printf("Flag Check: FAILED (enable_feature is false or flag missing)\n");
        return 1; 
    #endif
}
