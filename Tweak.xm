#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

static CFStringRef const kSC15PrefsID =
    CFSTR("com.matias.switchcolor15");

static CFStringRef const kSC15ChangedNotification =
    CFSTR("com.matias.switchcolor15/settingschanged");

static UIColor *SC15ColorFromDefaults(void) {

    CFPropertyListRef enabledValue =
        CFPreferencesCopyAppValue(CFSTR("enabled"), kSC15PrefsID);

    BOOL enabled = YES;

    if (enabledValue) {
        enabled = [(__bridge id)enabledValue boolValue];
        CFRelease(enabledValue);
    }

    if (!enabled)
        return [UIColor systemGrayColor];

    CFPropertyListRef presetValue =
        CFPreferencesCopyAppValue(CFSTR("preset"), kSC15PrefsID);

    NSString *preset = nil;

    if (presetValue) {
        id value = (__bridge id)presetValue;

        if ([value isKindOfClass:[NSString class]])
            preset = [value copy];

        CFRelease(presetValue);
    }

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

    if ([preset isEqualToString:@"blue"] || preset == nil) {
        return [UIColor colorWithRed:0.000
                               green:0.478
                                blue:1.000
                               alpha:1.0];
    }

    CFPropertyListRef rValue =
        CFPreferencesCopyAppValue(CFSTR("red"), kSC15PrefsID);

    CFPropertyListRef gValue =
        CFPreferencesCopyAppValue(CFSTR("green"), kSC15PrefsID);

    CFPropertyListRef bValue =
        CFPreferencesCopyAppValue(CFSTR("blue"), kSC15PrefsID);

    CGFloat r = 0.0;
    CGFloat g = 0.48;
    CGFloat b = 1.0;

    if (rValue) {
        r = [(__bridge id)rValue doubleValue] / 255.0;
        CFRelease(rValue);
    }

    if (gValue) {
        g = [(__bridge id)gValue doubleValue] / 255.0;
        CFRelease(gValue);
    }

    if (bValue) {
        b = [(__bridge id)bValue doubleValue] / 255.0;
        CFRelease(bValue);
    }

    return [UIColor colorWithRed:MIN(MAX(r, 0.0), 1.0)
                           green:MIN(MAX(g, 0.0), 1.0)
                            blue:MIN(MAX(b, 0.0), 1.0)
                           alpha:1.0];
}

static UIColor *SC15OffColor(void) {

    CFPropertyListRef value =
        CFPreferencesCopyAppValue(CFSTR("offColor"), kSC15PrefsID);

    NSInteger gray = 72;

    if (value) {
        gray = [(__bridge id)value integerValue];
        CFRelease(value);
    }

    gray = MIN(MAX(gray, 0), 255);

    return [UIColor colorWithWhite:(gray / 255.0)
                             alpha:1.0];
}

static void SC15ApplyToSwitch(UISwitch *sw) {

    CFPropertyListRef enabledValue =
        CFPreferencesCopyAppValue(CFSTR("enabled"), kSC15PrefsID);

    BOOL enabled = YES;

    if (enabledValue) {
        enabled = [(__bridge id)enabledValue boolValue];
        CFRelease(enabledValue);
    }

    if (!enabled)
        return;

    UIColor *active = SC15ColorFromDefaults();

    sw.onTintColor = active;
    sw.thumbTintColor = [UIColor whiteColor];

    if (!sw.isOn)
        sw.tintColor = SC15OffColor();
}

static void SC15WalkView(UIView *view) {

    if ([view isKindOfClass:[UISwitch class]]) {
        SC15ApplyToSwitch((UISwitch *)view);
    }

    for (UIView *subview in view.subviews) {
        SC15WalkView(subview);
    }
}

static void SC15RefreshVisibleSwitches(void) {

    dispatch_async(dispatch_get_main_queue(), ^{

        UIApplication *app = [UIApplication sharedApplication];

        for (UIScene *scene in app.connectedScenes) {

            if (![scene isKindOfClass:[UIWindowScene class]])
                continue;

            UIWindowScene *windowScene =
                (UIWindowScene *)scene;

            for (UIWindow *window in windowScene.windows) {
                SC15WalkView(window);
            }
        }
    });
}

static void SC15PreferencesChanged(
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
) {

    SC15RefreshVisibleSwitches();
}

static void SC15Respring(
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
) {

    dispatch_async(dispatch_get_main_queue(), ^{

        system("killall -9 SpringBoard");
    });
}

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

    %orig(on, animated);

    SC15ApplyToSwitch(self);
}

- (void)setOnTintColor:(UIColor *)color {

    %orig(SC15ColorFromDefaults());
}

- (void)setThumbTintColor:(UIColor *)color {

    %orig([UIColor whiteColor]);
}

%end

%ctor {

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        SC15PreferencesChanged,
        kSC15ChangedNotification,
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        SC15Respring,
        CFSTR("com.matias.switchcolor15/respring"),
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );
}
