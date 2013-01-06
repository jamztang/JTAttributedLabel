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
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = [attributedText copy];

    JTTextLayer *textLayer = (JTTextLayer *)self.layer;
    textLayer.string = _attributedText;
}

- (void)drawTextInRect:(CGRect)rect {
    // Do nothing
}

@end


@implementation JTTextLayer
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
}

@end
