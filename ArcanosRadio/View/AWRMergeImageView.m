#import "AWRMergeImageView.h"
#import "UIView+Utils.h"

@interface AWRMergeImageView()

@property (nonatomic, strong) UIImageView *imageViewStart;
@property (nonatomic, strong) UIImageView *imageViewEnd;

@end

@implementation AWRMergeImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createImageViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createImageViews];
    }
    return self;
}

- (void)createImageViews {
    self.imageViewStart = [[UIImageView alloc] initWithFrame:self.frame];
    self.imageViewStart.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageViewStart];
    [self.imageViewStart fillSuperview];

    self.imageViewEnd = [[UIImageView alloc] initWithFrame:self.frame];
    self.imageViewEnd.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewEnd.alpha = 0.0;
    [self addSubview:self.imageViewEnd];
    [self.imageViewEnd fillSuperview];
}

- (UIImage *)imageStart {
    return self.imageViewStart.image;
}

- (void)setImageStart:(UIImage *)imageStart {
    self.imageViewStart.image = imageStart;
}

- (UIImage *)imageEnd {
    return self.imageViewEnd.image;
}

- (void)setImageEnd:(UIImage *)imageEnd {
    self.imageViewEnd.image = imageEnd;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    self.imageViewEnd.alpha = progress;
}

@end
