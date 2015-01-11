#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"
#define UIColorRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface WallmartBanner : PSTableCell
@end

@implementation WallmartBanner

- (id)initWithStyle:(int)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallmartBannerCell" specifier:specifier];

    if (self) {
        self.backgroundColor = UIColorRGB(74, 74, 74);

        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 206)];
        label.font = [UIFont fontWithName:@"Helvetica-Light" size:60];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"#pantarhei";

        [self addSubview:label];
    }

    return self;
}

@end

@interface WallmartSettingsListController: PSListController { }
@end

@implementation WallmartSettingsListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Wallmart"];

        PSSpecifier *banner = [PSSpecifier preferenceSpecifierNamed:nil
                                                             target:self
                                                                set:NULL
                                                                get:NULL
                                                             detail:Nil
                                                               cell:PSStaticTextCell
                                                               edit:Nil];
        [banner setProperty:[WallmartBanner class] forKey:@"cellClass"];
        [banner setProperty:@"206" forKey:@"height"];

        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:@""];
        [firstGroup setProperty:@"Default album name is 'Wallmart'." forKey:@"footerText"];

        PSSpecifier *enabled = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                              target:self
                                                                 set:@selector(setValue:forSpecifier:)
                                                                 get:@selector(getValueForSpecifier:)
                                                              detail:Nil
                                                                cell:PSSwitchCell
                                                                edit:Nil];
        [enabled setIdentifier:@"enabled"];
        [enabled setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *wallpaperMode = [PSSpecifier preferenceSpecifierNamed:@"Set wallpaper mode"
                                                                    target:self
                                                                       set:@selector(setValue:forSpecifier:)
                                                                       get:@selector(getValueForSpecifier:)
                                                                    detail:[PSListItemsController class]
                                                                      cell:PSLinkListCell
                                                                      edit:Nil];
        [wallpaperMode setIdentifier:@"wallpaperMode"];
        [wallpaperMode setProperty:@(YES) forKey:@"enabled"];
        [wallpaperMode setValues:@[@(0), @(2), @(1)]
                          titles:@[@"Lockscreen and homescreen", @"Lockscreen only", @"Homescreen only"]
                     shortTitles:@[@"Lockscreen and homescreen", @"Lockscreen only", @"Homescreen only"]];

        PSTextFieldSpecifier *albumName = [PSTextFieldSpecifier preferenceSpecifierNamed:nil
                                                                                  target:self
                                                                                     set:@selector(setValue:forSpecifier:)
                                                                                     get:@selector(getValueForSpecifier:)
                                                                                  detail:Nil
                                                                                    cell:PSEditTextCell
                                                                                    edit:Nil];
        [albumName setPlaceholder:@"Enter the name of the album ..."];
        [albumName setIdentifier:@"albumName"];
        [albumName setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:@"contact developer"];
        [secondGroup setProperty:@"Feel free to follow me on twitter for any updates on my apps and tweaks or contact me for support questions.\n \nThis tweak is Open-Source, so make sure to check out my GitHub." forKey:@"footerText"];

        PSSpecifier *twitter = [PSSpecifier preferenceSpecifierNamed:@"twitter"
                                                              target:self
                                                                 set:nil
                                                                 get:nil
                                                              detail:Nil
                                                                cell:PSLinkCell
                                                                edit:Nil];
        twitter.name = @"@biscoditch";
        twitter->action = @selector(openTwitter);
        [twitter setIdentifier:@"twitter"];
        [twitter setProperty:@(YES) forKey:@"enabled"];
        [twitter setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/twitter.png"] forKey:@"iconImage"];

        PSSpecifier *github = [PSSpecifier preferenceSpecifierNamed:@"github"
                                                             target:self
                                                                set:nil
                                                                get:nil
                                                             detail:Nil
                                                               cell:PSLinkCell
                                                               edit:Nil];
        github.name = @"https://github.com/shinvou";
        github->action = @selector(openGithub);
        [github setIdentifier:@"github"];
        [github setProperty:@(YES) forKey:@"enabled"];
        [github setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/github.png"] forKey:@"iconImage"];

        _specifiers = [NSArray arrayWithObjects:banner, firstGroup, enabled, wallpaperMode, albumName, secondGroup, twitter, github, nil];
    }

    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    if ([specifier.identifier isEqualToString:@"enabled"]) {
        if (settings) {
            if ([settings objectForKey:@"enabled"]) {
                return [settings objectForKey:@"enabled"];
            } else {
                return @(YES);
            }
        } else {
            return @(YES);
        }
    } else if ([specifier.identifier isEqualToString:@"wallpaperMode"]) {
        if (settings) {
            if ([settings objectForKey:@"wallpaperMode"]) {
                return [settings objectForKey:@"wallpaperMode"];
            } else {
                return @(0);
            }
        } else {
            return @(0);
        }
    } else if ([specifier.identifier isEqualToString:@"albumName"]) {
        if (settings) {
            if ([settings objectForKey:@"albumName"]) {
                return [settings objectForKey:@"albumName"];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }

    return nil;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];

    if ([specifier.identifier isEqualToString:@"enabled"]) {
        [settings setObject:value forKey:@"enabled"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"wallpaperMode"]) {
        [settings setObject:value forKey:@"wallpaperMode"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"albumName"]) {
        [settings setObject:value forKey:@"albumName"];
        [settings writeToFile:settingsPath atomically:YES];
    }

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadSettings"), NULL, NULL, TRUE);
}

- (void)openTwitter
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=biscoditch"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/biscoditch"]];
    }
}

- (void)openGithub
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/shinvou"]];
}

@end