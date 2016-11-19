//
//  ViewController.m
//  Currency EXC
//
//  Created by PETRONAS ICT SDN BHD on 19/11/2016.
//  Copyright © 2016 TfqNet. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize db,currencyTbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    db = [DBController sharedDatabaseController:@"currencyExc.sqlite"];
    
    [self getCurrencies];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)getCurrencies {
    
    
    //http://free.currencyconverterapi.com/api/v3/currencies
    NSString *urlAsString = [NSString stringWithFormat:@"http://free.currencyconverterapi.com/api/v3/currencies"];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                
                if (!error) {
                   
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        
                        if (jsonError) {
                            
                        } else {
                            
                            
                            NSDictionary *result = [jsonResponse valueForKey:@"results"];
                            
                           NSArray *keys=[result allKeys];
                            
                            for(id currencyData in keys){
                                
                                NSDictionary *item = [result valueForKey:currencyData];
                                
                                NSString *currencyName, *currencySymbol, *currencyId;
                                
                                currencyId = [item valueForKey:@"id"];
                                currencyName = [item valueForKey:@"currencyName"];
                                currencySymbol = @"null";
                                NSArray *currencyKey=[item allKeys];
                                
                                for(NSString *currSym in currencyKey){
                                    if([currSym isEqualToString:@"currencySymbol"]){
                                        currencySymbol = [item valueForKey:@"currencySymbol"];
                                    }
                                    
                                }
                               // NSLog(@"%@ %@ %@",currencyId,currencyName,currencySymbol);
                                
                                NSString *dbString;
                                int i;
                                dbString = [NSString stringWithFormat:@"insert into currencyTbl(currId, currName, currSymbol) values('%@', '%@', '%@')",currencyId, currencyName, currencySymbol];
                                
                                i = [db ExecuteINSERT:dbString];
                                
                                
                                
                            }
                            
                            
                            //currencyTbl = [db ExecuteQuery:@"select * from currencyTbl"];
                            //NSLog(@"item from tbl %@", currencyTbl.rows);

                            
                        
                            
                            // [self getCountries];
                        }
                    }  else {
                        
                    }
                } else {
                                   }
            }] resume];
}

-(void)getCountries{
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://free.currencyconverterapi.com/api/v3/countries"];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                //NSLog(@"RESPONSE: %@",response);
                //NSLog(@"DATA: %@",data);
                
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        
                        if (jsonError) {
                            // Error Parsing JSON
                            
                        } else {
                            // Success Parsing JSON
                            // Log NSDictionary response:
                            NSLog(@"%@",jsonResponse);
                        }
                    }  else {
                        //Web server is returning an error
                    }
                } else {
                    // Fail
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
