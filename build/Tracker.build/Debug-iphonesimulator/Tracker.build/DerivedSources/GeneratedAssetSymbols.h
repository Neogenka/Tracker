#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "1" asset catalog image resource.
static NSString * const ACImageName1 AC_SWIFT_PRIVATE = @"1";

/// The "2" asset catalog image resource.
static NSString * const ACImageName2 AC_SWIFT_PRIVATE = @"2";

/// The "Star" asset catalog image resource.
static NSString * const ACImageNameStar AC_SWIFT_PRIVATE = @"Star";

/// The "Statistic" asset catalog image resource.
static NSString * const ACImageNameStatistic AC_SWIFT_PRIVATE = @"Statistic";

/// The "Tracker" asset catalog image resource.
static NSString * const ACImageNameTracker AC_SWIFT_PRIVATE = @"Tracker";

/// The "ic 24x24" asset catalog image resource.
static NSString * const ACImageNameIc24X24 AC_SWIFT_PRIVATE = @"ic 24x24";

/// The "plus" asset catalog image resource.
static NSString * const ACImageNamePlus AC_SWIFT_PRIVATE = @"plus";

/// The "splash_screen_logo" asset catalog image resource.
static NSString * const ACImageNameSplashScreenLogo AC_SWIFT_PRIVATE = @"splash_screen_logo";

#undef AC_SWIFT_PRIVATE
