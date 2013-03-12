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

- (BOOL)needsNormalize {
    __block BOOL needsNormalize = YES;
    [self enumerateAttributesInRange:NSMakeRange(0, [self length])
                              options:0
                           usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                               NSArray *allKeys = [attrs allKeys];
                               if ([allKeys containsObject:(id)kCTForegroundColorAttributeName]) {
                                   *stop = YES;
                                   needsNormalize = NO;
                               }
                           }];
    return needsNormalize;
}

- (NSAttributedString *)iOS5AttributedStringWithParagraphStyle:(NSParagraphStyle *__autoreleasing *)paragraphStyle {
    NSAttributedString *title = self;

    if ( ! [self needsNormalize]) {
        return self;
    }

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
                                       /*
                                       {
                                           CGFloat lineSpacing = [(NSParagraphStyle *)obj lineSpacing] ?: 10;
                                           CGFloat paragraphSpacing = [(NSParagraphStyle *)obj paragraphSpacing] ?: 10;
                                           
                                           NSLog(@"--- lineSpacing %.0f paragraphSpacing %.0f", lineSpacing, paragraphSpacing);
                                           const CTParagraphStyleSetting styleSettings[] = {
                                               {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing},
                                               {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
                                               {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing},
                                           };
                                           CTParagraphStyleRef ctParagraphStyle = CTParagraphStyleCreate(styleSettings, 2);
                                           [normalized addAttribute:(id)kCTParagraphStyleAttributeName
                                                              value:(__bridge id)ctParagraphStyle range:range];
                                           CFRelease(ctParagraphStyle);
                                       }
                                        */
                                       *paragraphStyle = obj;
                                   } else {
                                       // Make sure it doesn't discard already normalized attributes
                                       [normalized addAttribute:key value:obj range:range];
                                   }
                               }];
                           }];

    return normalized;
}

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth
{
    return [self boundingSizeForSize:CGSizeMake(inWidth, CGFLOAT_MAX)].height;
}

- (CGSize)boundingSizeForSize:(CGSize)size {
//    NSParagraphStyle *paragraphStyle = nil;
    
    NSAttributedString* attrStrWithLinks = [self copy];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStrWithLinks);
    
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size, NULL);
    CFRelease(framesetter);
    
    return suggestedSize;
}

@end
