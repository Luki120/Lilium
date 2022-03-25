#import "LiliumView.h"


@implementation LiliumView {

	UILabel *liliumMainLabel;
	UILabel *formulaLabel;
	UIStackView *mainLabelsStackView;
	UIStackView *textFieldsStackView;
	UIButton *swapButton;
	UIButton *dismissButton;
	UITextField *degRadTextField;
	UITextField *resultsTextField;
	NSString *calculatorString;
	NSString *formulaString;
	NSString *placeholderString;

}

static UITextField *theTextField;
static BOOL isDegreesToRadians = YES;

// ! Lifecycle

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self setupViews];
	[self setupObservers];

	return self;

}


- (void)setupObservers {

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fadeIn) name:@"fadeIn" object:nil];

}


- (void)setupViews {

	self.alpha = 0;
	self.hidden = YES;
	self.layer.cornerCurve = kCACornerCurveContinuous;
	self.layer.cornerRadius = 12;
	self.layer.masksToBounds = YES;
	self.translatesAutoresizingMaskIntoConstraints = NO;

	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle: UIBlurEffectStyleSystemUltraThinMaterial]];
	[self addSubview: visualEffectView];
	[self pinViewToAllEdges: visualEffectView];

	[self checkIfRadiansOrDegrees];

	mainLabelsStackView = [self createStackViewWithSpacing: 5];
	textFieldsStackView = [self createStackViewWithSpacing: 10];

	liliumMainLabel = [self createLabelWithAlpha:1 fontSize:18 text: calculatorString];
	formulaLabel = [self createLabelWithAlpha:0.5 fontSize:10 text: formulaString];
	[mainLabelsStackView addArrangedSubview: liliumMainLabel];
	[mainLabelsStackView addArrangedSubview: formulaLabel];

	degRadTextField = [self createTextFieldWithPlaceholder: placeholderString];
	resultsTextField = [self createTextFieldWithPlaceholder: @"Result:"];
	[textFieldsStackView addArrangedSubview: degRadTextField];
	[textFieldsStackView addArrangedSubview: resultsTextField];

	swapButton = [self createButtonWithImage:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath"]
		selector:@selector(didTapSwapButton)
	];
	dismissButton = [self createButtonWithImage:[UIImage systemImageNamed:@"xmark"]
		selector:@selector(didTapDismissButton)
	];

	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUpView)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[self addGestureRecognizer: swipeRecognizer];

	[self layoutUI];

}


- (void)layoutUI {

	// :woeisFade: I still prefer the property syntax though

	[NSLayoutConstraint activateConstraints:@[
		[mainLabelsStackView.topAnchor constraintEqualToAnchor: self.topAnchor constant: 15],
		[mainLabelsStackView.centerXAnchor constraintEqualToAnchor: self.centerXAnchor]
	]];

	[NSLayoutConstraint activateConstraints:@[
		[textFieldsStackView.topAnchor constraintEqualToAnchor: mainLabelsStackView.bottomAnchor constant: 10],
		[textFieldsStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10]
	]];

	[NSLayoutConstraint activateConstraints:@[
		[swapButton.centerYAnchor constraintEqualToAnchor: liliumMainLabel.centerYAnchor],
		[swapButton.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10]
	]];

	[NSLayoutConstraint activateConstraints:@[
		[dismissButton.centerYAnchor constraintEqualToAnchor: liliumMainLabel.centerYAnchor],
		[dismissButton.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -10]
	]];

}

// ! Selectors

- (void)didSwipeUpView {

	[self animateViewWithView:self withAlpha:0 resigningFirstResponderIfNeeded:YES completion:^(BOOL finished) {

		self.hidden = YES;

	}];

}


- (void)didTapDismissButton {

	[self animateViewWithView:self withAlpha:0 resigningFirstResponderIfNeeded:YES completion:^(BOOL finished) {

		self.hidden = YES;

	}];

}


- (void)didTapSwapButton {

	isDegreesToRadians = !isDegreesToRadians;
	[self checkIfRadiansOrDegrees];

}


- (void)fadeIn {

	self.hidden = NO;
	[self animateViewWithView:self withAlpha:1 resigningFirstResponderIfNeeded:NO completion: nil];

}

// ! Logic

- (void)checkIfRadiansOrDegrees {

	calculatorString = isDegreesToRadians ? @"Degrees to radians" : @"Radians to degrees";
	formulaString = isDegreesToRadians ? @"Formula -> deg * π/180" : @"Formula -> rad * 180/π";
	placeholderString = [NSString stringWithFormat: @"Enter %@", isDegreesToRadians ? @"degrees:" : @"radians:"];

	NSString *result = [NSString stringWithFormat: @"%@", degRadTextField.text];
	float castedResult = [result floatValue];

	NSString *degreesResult = [NSString stringWithFormat: @"%0.fº", castedResult * (180 / M_PI)];
	NSString *radiansResult = [NSString stringWithFormat: @"%0.3f rad", castedResult * (M_PI / 180)];
	NSString *resultsString = isDegreesToRadians ? radiansResult : degreesResult;

	[UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		liliumMainLabel.text = calculatorString;
		formulaLabel.text = formulaString;
		degRadTextField.placeholder = placeholderString;
		resultsTextField.text = resultsString;

		if(degRadTextField.text.length < 1 || resultsTextField.text.length < 1) resultsTextField.text = @"";

	} completion: nil];

}

// ! Reusable methods

- (UIStackView *)createStackViewWithSpacing:(CGFloat)spacing {

	UIStackView *stackView = [UIStackView new];
	stackView.axis = UILayoutConstraintAxisVertical;
	stackView.spacing = spacing;
	stackView.distribution = UIStackViewDistributionFill;
	stackView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview: stackView];
	return stackView;

}


- (UILabel *)createLabelWithAlpha:(CGFloat)alpha fontSize:(CGFloat)fontSize text:(NSString *)text {

	UILabel *label = [UILabel new];
	label.alpha = alpha;
	label.font = [UIFont italicSystemFontOfSize: fontSize];
	label.text = text;
	label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines = 0;
	return label;

}


- (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder {

	UITextField *textField = [UITextField new];
	textField.font = [UIFont systemFontOfSize: 14];
	textField.delegate = self;
	textField.placeholder = placeholder;
	textField.returnKeyType = UIReturnKeyDone;
	textField.translatesAutoresizingMaskIntoConstraints = NO;
	return textField;

}


- (UIButton *)createButtonWithImage:(UIImage *)image selector:(SEL)selector {

	UIButton *button = [UIButton new];
	button.tintColor = UIColor.labelColor;
	button.adjustsImageWhenHighlighted = NO;
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[button setImage:image forState: UIControlStateNormal];
	[button addTarget:self action:selector forControlEvents: UIControlEventTouchUpInside];
	[self addSubview: button];
	return button;

}


- (void)animateViewWithView:(UIView *)view
	withAlpha:(CGFloat)alpha
	resigningFirstResponderIfNeeded:(BOOL)needed
	completion:(void(^)(BOOL completion))completion {

	[UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		view.alpha = alpha;

	} completion: completion];

	if(needed) [theTextField resignFirstResponder];

}

// ! UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

	theTextField = textField;
	return YES;

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	if(textField == degRadTextField) [self checkIfRadiansOrDegrees];

	[textField resignFirstResponder];

	return YES;

}

@end
