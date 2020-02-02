/*
 * COMPILE:
 *    c++ setgetscreenres.m -framework ApplicationServices -o setgetscreenres
 * USE:
 *    setgetscreenres 1440 900
 */

#include <ApplicationServices/ApplicationServices.h>

bool changeMode (CGDirectDisplayID display, CFDictionaryRef mode);

int main (int argc, const char * argv[])
{
    int h;                          // horizontal resolution
    int v;                          // vertical resolution
    CFDictionaryRef switchMode;     // mode to switch to
    CGDirectDisplayID mainDisplay = CGMainDisplayID();  // ID of main display

//    CFDictionaryRef CGDisplayCurrentMode(CGDirectDisplayID display);

    

    if (argc == 1) {
        CGDisplayModeRef currentMode = CGDisplayCopyDisplayMode(mainDisplay);
//        CGRect screenFrame = CGDisplayBounds(kCGDirectMainDisplay);
//        CGSize screenSize  = screenFrame.size;
        size_t width = CGDisplayModeGetWidth(currentMode);
        size_t height = CGDisplayModeGetHeight(currentMode);
        printf("%zu %zu\n", width, height);
        return 0;
    }
    if (argc != 3 || !(h = atoi(argv[1])) || !(v = atoi(argv[2])) ) {
        fprintf(stderr, "Usage: %s horizontal vertical\n", argv[0]);
        return -1;
    }

    switchMode = CGDisplayBestModeForParameters(mainDisplay, 32, h, v, NULL);

    if (! changeMode(mainDisplay, switchMode)) {
        fprintf(stderr, "Error changing resolution to %d %d\n", h, v);
        return 1;
    }

    return 0;
}

bool changeMode (CGDirectDisplayID display, CFDictionaryRef mode)
{
    CGDisplayConfigRef config;
    if (CGBeginDisplayConfiguration(&config) == kCGErrorSuccess) {
        CGConfigureDisplayWithDisplayMode(config, display, mode, NULL);
        // old
        // CGConfigureDisplayMode(config, display, mode);
        CGCompleteDisplayConfiguration(config, kCGConfigureForSession );
        return true;
    }
    return false;
}

