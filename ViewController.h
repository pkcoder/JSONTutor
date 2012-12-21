//
//  ViewController.h
//  JsonTutor
//
//  Created by Software on 20/12/12.
//  Copyright (c) 2012 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CacheDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
NSArray *books;
IBOutlet UITableView *tableView;
    UIActivityIndicatorView *spinner;
}
@property(nonatomic, retain) NSThread *customThread;
@end
