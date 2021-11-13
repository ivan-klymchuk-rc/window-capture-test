//
//  main.m
//  RCTestCapture
//
//  Created by lim on 13.11.2021.
//

#import "RCTCAppDelegate.h"

void printWindows(void) {
    CGWindowListOption options = kCGWindowListExcludeDesktopElements | kCGWindowListOptionOnScreenOnly;
    CFArrayRef windowCFArray = CGWindowListCopyWindowInfo(options, kCGNullWindowID);
    NSArray *windowArray = CFBridgingRelease(windowCFArray);
    for (NSDictionary *windowDescription in windowArray) {
        NSString *windowInfo = [NSString stringWithFormat:@"%@ - %@", windowDescription[(NSString *)kCGWindowNumber], windowDescription[(NSString *)kCGWindowOwnerName]];
        printf("%s\n", windowInfo.UTF8String);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            printf("Usage: RCTestCapture windowId\n");
            printf("List of available windows:\n");
            printWindows();
            return 0;
        }
        printf("Capturing window %s\n", argv[1]);
        CGWindowID windowID = (CGWindowID) strtol(argv[1], NULL, 10);
        NSApplication *app = [NSApplication sharedApplication];
        [app setDelegate:[[RCTCAppDelegate alloc] initWithWindowID:windowID]];
        [app run];
    }
    return 0;
}
