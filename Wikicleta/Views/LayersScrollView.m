//
//  LayersScrollView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayersScrollView.h"
#import "LayersChooserViewController.h"

@implementation LayersScrollView

@synthesize layersController;

- (id) initWithLayers:(NSArray *)layers withLayersController:(LayersChooserViewController *)layersController_
{
    self = [super initWithFrame:CGRectMake(200, 10, 150, [App viewBounds].size.height-20)];
    if (self) {
        self.contentSize = CGSizeMake(150, 130 * [layers count]);
        [self setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
        [self setContentOffset:CGPointMake(0, -10)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setLayersController:layersController_];
        
        int i = 0;
        float scrollViewHeight = 0;
        for (NSString *layer in layers) {
            NSString *name = [layer stringByAppendingString:@"_layers"];
            
            LayerItemView * buttonLabel = (LayerItemView*) [[[NSBundle mainBundle] loadNibNamed:@"LayerItemView" owner:self options:nil] objectAtIndex:0];
            [buttonLabel setName:name];
            float height = buttonLabel.frame.size.height;
            
            [buttonLabel addTarget:layersController action:@selector(selectedLayer:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonLabel setSelected:NO];
            [buttonLabel setUserInteractionEnabled:YES];
            [buttonLabel setFrame:CGRectMake(buttonLabel.frame.origin.x, (buttonLabel.frame.origin.y+height+10)*i, buttonLabel.frame.size.width, height)];
            [buttonLabel.titleLabel setText:NSLocalizedString(name, nil)];
            [buttonLabel.titleLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
            [[buttonLabel iconImage] setImage:[UIImage imageNamed:[name stringByAppendingString:@".png"]]];
            
            [self addSubview:buttonLabel];
            scrollViewHeight = buttonLabel.frame.origin.y+buttonLabel.frame.size.height;
            [[layersController layersMenuList] setValue:buttonLabel forKey:name];
            i+=1;
        }
        [self setContentSize:CGSizeMake(self.contentSize.width, scrollViewHeight)];
    }
    
    return self;
}



@end
