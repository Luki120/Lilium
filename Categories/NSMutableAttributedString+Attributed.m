//
//  NSMutableAttributedString+Attributed.m
//  Lilium
//
//  Created by Luki120 on 3/5/2024.
//  Copyright © 2024 Luki120. All rights reserved.
//

#import "NSMutableAttributedString+Attributed.h"

@implementation NSMutableAttributedString (Attributed)

- (id)initWithFullString:(NSString *)fullString subString:(NSString *)subString {

	NSRange rangeOfSubString = [fullString rangeOfString: subString];
	NSRange rangeOfFullString = { 0, fullString.length };

	UIFont *fullStringFont = [UIFont systemFontOfSize: 18];

	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.alignment = NSTextAlignmentCenter; 
	paragraphStyle.paragraphSpacing = 0.25 * fullStringFont.lineHeight;

	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: fullString];

	[attributedString addAttribute:NSFontAttributeName value:fullStringFont range: rangeOfFullString];
	[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize: 10] range: rangeOfSubString];
	[attributedString addAttribute:NSForegroundColorAttributeName value:UIColor.labelColor range: rangeOfFullString];
	[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor.labelColor colorWithAlphaComponent: 0.5] range: rangeOfSubString];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range: rangeOfFullString];

	return [self initWithAttributedString: attributedString];

}

@end
