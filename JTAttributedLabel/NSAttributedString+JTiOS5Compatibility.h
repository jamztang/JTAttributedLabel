//
//  NSAttributedString+JTiOS5Compatibility.h
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (JTiOS5Compatibility)

- (NSAttributedString *)iOS5AttributedStringWithParagraphStyle:(NSParagraphStyle **)paragraphStyle;

@end
