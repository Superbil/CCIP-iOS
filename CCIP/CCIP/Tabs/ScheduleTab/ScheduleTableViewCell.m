//
//  ScheduleTableViewCell.m
//  CCIP
//
//  Created by FrankWu on 2017/7/16.
//  Copyright © 2017年 CPRTeam. All rights reserved.
//

#import "ScheduleTableViewCell.h"
#import "UIColor+addition.h"

@interface ScheduleTableViewCell()

@property (readwrite, nonatomic) BOOL favorite;
@property (strong, nonatomic) NSDictionary *schedule;
@property (readwrite, nonatomic) BOOL disabled;

@end

@implementation ScheduleTableViewCell

static NSDateFormatter *formatter_full = nil;
static NSDateFormatter *formatter_date = nil;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (formatter_full == nil) {
        formatter_full = [NSDateFormatter new];
        [formatter_full setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    if (formatter_date == nil) {
        formatter_date = [NSDateFormatter new];
        [formatter_date setDateFormat:@"HH:mm"];
        [formatter_date setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    }
    [self.LabelLabel setTextColor:[UIColor colorFromHtmlColor:@"#9B9B9B"]];
    [self.LabelLabel setBackgroundColor:[UIColor colorFromHtmlColor:@"#D8D8D8"]];
    [self.FavoriteButton setTintColor:[UIColor colorFromHtmlColor:@"#50E3C2"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getID {
    if (self.schedule) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(getID:)]) {
                return [self.delegate getID:_schedule];
            }
        }
        return @"";
    } else {
        return @"";
    }
}

- (void)setSchedule:(NSDictionary *)schedule {
    _schedule = schedule;
    NSDate *startTime = [formatter_full dateFromString:[_schedule objectForKey:@"start"]];
    NSDate *endTime = [formatter_full dateFromString:[_schedule objectForKey:@"end"]];
    long mins = [[NSNumber numberWithDouble:([endTime timeIntervalSinceDate:startTime] / 60)] longValue];
    NSString *lang = [_schedule objectForKey:@"lang"];
    [self.ScheduleTitleLabel setText:[_schedule objectForKey:@"subject"]];
    [self.RoomLocationLabel setText:[NSString stringWithFormat:@"Room %@ - %ld mins", [_schedule objectForKey:@"room"], mins]];
    [self.LabelLabel setText:[NSString stringWithFormat:@"   %@   ", lang]];
    [self.LabelLabel.layer setCornerRadius:self.LabelLabel.frame.size.height / 2];
    [self.LabelLabel sizeToFit];
    [self.LabelLabel setHidden:[lang length] == 0];
    [self setFavorite:NO];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(hasFavorite:)]) {
            [self setFavorite:[self.delegate hasFavorite:[self getID]]];
        }
    }
}

- (NSDictionary *)getSchedule {
    return _schedule;
}

- (IBAction)favoriteAction:(id)sender {
    self.favorite = !self.favorite;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(actionFavorite:)]) {
            [self.delegate actionFavorite:[self getID]];
        }
    }
}

- (void)setFavorite:(BOOL)favorite {
    _favorite = favorite;
    [self.FavoriteButton setTitle:_favorite ? FAVORITE_LIKE : FAVORITE_DISLIKE
                         forState:UIControlStateNormal];
}

- (BOOL)getFavorite {
    return _favorite;
}

- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
    [self.ScheduleTitleLabel setAlpha:_disabled ? .2f : 1];
}

- (BOOL)getDisabled {
    return _disabled;
}

@end
