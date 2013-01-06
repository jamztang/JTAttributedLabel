//
//  JTParagraphStyle.m
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import "JTParagraphStyle.h"
#import "UINibDecoderProxy.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

void SwizzleInstanceMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

void SwizzleClassMethod(Class c, SEL orig, SEL new) {

    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);

    c = object_getClass((id)c);

    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@implementation NSParagraphStyle (Private)

+ (void)load {
    SwizzleInstanceMethod([self class], @selector(initWithCoder:), @selector(initWithCoderSwizzled:));
}

- (id)initWithCoderSwizzled:(NSCoder *)aDecoder {
    self = [self initWithCoderSwizzled:(id)[[UINibDecoderProxy alloc] initWithTarget:aDecoder]];
    return self;
}

@end


@implementation JTParagraphStyle

+ (void)load {
#if SWIZZLE_PARAGRAPHSTYLE
    if( ! NSClassFromString(@"NSParagraphStyle") ){
        objc_registerClassPair(objc_allocateClassPair([JTParagraphStyle class], "NSParagraphStyle", 0));
    }

    if( ! NSClassFromString(@"NSMutableParagraphStyle") ){
        objc_registerClassPair(objc_allocateClassPair([JTMutableParagraphStyle class], "NSMutableParagraphStyle", 0));
    }
#endif
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _alignment              = [aDecoder decodeIntegerForKey:@"NSAlignment"];
    _lineBreakMode          = [aDecoder decodeIntegerForKey:@"NSLineBreakMode"];
    _lineSpacing            = [aDecoder decodeIntegerForKey:@"NSLineSpacing"];
    _paragraphSpacing       = [aDecoder decodeIntegerForKey:@"NSParagraphSpacing"];
    _firstLineHeadIndent    = [aDecoder decodeDoubleForKey:@"NSFirstLineHeadIndent"];
    _headIndent             = [aDecoder decodeDoubleForKey:@"NSHeadIndent"];
    _tailIndent             = [aDecoder decodeDoubleForKey:@"NSTailIndent"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_alignment forKey:@"NSAlignment"];
    [aCoder encodeInteger:_lineBreakMode forKey:@"NSLineBreakMode"];
    [aCoder encodeInteger:_paragraphSpacing forKey:@"NSParagraphSpacing"];
    [aCoder encodeInteger:_firstLineHeadIndent forKey:@"NSFirstLineHeadIndent"];
    [aCoder encodeDouble:_firstLineHeadIndent forKey:@"NSFirstLineHeadIndent"];
    [aCoder encodeDouble:_headIndent forKey:@"NSHeadIndent"];
    [aCoder encodeDouble:_tailIndent forKey:@"NSTailIndent"];
}

- (NSDictionary *)attr {
    return [self dictionaryWithValuesForKeys:@[@"lineSpacing", @"paragraphSpacing", @"alignment", @"firstLineHeadIndent", @"headIndent", @"tailIndent", @"lineBreakMode", @"minimumLineHeight", @"maximumLineHeight", @"baseWritingDirection", @"lineHeightMultiple", @"paragraphSpacingBefore", @"hyphenationFactor"]];
}

+ (JTParagraphStyle *)defaultParagraphStyle {
    return [[self alloc] init];
}

+ (NSWritingDirection)defaultWritingDirectionForLanguage:(NSString *)languageName {
    return 0;
}

@end


@implementation JTMutableParagraphStyle


@end
