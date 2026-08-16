#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

static CFStringRef const kSC15PrefsID =
    CFSTR("com.matias.switchcolor15");

static CFStringRef const kSC15ChangedNotification =
    CFSTR("com.matias.switchcolor15/settingschanged");

#pragma mark - Color

static UIColor *SC15ActiveColor(void) {
    CFPropertyListRef presetRef =
        CFPreferencesCopyAppValue(CFSTR("preset"), kSC15PrefsID);

    NSString *preset = nil;

    if (presetRef) {
        id value = (__bridge id)presetRef;

        if ([value isKindOfClass:[NSString class]]) {
            preset = [(NSString *)value copy];
        }

        CFRelease(presetRef);
    }

    // Colores predefinidos
    if ([preset isEqualToString:@"red"]) {
        return [UIColor colorWithRed:1.0
                               green:0.231
                                blue:0.188
                               alpha:1.0];
    }

    if ([preset isEqualToString:@"green"]) {
        return [UIColor colorWithRed:0.204
                               green:0.780
                                blue:0.349
                               alpha:1.0];
    }

    if ([preset isEqualToString:@"purple"]) {
        return [UIColor colorWithRed:0.686
                               green:0.322
                                blue:0.871
                               alpha:1.0];
    }

    if ([preset isEqualToString:@"blue"]) {
        return [UIColor colorWithRed:0.000
                               green:0.478
                                blue:1.000
                               alpha:1.0];
    }

    // Personalizado
    CFPropertyListRef rRef =
        CFPreferencesCopyAppValue(CFSTR("red"), kSC15PrefsID);

    CFPropertyListRef gRef =
        CFPreferencesCopyAppValue(CFSTR("green"), kSC15PrefsID);

    CFPropertyListRef bRef =
        CFPreferencesCopyAppValue(CFSTR("blue"), kSC15PrefsID);

    CGFloat r = 0.0;
    CGFloat g = 0.478;
    CGFloat b = 1.0;

    if (rRef) {
        id value = (__bridge id)rRef;

        if ([value respondsToSelector:@selector(doubleValue)]) {
            r = [value doubleValue] / 255.0;
        }

        CFRelease(rRef);
    }

    if (gRef) {
        id value = (__bridge id)gRef;

        if ([value respondsToSelector:@selector(doubleValue)]) {
            g = [value doubleValue] / 255.0;
        }

        CFRelease(gRef);
    }

    if (bRef) {
        id value = (__bridge id)bRef;

        if ([value respondsToSelector:@selector(doubleValue)]) {
            b = [value doubleValue] / 255.0;
        }

        CFRelease(bRef);
    }

    r = MIN(MAX(r, 0.0), 1.0);
    g = MIN(MAX(g, 0.0), 1.0);
    b = MIN(MAX(b, 0.0), 1.0);

    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:1.0];
}

static UIColor *SC15ThumbColor(void) {
    return [UIColor whiteColor];
}

static UIColor *SC15OffColor(void) {
    return [UIColor colorWithWhite:0.72 alpha:1.0];
}

#pragma mark - Switch

static void SC15ApplyToSwitch(UISwitch *switchControl) {
    if (!switchControl) {
        return;
    }

    UIColor *activeColor = SC15ActiveColor();

    switchControl.onTintColor = activeColor;
    switchControl.thumbTintColor = SC15ThumbColor();

    if (!switchControl.isOn) {
        switchControl.tintColor = SC15OffColor();
    }
}

#pragma mark - Recursive refresh

static void SC15RefreshView(UIView *view) {
    if (!view) {
        return;
    }

    if ([view isKindOfClass:[UISwitch class]]) {
        SC15ApplyToSwitch((UISwitch *)view);
    }

    for (UIView *subview in view.subviews) {
        SC15RefreshView(subview);
    }
}

static void SC15RefreshWindows(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application =
            [UIApplication sharedApplication];

        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in application.connectedScenes) {

                if (![scene isKindOfClass:[UIWindowScene class]]) {
                    continue;
                }

                UIWindowScene *windowScene =
                    (UIWindowScene *)scene;

                for (UIWindow *window in windowScene.windows) {
                    SC15RefreshView(window);
                }
            }
        } else {
            for (UIWindow *window in application.windows) {
                SC15RefreshView(window);
            }
        }
    });
}

#pragma mark - Preferences notification

static void SC15PreferencesChanged(
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
) {
    SC15RefreshWindows();
}

#pragma mark - UISwitch hooks

%hook UISwitch

- (void)layoutSubviews {
    %orig;

    SC15ApplyToSwitch(self);
}

- (void)didMoveToWindow {
    %orig;

    SC15ApplyToSwitch(self);
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    %orig;

    SC15ApplyToSwitch(self);
}

%end

#pragma mark - Constructor

%ctor {
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        SC15PreferencesChanged,
        kSC15ChangedNotification,
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            (int64_t)(1.0 * NSEC_PER_SEC)
        ),
        dispatch_get_main_queue(),
        ^{
            SC15RefreshWindows();
        }
    );
}
