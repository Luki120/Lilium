@import UIKit;
#import <objc/runtime.h>
#import "Views/LiliumView.h"


static LiliumView *liliumView;

static void swizzleOnClass(Class cls, SEL origSEL, SEL swzSEL) {

	Class class = cls;

	SEL originalSEL = origSEL;
	SEL swizzledSEL = swzSEL;

	Method originalMethod = class_getInstanceMethod(class, originalSEL);
	Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);

	IMP originalIMP = method_getImplementation(originalMethod);
	IMP swizzledIMP = method_getImplementation(swizzledMethod);

	class_replaceMethod(class, swizzledSEL, originalIMP, method_getTypeEncoding(originalMethod));
	class_replaceMethod(class, originalSEL, swizzledIMP, method_getTypeEncoding(swizzledMethod));

}


@interface SBHomeScreenViewController : UIViewController
@end


@interface SBHomeScreenViewController (Lilium)
@end


@implementation SBHomeScreenViewController (Lilium)

+ (void)load {

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{

		swizzleOnClass(self, @selector(viewDidLoad), @selector(lil_viewDidLoad));

	});

}


- (void)lil_viewDidLoad {

	[self lil_viewDidLoad];

	liliumView = [LiliumView new];
	[self.view addSubview: liliumView];

	[NSLayoutConstraint activateConstraints:@[
		[liliumView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 30],
		[liliumView.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor],
		[liliumView.widthAnchor constraintEqualToConstant: 295],
		[liliumView.heightAnchor constraintEqualToConstant: 130]
	]];

}

@end


@interface SBDockView : UIView
@end


@interface SBDockView (Lilium)
@end


@implementation SBDockView (Lilium)

+ (void)load {

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{

		swizzleOnClass(self, @selector(didMoveToSuperview), @selector(lil_didMoveToSuperview));

	});

}


- (void)lil_didMoveToSuperview {

	[self lil_didMoveToSuperview];

	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lil_didSwipeUp)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[self addGestureRecognizer: swipeRecognizer];

}


- (void)lil_didSwipeUp {

	if(liliumView.alpha == 1 || !liliumView.hidden) return;
	[NSNotificationCenter.defaultCenter postNotificationName:@"fadeIn" object:nil];

}

@end
