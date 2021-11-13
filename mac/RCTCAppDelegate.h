//
//  RCTCAppDelegate.h
//  RCTestCapture
//
//  Created by lim on 13.11.2021.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTCAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

- (id)initWithWindowID:(CGWindowID)windowID;

@end

NS_ASSUME_NONNULL_END
