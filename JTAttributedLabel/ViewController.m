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
#import "NSAttributedString+JTiOS5Compatibility.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *textLayerReferenceView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
