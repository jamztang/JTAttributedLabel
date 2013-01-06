//
//  JTAttributedLabel.m
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import "JTAttributedLabel.h"
#import "UINibDecoderProxy.h"
#import <QuartzCore/QuartzCore.h>

@implementation JTAttributedLabel
@synthesize attributedText;

//+ (Class)layerClass {
//    return [CATextLayer class];
//}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:(id)[[UINibDecoderProxy alloc] initWithTarget:aDecoder]];

//    self = [super initWithCoder:aDecoder];

    self.attributedText = [aDecoder decodeObjectForKey:@"UIAttributedText"];

    return self;
}

@end
