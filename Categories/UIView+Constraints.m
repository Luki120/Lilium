//
//  UIView+Constraints.m
//  Lilium
//
//  Created by Luki120 on 2/15/2022.
//  Copyright © 2022 Luki120. All rights reserved.
//

#import "UIView+Constraints.h"


@implementation UIView (Constraints)

- (void)pinViewToAllEdges:(UIView *)view {

	view.translatesAutoresizingMaskIntoConstraints = NO;
	[NSLayoutConstraint activateConstraints:@[
		[view.topAnchor constraintEqualToAnchor: self.topAnchor],
		[view.bottomAnchor constraintEqualToAnchor: self.bottomAnchor],
		[view.leadingAnchor constraintEqualToAnchor: self.leadingAnchor],
		[view.trailingAnchor constraintEqualToAnchor: self.trailingAnchor]
	]];

}

@end
