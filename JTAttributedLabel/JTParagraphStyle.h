//
//  JTParagraphStyle.h
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTParagraphStyle : NSObject <NSCoding>

+ (JTParagraphStyle *)defaultParagraphStyle;

+ (NSWritingDirection)defaultWritingDirectionForLanguage:(NSString *)languageName;  // languageName is in ISO lang region format

@property(readonly) CGFloat lineSpacing; /* "Leading": distance between the bottom of one line fragment and top of next (applied between lines in the same container). Can't be negative. This value is included in the line fragment heights in layout manager. */
@property(readonly) CGFloat paragraphSpacing; /* Distance between the bottom of this paragraph and top of next (or the beginning of its paragraphSpacingBefore, if any). */
@property(readonly) NSTextAlignment alignment;

/* The following values are relative to the appropriate margin (depending on the paragraph direction) */

@property(readonly) CGFloat headIndent; /* Distance from margin to front edge of paragraph */
@property(readonly) CGFloat tailIndent; /* Distance from margin to back edge of paragraph; if negative or 0, from other margin */
@property(readonly) CGFloat firstLineHeadIndent; /* Distance from margin to edge appropriate for text direction */

@property(readonly) CGFloat minimumLineHeight; /* Line height is the distance from bottom of descenders to top of ascenders; basically the line fragment height. Does not include lineSpacing (which is added after this computation). */
@property(readonly) CGFloat maximumLineHeight; /* 0 implies no maximum. */

@property(readonly) NSLineBreakMode lineBreakMode;

@property(readonly) NSWritingDirection baseWritingDirection;

@property(readonly) CGFloat lineHeightMultiple; /* Natural line height is multiplied by this factor (if positive) before being constrained by minimum and maximum line height. */
@property(readonly) CGFloat paragraphSpacingBefore; /* Distance between the bottom of the previous paragraph (or the end of its paragraphSpacing, if any) and the top of this paragraph. */

/* Specifies the threshold for hyphenation.  Valid values lie between 0.0 and 1.0 inclusive.  Hyphenation will be attempted when the ratio of the text width as broken without hyphenation to the width of the line fragment is less than the hyphenation factor.  When this takes on its default value of 0.0, the layout manager's hyphenation factor is used instead.  When both are 0.0, hyphenation is disabled.
 
 NOTE: On iOS, the only supported values are 0.0 and 1.0.
 */
@property(readonly) float hyphenationFactor;
@end


@interface JTParagraphStyle (ToBeImplemented) <NSCopying, NSMutableCopying>

@end


@interface JTMutableParagraphStyle : JTParagraphStyle

@property(readwrite) CGFloat lineSpacing;
@property(readwrite) CGFloat paragraphSpacing;
@property(readwrite) NSTextAlignment alignment;
@property(readwrite) CGFloat firstLineHeadIndent;
@property(readwrite) CGFloat headIndent;
@property(readwrite) CGFloat tailIndent;
@property(readwrite) NSLineBreakMode lineBreakMode;
@property(readwrite) CGFloat minimumLineHeight;
@property(readwrite) CGFloat maximumLineHeight;
@property(readwrite) NSWritingDirection baseWritingDirection;
@property(readwrite) CGFloat lineHeightMultiple;
@property(readwrite) CGFloat paragraphSpacingBefore;
@property(readwrite) float hyphenationFactor;

@end

