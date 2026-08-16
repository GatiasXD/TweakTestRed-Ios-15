#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

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
    system("killall -9 SpringBoard");
}

@end
