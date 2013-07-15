// UINibDecoderProxy.m
//
// Copyright (c) 2013 James Tang (mystcolor@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UINibDecoderProxy.h"

@implementation UINibDecoderProxy {
    NSUInteger numberOfArguments;
}

- (id)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    // Set a breakpoint here add action "po invocation"

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