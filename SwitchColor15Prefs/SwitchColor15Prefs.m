#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface SwitchColor15Prefs : PSListController
@end

@implementation SwitchColor15Prefs

- (NSArray *)specifiers
{
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root"
                                                  target:self];
    }

    return _specifiers;
}

- (void)respring
{
    pid_t pid;
    const char *args[] = {
        "killall",
        "-9",
        "SpringBoard",
        NULL
    };

    posix_spawn(
        &pid,
        "/usr/bin/killall",
        NULL,
        NULL,
        (char *const *)args,
        NULL
    );
}

@end
