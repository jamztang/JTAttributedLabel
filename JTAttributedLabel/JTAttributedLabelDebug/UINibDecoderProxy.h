//
//  UINibDecoderProxy.h
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINibDecoderProxy : NSProxy

@property (nonatomic, strong) id target;

- (id)initWithTarget:(id)target;

@end


