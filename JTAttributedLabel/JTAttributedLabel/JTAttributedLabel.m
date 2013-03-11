/*
 * This file is part of the JTAttributedLabel package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTAttributedLabel.h"
#import "NSAttributedString+JTiOS5Compatibility.h"
#import <objc/runtime.h>

#if JTAttributedLabelDebug

#import "UINibDecoderProxy.h"

#endif

@implementation JTAttributedLabel
@synthesize attributedText = _attributedText;

+ (void)load {
    if( ! [UILabel instancesRespondToSelector:@selector(attributedText)] ){
        objc_registerClassPair(objc_allocateClassPair([JTAttributedLabel class], "JTAutoLabel", 0));
    }
}

+ (Class)layerClass {
    return [JTTextLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder {

#if JTAttributedLabelDebug
    self = [super initWithCoder:(id)[[UINibDecoderProxy alloc] initWithTarget:aDecoder]];
#else
    self = [super initWithCoder:aDecoder];
#endif

    self.attributedText = [aDecoder decodeObjectForKey:@"UIAttributedText"];

    return self;
}

- (void)awakeFromNib {
    // Fix black layout if UILabel.backgroundColor is specified
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    self.layer.opaque = NO;
    
    [(CATextLayer *)self.layer setWrapped:YES];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = [attributedText copy];

    JTTextLayer *textLayer = (JTTextLayer *)self.layer;
    textLayer.string = _attributedText;
}

- (void)drawTextInRect:(CGRect)rect {
    // Do nothing
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (self.attributedText) {
//        CGFloat height = [self.attributedText boundingHeightForWidth:size.width];
//        CGFloat width = size.height;
//        return CGSizeMake(width, height);
        return [self.layer preferredFrameSize];
    }
    return [super sizeThatFits:size];
}

@end


@implementation JTTextLayer {
    CGSize _suggestedSize;
}

@synthesize string = _string;

- (id)string {
    return _string;
}

- (void)setString:(id)string {
    if ([string isKindOfClass:[NSAttributedString class]]) {
        NSParagraphStyle *paragraphStyle = nil;
        _string = [string iOS5AttributedStringWithParagraphStyle:&paragraphStyle];

        NSString *alignmentMode = nil;
        switch (paragraphStyle.alignment) {
            case NSTextAlignmentRight:
                alignmentMode = kCAAlignmentRight;
                break;
            case NSTextAlignmentCenter:
                alignmentMode = kCAAlignmentCenter;
                break;
            case NSTextAlignmentJustified:
                alignmentMode = kCAAlignmentJustified;
                break;
            case NSTextAlignmentNatural:
                alignmentMode = kCAAlignmentNatural;
                break;
            case NSTextAlignmentLeft:
            default:
                alignmentMode = kCAAlignmentLeft;
                break;
        }
        
#if TARGET_IPHONE_SIMULATOR
        if ( ! [UILabel instancesRespondToSelector:@selector(attributedText)]) {
            // iOS 5 simulator

            switch (paragraphStyle.alignment) {
                case NSTextAlignmentRight:
                    alignmentMode = kCAAlignmentCenter;
                    break;
                case NSTextAlignmentCenter:
                    alignmentMode = kCAAlignmentRight;
                    break;
                default:
                    break;
            }
        }
#endif
        
        self.alignmentMode = alignmentMode;
    }
    [super setString:_string];
}

- (void)drawInContext:(CGContextRef)ctx {
    // Transform the context to draw text at vertical center
    
    CGFloat height = self.preferredFrameSize.height;
    
    if ([self.string isKindOfClass:[NSAttributedString class]]) {
        // We use CoreText to calculate the bounds text height instead of
        // depending on CATextLayer's version, which seems isn't reliable
        height = [(NSAttributedString *)self.string boundingHeightForWidth:self.frame.size.width];
    }
    
    CGFloat padding = roundf((self.frame.size.height - height)/2);
    
//    NSLog(@"padding %f, frameSize %@, preferredFrameSize %@", padding, NSStringFromCGRect(self.frame), NSStringFromCGSize(self.preferredFrameSize));
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, padding);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
}

@end
