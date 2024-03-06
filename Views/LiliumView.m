#import "LiliumView.h"


@interface LiliumView () <UITextFieldDelegate>
@end


@implementation LiliumView {

	UILabel *_mainLabel;
	UIStackView *_textFieldsStackView;
	UIButton *_swapButton;
	UIButton *_dismissButton;
	UITextField *_degRadTextField;
	UITextField *_resultsTextField;
	NSString *_mainString;
	NSString *_formulaString;
	NSString *_placeholderString;

}

static NSString *const degreesFormulaString = @"Formula ⇝ deg * π/180";
static NSString *const radiansFormulaString = @"Formula ⇝ rad * 180/π";

static UITextField *theTextField;
static BOOL isDegreesToRadians = YES;

#define π M_PI

// ! Lifecycle

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self _setupUI];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_fadeIn) name:LiliumDidFadeInNotification object:nil];

	return self;

}

// ! Private

- (void)_setupUI {

	self.alpha = 0;
	self.hidden = YES;
	self.layer.cornerCurve = kCACornerCurveContinuous;
	self.layer.cornerRadius = 12;
	self.layer.masksToBounds = YES;
	self.translatesAutoresizingMaskIntoConstraints = NO;

	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle: UIBlurEffectStyleSystemUltraThinMaterial]];
	[self addSubview: visualEffectView];
	[self pinViewToAllEdges: visualEffectView];

	[self _checkIfRadiansOrDegrees];

	if(!_mainLabel) {
		_mainLabel = [UILabel new];
		_mainLabel.numberOfLines = 0;
		_mainLabel.attributedText = [[NSMutableAttributedString alloc] initWithFullString:_mainString subString: _formulaString];
		_mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview: _mainLabel];
	}

	if(!_textFieldsStackView) {
		_textFieldsStackView = [UIStackView new];
		_textFieldsStackView.axis = UILayoutConstraintAxisVertical;
		_textFieldsStackView.spacing = 10;
		_textFieldsStackView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview: _textFieldsStackView];
	}

	if(!_degRadTextField) _degRadTextField = [self _createTextFieldWithPlaceholder: _placeholderString];
	if(!_resultsTextField) _resultsTextField = [self _createTextFieldWithPlaceholder: @"Result:"];

	if(!_swapButton) _swapButton = [self _createButtonWithImage:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath"]
		selector:@selector(_didTapSwapButton)
	];
	if(!_dismissButton) _dismissButton = [self _createButtonWithImage:[UIImage systemImageNamed:@"xmark"]
		selector:@selector(_didDismiss)
	];

	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_didDismiss)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[self addGestureRecognizer: swipeRecognizer];

	[self _layoutUI];

}


- (void)_layoutUI {

	[NSLayoutConstraint activateConstraints:@[
		[_mainLabel.topAnchor constraintEqualToAnchor: self.topAnchor constant: 15],
		[_mainLabel.centerXAnchor constraintEqualToAnchor: self.centerXAnchor],

		[_textFieldsStackView.topAnchor constraintEqualToAnchor: _mainLabel.bottomAnchor constant: 15],
		[_textFieldsStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10],

		[_swapButton.centerYAnchor constraintEqualToAnchor: _mainLabel.centerYAnchor],
		[_swapButton.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10],

		[_dismissButton.centerYAnchor constraintEqualToAnchor: _mainLabel.centerYAnchor],
		[_dismissButton.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -10]
	]];

}

// ! Selectors

- (void)_didDismiss {

	[self _animateViewWithView:self alpha:0 completion:^(BOOL finished) {

		self.hidden = YES;

		_degRadTextField.text = @"";
		_resultsTextField.text = @"";

	}];

	[_degRadTextField resignFirstResponder];

}


- (void)_didTapSwapButton {

	isDegreesToRadians = !isDegreesToRadians;
	[self _checkIfRadiansOrDegrees];

}


- (void)_fadeIn {

	self.hidden = NO;
	[self _animateViewWithView:self alpha:1 completion: nil];

	[_degRadTextField becomeFirstResponder];

}

// ! Logic

- (void)_checkIfRadiansOrDegrees {

	_mainString = isDegreesToRadians
		? [@"Degrees to radians\n" stringByAppendingString: degreesFormulaString]
		: [@"Radians to degrees\n" stringByAppendingString: radiansFormulaString];

	_formulaString = isDegreesToRadians ? degreesFormulaString : radiansFormulaString;
	_placeholderString = [NSString stringWithFormat: @"Enter %@", isDegreesToRadians ? @"degrees:" : @"radians:"];

	NSString *result = [NSString stringWithFormat: @"%@", _degRadTextField.text];
	float castedResult = [result floatValue];

	NSString *degreesResult = [NSString stringWithFormat: @"%0.f°", castedResult * (180 / π)];
	NSString *radiansResult = [NSString stringWithFormat: @"%0.3f rad", castedResult * (π / 180)];
	NSString *resultsString = isDegreesToRadians ? radiansResult : degreesResult;

	[UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		_mainLabel.attributedText = [[NSMutableAttributedString alloc] initWithFullString:_mainString subString: _formulaString];
		_degRadTextField.placeholder = _placeholderString;
		_resultsTextField.text = resultsString;

		if(_degRadTextField.text.length < 1 || _resultsTextField.text.length < 1) _resultsTextField.text = @"";

	} completion: nil];

}

// ! Reusable

- (UITextField *)_createTextFieldWithPlaceholder:(NSString *)placeholder {

	UITextField *textField = [UITextField new];
	textField.font = [UIFont systemFontOfSize: 14];
	textField.delegate = self;
	textField.placeholder = placeholder;
	textField.returnKeyType = UIReturnKeyDone;
	textField.translatesAutoresizingMaskIntoConstraints = NO;
	[_textFieldsStackView addArrangedSubview: textField];
	return textField;

}


- (UIButton *)_createButtonWithImage:(UIImage *)image selector:(SEL)selector {

	UIButton *button = [UIButton new];
	button.tintColor = UIColor.labelColor;
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[button setImage:image forState: UIControlStateNormal];
	[button addTarget:self action:selector forControlEvents: UIControlEventTouchUpInside];
	[self addSubview: button];
	return button;

}


- (void)_animateViewWithView:(UIView *)view alpha:(CGFloat)alpha completion:(void(^)(BOOL completion))completion {

	[UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		view.alpha = alpha;

	} completion: completion];

}

// ! UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

	theTextField = textField;
	return YES;

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	if(textField == _degRadTextField) [self _checkIfRadiansOrDegrees];
	[textField resignFirstResponder];
	return YES;

}

@end
