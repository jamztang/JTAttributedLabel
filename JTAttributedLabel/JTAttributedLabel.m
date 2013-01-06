//
//  JTAttributedLabel.m
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import "JTAttributedLabel.h"
#import "UINibDecoderProxy.h"
#import "NSAttributedString+JTiOS5Compatibility.h"

@implementation JTAttributedLabel
@synthesize attributedText = _attributedText;

+ (Class)layerClass {
    return [JTTextLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
   self = [super initWithCoder:(id)[[UINibDecoderProxy alloc] initWithTarget:aDecoder]];

//    self = [super initWithCoder:aDecoder];

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