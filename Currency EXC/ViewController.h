//
//  ViewController.h
//  Currency EXC
//
//  Created by PETRONAS ICT SDN BHD on 19/11/2016.
//  Copyright © 2016 TfqNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTable.h"
#import "DBController.h"

@interface ViewController : UIViewController


@property (nonatomic,strong) DBController *db;
@property (nonatomic,strong) DataTable *currencyTbl;

@end

