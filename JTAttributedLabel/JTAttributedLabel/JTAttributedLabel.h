/*
 * This file is part of the JTAttributedLabel package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface JTAttributedLabel : UILabel

@property (nonatomic, copy) NSAttributedString *attributedText;

@end

@interface JTTextLayer : CATextLayer

@property(copy) id string;

@end

// JTAutoLabel in iOS 6 uses the original UILabel
// iOS 5 uses JTAttributedLabel
@interface JTAutoLabel : UILabel

@end