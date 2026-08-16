#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#include <spawn.h>
#include <sys/wait.h>

@interface SwitchColor15PrefsListController : PSListController
@end

@implementation SwitchColor15PrefsListController

- (NSArray *)specifiers {
    if (!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    return _specifiers;
}

- (void)postChange {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.matias.switchcolor15/settingschanged"), NULL, NULL, true);
}

- (void)respring {
    pid_t pid;
    const char *argv[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)argv, NULL);
    waitpid(pid, NULL, 0);
}

@end
