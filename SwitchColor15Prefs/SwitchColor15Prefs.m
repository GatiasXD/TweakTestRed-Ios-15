#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CoreFoundation/CoreFoundation.h>

@interface SwitchColor15Prefs : PSListController
@end

@implementation SwitchColor15Prefs

- (NSArray *)specifiers
{
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root"
                                                  target:self];
    }

    return _specifiers;
}

- (void)respring
{
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.matias.switchcolor15/respring"),
        NULL,
        NULL,
        true
    );
}

@end
