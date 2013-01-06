//
//  UINibDecoderProxy.m
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import "UINibDecoderProxy.h"

@implementation UINibDecoderProxy {
    NSUInteger numberOfArguments;
}

- (id)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    for (NSUInteger i = 2; i < numberOfArguments; i++) {
        id argumment = nil;
        [invocation getArgument:&argumment atIndex:i];
        NSLog(@"argument %d %@", i, argumment);
    }
    [invocation invokeWithTarget:_target];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *methodSignature = [_target methodSignatureForSelector:sel];
    
    numberOfArguments = [methodSignature numberOfArguments];
    
    return methodSignature;
}

@end