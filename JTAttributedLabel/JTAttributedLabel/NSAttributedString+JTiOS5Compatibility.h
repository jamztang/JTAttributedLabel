/*
 * This file is part of the JTAttributedLabel package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

@interface NSAttributedString (JTiOS5Compatibility)

- (NSAttributedString *)iOS5AttributedStringWithParagraphStyle:(NSParagraphStyle **)paragraphStyle;

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth;
- (CGSize)boundingSizeForSize:(CGSize)size;

@end
