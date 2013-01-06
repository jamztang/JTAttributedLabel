/*
 * This file is part of the JTAttributedLabel package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTParagraphStyle.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

#if JTAttributedLabelDebug

#import "UINibDecoderProxy.h"

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

@implementation NSParagraphStyle (JTParagraphStyleDebug)

+ (void)load {
    SwizzleInstanceMethod([self class], @selector(initWithCoder:), @selector(initWithCoderSwizzled:));
}

- (id)initWithCoderSwizzled:(NSCoder *)aDecoder {
    self = [self initWithCoderSwizzled:(id)[[UINibDecoderProxy alloc] initWithTarget:aDecoder]];
    return self;
}

@end

#endif


@implementation JTParagraphStyle

+ (void)load {
    if( ! NSClassFromString(@"NSParagraphStyle") ){
        objc_registerClassPair(objc_allocateClassPair([JTParagraphStyle class], "NSParagraphStyle", 0));
    }

    if( ! NSClassFromString(@"NSMutableParagraphStyle") ){
        objc_registerClassPair(objc_allocateClassPair([JTMutableParagraphStyle class], "NSMutableParagraphStyle", 0));
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    _lineSpacing            = [aDecoder decodeDoubleForKey:@"NSLineSpacing"];
    _paragraphSpacing       = [aDecoder decodeDoubleForKey:@"NSParagraphSpacing"];
    _alignment              = [aDecoder decodeIntegerForKey:@"NSAlignment"];
    _headIndent             = [aDecoder decodeDoubleForKey:@"NSHeadIndent"];
    _tailIndent             = [aDecoder decodeDoubleForKey:@"NSTailIndent"];
    _firstLineHeadIndent    = [aDecoder decodeDoubleForKey:@"NSFirstLineHeadIndent"];
    _minimumLineHeight      = [aDecoder decodeDoubleForKey:@"NSMinLineHeight"];
    _maximumLineHeight      = [aDecoder decodeDoubleForKey:@"NSMaxLineHeight"];
    _lineBreakMode          = [aDecoder decodeIntegerForKey:@"NSLineBreakMode"];
    _baseWritingDirection   = [aDecoder decodeIntegerForKey:@"NSWritingDirection"];
    _lineHeightMultiple     = [aDecoder decodeDoubleForKey:@"NSLineHeightMultiple"];
    _paragraphSpacingBefore = [aDecoder decodeDoubleForKey:@"NSParagraphSpacingBefore"];
    _hyphenationFactor      = [aDecoder decodeFloatForKey:@"NSHyphenationFactor"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_lineSpacing forKey:@"NSLineSpacing"];
    [aCoder encodeDouble:_paragraphSpacing forKey:@"NSParagraphSpacing"];
    [aCoder encodeInteger:_alignment forKey:@"NSAlignment"];
    [aCoder encodeDouble:_headIndent forKey:@"NSHeadIndent"];
    [aCoder encodeDouble:_tailIndent forKey:@"NSTailIndent"];
    [aCoder encodeDouble:_firstLineHeadIndent forKey:@"NSFirstLineHeadIndent"];
    [aCoder encodeDouble:_minimumLineHeight forKey:@"NSMinLineHeight"];
    [aCoder encodeDouble:_maximumLineHeight forKey:@"NSMaxLineHeight"];
    [aCoder encodeInteger:_lineBreakMode forKey:@"NSLineBreakMode"];
    [aCoder encodeInteger:_baseWritingDirection forKey:@"NSWritingDirection"];
    [aCoder encodeDouble:_lineHeightMultiple forKey:@"NSLineHeightMultiple"];
    [aCoder encodeDouble:_paragraphSpacingBefore forKey:@"NSParagraphSpacingBefore"];
    [aCoder encodeFloat:_hyphenationFactor forKey:@"NSHyphenationFactor"];
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
