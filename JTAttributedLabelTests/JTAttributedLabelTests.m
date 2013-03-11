//
//  JTAttributedLabelTests.m
//  JTAttributedLabelTests
//
//  Created by james on 6/1/13.
//  Copyright (c) 2013 Mystcolor. All rights reserved.
//

#import "JTAttributedLabelTests.h"
#import "JTAttributedLabelTestViewController.h"
#import "NSAttributedString+JTiOS5Compatibility.h"

@interface JTAttributedLabelTests ()

@property (nonatomic, strong) JTAttributedLabelTestViewController *testViewController;

@property (nonatomic, copy) NSAttributedString *testAttributedString;

@end


@implementation JTAttributedLabelTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    self.testViewController = [[JTAttributedLabelTestViewController alloc] initWithNibName:@"JTAttributedLabelTestViewController" bundle:nil];
    
    [self.testViewController view];
    
    self.testAttributedString = self.testViewController.label.attributedText;
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testVC {
    STAssertNotNil(self.testViewController, nil);
    STAssertNotNil(self.testAttributedString, nil);
}

- (void)testBoundingRect {
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1;
    CGSize boundSize = CGSizeMake(40, CGFLOAT_MAX);

    CGRect rect = [self.testAttributedString boundingRectWithSize:boundSize
                                                          options:0
                                                          context:context];
    
    CGRect rect1 = [self.testAttributedString boundingRectWithSize:boundSize
                                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                           context:context];
    
    CGRect rect2 = [self.testAttributedString boundingRectWithSize:boundSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:context];
    
    CGRect rect3 = [self.testAttributedString boundingRectWithSize:boundSize
                                                           options:NSStringDrawingUsesFontLeading
                                                           context:context];
    
    CGRect rect4 = [self.testAttributedString boundingRectWithSize:boundSize
                                                           options:NSStringDrawingUsesDeviceMetrics
                                                           context:context];

    CGSize size = [self.testAttributedString boundingSizeForSize:boundSize];

    STAssertEquals(size, rect.size, nil);
    STAssertEquals(size, rect1.size, nil);
    STAssertEquals(size, rect2.size, nil);
    STAssertEquals(size, rect3.size, nil);
    STAssertEquals(size, rect4.size, nil);

}

- (void)testiOS5BoundingRect {
    CGSize boundSize = CGSizeMake(130, CGFLOAT_MAX);

    CGSize size1 = [self.testAttributedString boundingSizeForSize:boundSize];
    
    
    if ([self.testAttributedString respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1;
        
        size1 = [self.testAttributedString boundingRectWithSize:boundSize
                                                        options:0
                                                        context:context].size;
    }
    NSParagraphStyle *style;
    
    NSAttributedString *string2 = [self.testAttributedString iOS5AttributedStringWithParagraphStyle:&style];
    
    NSAttributedString *string3 = [string2 iOS5AttributedStringWithParagraphStyle:NULL];

    CGSize size2 = [string2 boundingSizeForSize:boundSize];
    CGSize size3 = [string3 boundingSizeForSize:boundSize];
    
    STAssertEquals(size2, size1, nil);
    STAssertFalse(CGSizeEqualToSize(size3, size2), nil);
}


@end
