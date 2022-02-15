//
//  UIView+Constraints.m
//  Swizzle
//
//  Created by Luki120 on 2/15/2022.
//  Copyright © 2022 Luki120. All rights reserved.
//

#import "UIView+Constraints.h"


@implementation UIView (Constraints)


- (void)pinViewToAllEdges:(UIView *)view {

	view.translatesAutoresizingMaskIntoConstraints = NO;

	[NSLayoutConstraint activateConstraints:@[
		[self.topAnchor constraintEqualToAnchor: view.topAnchor],
		[self.bottomAnchor constraintEqualToAnchor: view.bottomAnchor],
		[self.leadingAnchor constraintEqualToAnchor: view.leadingAnchor],
		[self.trailingAnchor constraintEqualToAnchor: view.trailingAnchor]
	]];

}


@end
