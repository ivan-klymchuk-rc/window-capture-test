//
//  RCTCAppDelegate.m
//  RCTestCapture
//
//  Created by lim on 13.11.2021.
//

#import "RCTCAppDelegate.h"

@interface RCTCAppDelegate ()

@property CGWindowID windowID;
@property NSImageView *imageView;
@property NSTimer *timer;

@end

@implementation RCTCAppDelegate

- (id)init {
    self = [super init];
    if (self) {
        NSRect mainDisplayRect = [[NSScreen mainScreen] frame];

        NSRect windowRect = NSMakeRect(mainDisplayRect.origin.x + (mainDisplayRect.size.width) * 0.25,
                                       mainDisplayRect.origin.y + (mainDisplayRect.size.height) * 0.25,
                                       mainDisplayRect.size.width * 0.5,
                                       mainDisplayRect.size.height * 0.5);
        NSRect imageViewRect = NSMakeRect(2, 2, windowRect.size.width - 4, windowRect.size.height - 4);

        NSInteger windowLevel = NSNormalWindowLevel + 1;
        window = [[NSWindow alloc] initWithContentRect:windowRect
                                             styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable
                                               backing:NSBackingStoreBuffered
                                                 defer:NO];
        [window setLevel:windowLevel];
        [window setBackgroundColor:[NSColor darkGrayColor]];
        self.imageView = [[NSImageView alloc] initWithFrame:imageViewRect];
        [window.contentView addSubview:self.imageView];

    }
    return self;
}

- (id)initWithWindowID:(CGWindowID)windowID {
    self = [self init];
    self.windowID = windowID;
    return self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [window makeKeyAndOrderFront:self];
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self refreshCapture];
    }];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)refreshCapture {
    NSDictionary *windowDescription = [self windowsDictionary][@(self.windowID)];
    NSDictionary *boundsDict = windowDescription[(NSString *)kCGWindowBounds];
    CGRect bounds;
    CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)boundsDict , &bounds);
    CGImageRef windowImage = CGWindowListCreateImage(bounds, kCGWindowListOptionIncludingWindow, self.windowID, kCGWindowImageDefault);
    if (!windowImage) {
        [[NSApplication sharedApplication] terminate:self];
    }
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:windowImage];
    CGImageRelease(windowImage);
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:bitmapRep];
    [self.imageView setImage:image];
}

- (NSDictionary *)windowsDictionary {
    CGWindowListOption options = kCGWindowListExcludeDesktopElements | kCGWindowListOptionOnScreenOnly;
    CFArrayRef windowCFArray = CGWindowListCopyWindowInfo(options, kCGNullWindowID);
    NSArray *windowArray = CFBridgingRelease(windowCFArray);
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:windowArray.count];
    for (NSDictionary *windowDescription in windowArray) {
        NSNumber *windowNumber = windowDescription[(NSString *)kCGWindowNumber];
        result[windowNumber] = windowDescription;
    }
    return result;
}

@end
