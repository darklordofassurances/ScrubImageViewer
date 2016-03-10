
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray<UIImage *> *images;
@property (weak, nonatomic) IBOutlet UIImageView *scrubImageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrubImageView.image = [self.images objectAtIndex:0];
}

/*
 Keep track of users panning and update image as appropriate.
 */
- (IBAction)scrubImageViewPan:(UIPanGestureRecognizer *)sender
{
    static CGFloat currentX = 0;
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        //Distance the gesture has moved
        CGPoint translation = [sender translationInView:self.scrubImageView];
        currentX += translation.x;
        //Reset the translaton point
        [sender setTranslation:CGPointZero inView:self.scrubImageView];
        
        CGFloat maxWidth = self.scrubImageView.frame.size.width * .6;
        if (currentX > maxWidth) {
            currentX = maxWidth;
        }
        else if (currentX < 0) {
            currentX = 0;
        }
        
        self.scrubImageView.image = [self.images objectAtIndex:[self indexForPosition:currentX andMaxWidth:maxWidth]];
    }
}

/*
 Return the index of the image in images.
 @warning The number of scrub images cannot be greater than maxWidth
 @param currentX The current horizontal position the user has panned to
 @param maxWidth The maximum width the horizontal position can be for currentX
 */
- (NSUInteger)indexForPosition:(CGFloat)currentX andMaxWidth:(CGFloat)maxWidth
{
    float divisor = maxWidth / self.images.count;
    NSUInteger index = currentX / divisor;
    
    //Prevent index out of bounds error
    if (index >= self.images.count) {
        index = self.images.count-1;
    }
    
    return index;
}

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
        [self loadImages];
    }
    return _images;
}

- (void)loadImages
{
    NSUInteger numberOfFrames = 44;
    for (NSUInteger i = 1; i <= numberOfFrames; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"frame%lu", (unsigned long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [self.images addObject:image];
        }
        else {
            NSLog(@"Could not load image named: %@", imageName);
        }
    }
}

@end
