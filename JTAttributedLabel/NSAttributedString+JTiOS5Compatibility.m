//
//  NSAttributedString+JTiOS5Compatibility.m
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import "NSAttributedString+JTiOS5Compatibility.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (JTiOS5Compatibility)

- (NSAttributedString *)iOS5AttributedStringWithParagraphStyle:(NSParagraphStyle *__autoreleasing *)paragraphStyle {
    NSAttributedString *title = self;

    __block NSMutableAttributedString *normalized = [[NSMutableAttributedString alloc] initWithString:title.string];

    [title enumerateAttributesInRange:NSMakeRange(0, [title length])
                              options:0
                           usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                               NSString *text = [[title string] substringWithRange:range];
                               NSLog(@"%@ %@ %@", text, NSStringFromRange(range), attrs);
                               
                               [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                   if ([key isEqualToString:@"NSColor"]) {
                                       CGColorRef color = [(UIColor *)obj CGColor];
                                       [normalized addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)color range:range];
                                   } else if ([key isEqualToString:@"NSFont"]) {
                                       CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)[obj fontName], [obj pointSize], NULL);
                                       [normalized addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                                   } else if ([key isEqualToString:@"NSBackgroundColor"]) {
                                       // There's no NSBackgroundColorAttributeName equivalent for iOS5
                                   } else if ([key isEqualToString:@"NSParagraphStyle"]) {
                                       
                                       *paragraphStyle = obj;
                                   }
                               }];
                           }];

    return normalized;
}

@end
