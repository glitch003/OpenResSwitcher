/*
 * COMPILE:
 *    c++ setgetscreenres.m -framework ApplicationServices -o setgetscreenres
 * USE:
 *    setgetscreenres <modeId>
 */

#include <ApplicationServices/ApplicationServices.h>

bool changeMode (CGDirectDisplayID display, int newModeId);
void printMode (CGDisplayModeRef mode);
void printAllModes (CGDirectDisplayID display);

int main (int argc, const char * argv[])
{
    int newModeId;                          // possible modeId
    
    CGDirectDisplayID mainDisplay = CGMainDisplayID();  // ID of main display
    
    if (argc == 1){
        CGDisplayModeRef currentMode = CGDisplayCopyDisplayMode(mainDisplay);
        printf("Current resolution is ");
        printMode(currentMode);
        CGDisplayModeRelease(currentMode);
        
        printf("\n\nAvailable modes are: \n");
        printAllModes(mainDisplay);
        
    }
        
    
    if (argc != 2 || !(newModeId = atoi(argv[1]))) {
        fprintf(stderr, "\nUsage: %s <modeId>\n", argv[0]);
        fprintf(stderr, "Pick a mode ID number from the list of available modes printed above.\n");
        return -1;
    }
    
    
    
    if (! changeMode(mainDisplay, newModeId)) {
        fprintf(stderr, "Error changing resolution\n");
        return 1;
    }

    return 0;
}

bool changeMode (CGDirectDisplayID display, int newModeId)
{
    // get mode to switch to
    CFArrayRef allModes = CGDisplayCopyAllDisplayModes(display, NULL);
    if (newModeId < 0 || newModeId > CFArrayGetCount(allModes) - 1){
        printf("Enter a valid modeId\n");
        return false;
    }
    
    CGDisplayModeRef newMode = CFArrayGetValueAtIndex(allModes, newModeId);
    
    CGDisplayConfigRef config;
    if (CGBeginDisplayConfiguration(&config) == kCGErrorSuccess) {
        CGConfigureDisplayWithDisplayMode(config, display, newMode, NULL);
        // old
        // CGConfigureDisplayMode(config, display, mode);
        CGCompleteDisplayConfiguration(config, kCGConfigureForSession );
        return true;
    }
    return false;
}


void printAllModes(CGDirectDisplayID display){
    CFArrayRef allModes = CGDisplayCopyAllDisplayModes(display, NULL);
    
    for(int i = 0; i < CFArrayGetCount(allModes); i++){
        CGDisplayModeRef mode = CFArrayGetValueAtIndex(allModes, i);
        printMode(mode);
        printf("\t modeId %d\n", i);
        CGDisplayModeRelease(mode);
    }

}


void printMode(CGDisplayModeRef mode){
    size_t width = CGDisplayModeGetWidth(mode);
    size_t height = CGDisplayModeGetHeight(mode);
    double refreshRate = CGDisplayModeGetRefreshRate(mode);
    printf("%zu x %zu @ %f hz", width, height, refreshRate);
}
