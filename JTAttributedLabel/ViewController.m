//
//  ViewController.m
//  JTAttributedLabel
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import "ViewController.h"
#import "TTTAttributedLabel.h"
#import "JTAttributedLabel.h"
#import "JTParagraphStyle.h"
#import <QuartzCore/QuartzCore.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *textLayerReferenceView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    NSAttributedString *title = self.label.attributedText;

    NSLog(@"enumerateAttributesInRange");

    __block NSMutableAttributedString *normalized = [[NSMutableAttributedString alloc] initWithString:title.string];
    
    __block NSParagraphStyle *paragraphStyle = nil;
    
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
                                   } else if ([key isEqualToString:@"NSParagraphStyle"]) {

                                       paragraphStyle = obj;
                                   }
                               }];
                           }];

    CATextLayer *textLayer = [CATextLayer layer];
    
    textLayer.frame = self.textLayerReferenceView.frame;

    
    NSString *alignmentMode = nil;
    switch (paragraphStyle.alignment) {
            
#if TARGET_IPHONE_SIMULATOR
        case NSTextAlignmentRight:
            alignmentMode = kCAAlignmentCenter;
            break;
        case NSTextAlignmentCenter:
            alignmentMode = kCAAlignmentRight;
            break;
#else
        case NSTextAlignmentRight:
            alignmentMode = kCAAlignmentRight;
            break;
        case NSTextAlignmentCenter:
            alignmentMode = kCAAlignmentCenter;
            break;
#endif

        case NSTextAlignmentJustified:
            alignmentMode = kCAAlignmentJustified;
            break;
        case NSTextAlignmentNatural:
            alignmentMode = kCAAlignmentNatural;
            break;
        case NSTextAlignmentLeft:
        default:
            alignmentMode = kCAAlignmentLeft;
            break;
    }
    textLayer.alignmentMode = alignmentMode;

    textLayer.string = normalized;

    [self.view.layer addSublayer:textLayer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
