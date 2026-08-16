#import <UIKit/UIKit.h>

// =============================
// SwitchColor15
// iOS 15 / Dopamine / Rootless
// =============================

// Choose your active switch color here.
// Blue: UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0
// Red : UIColor colorWithRed:1.0 green:0.23 blue:0.23 alpha:1.0

static UIColor *SC15ActiveColor(void) {
    return [UIColor colorWithRed:1.0 green:0.23 blue:0.23 alpha:1.0];
}

static UIColor *SC15ThumbColor(void) {
    return [UIColor whiteColor];
}

static UIColor *SC15OffTrackColor(void) {
    return [UIColor colorWithWhite:0.72 alpha:1.0];
}

%hook UISwitch

- (void)layoutSubviews {
    %orig;

    // iOS uses onTintColor for the filled track when the switch is ON.
    self.onTintColor = SC15ActiveColor();
    self.thumbTintColor = SC15ThumbColor();

    // tintColor affects the inactive appearance while preserving the
    // standard UISwitch behavior and animation.
    if (!self.isOn) {
        self.tintColor = SC15OffTrackColor();
    }
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    %orig(on, animated);
    self.onTintColor = SC15ActiveColor();
    self.thumbTintColor = SC15ThumbColor();
    if (!on) {
        self.tintColor = SC15OffTrackColor();
    }
}

%end
