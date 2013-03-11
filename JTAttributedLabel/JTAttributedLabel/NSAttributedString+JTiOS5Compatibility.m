/*
 * This file is part of the JTAttributedLabel package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSAttributedString+JTiOS5Compatibility.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (JTiOS5Compatibility)

- (NSAttributedString *)iOS5AttributedStringWithParagraphStyle:(NSParagraphStyle *__autoreleasing *)paragraphStyle {
    NSAttributedString *title = self;

    __block NSMutableAttributedString *normalized = [[NSMutableAttributedString alloc] initWithString:title.string];

    [title enumerateAttributesInRange:NSMakeRange(0, [title length])
                              options:0
                           usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//                               NSString *text = [[title string] substringWithRange:range];
//                               NSLog(@"%@ %@ %@", text, NSStringFromRange(range), attrs);

                               [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                   if ([key isEqualToString:@"NSColor"]) {
                                       CGColorRef color = [(UIColor *)obj CGColor];
                                       [normalized addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)color range:range];
                                   } else if ([key isEqualToString:@"NSFont"] && [obj respondsToSelector:@selector(fontName)]) {
                                       CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)[obj fontName], [obj pointSize], NULL);
                                       [normalized addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                                   } else if ([key isEqualToString:@"NSUnderline"]) {
                                       [normalized addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:obj range:range];
                                   } else if ([key isEqualToString:@"NSBackgroundColor"]) {
                                       // There's no NSBackgroundColorAttributeName equivalent for iOS5
                                   } else if ([key isEqualToString:@"NSStrikethrough"]) {
                                       // There's no NSStrikethroughStyleAttributeName equivalent for iOS5
                                   } else if ([key isEqualToString:@"NSParagraphStyle"]) {
                                       *paragraphStyle = obj;
                                   }
                               }];
                           }];

    return normalized;
}

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth
{
    NSParagraphStyle *paragraphStyle = nil;

    NSAttributedString* attrStrWithLinks = [self iOS5AttributedStringWithParagraphStyle:&paragraphStyle];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStrWithLinks);

    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(inWidth, CGFLOAT_MAX), NULL);
    CFRelease(framesetter);

    return suggestedSize.height;
}

@end
