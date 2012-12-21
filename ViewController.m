//
//  ViewController.m
//  JsonTutor
//
//  Created by Software on 20/12/12.
//  Copyright (c) 2012 Software. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"
#import "ImageDownloader.h"
@interface ViewController ()
#define IMAGE_VIEW_TAG 991
@end

@implementation ViewController
@synthesize customThread =_customThread;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(NSString *)authorNameAtIndex:(NSInteger)index {
    return [[self bookAtIndex:index] objectForKey:@"name"];
}
-(NSString *)bookUrlAtIndex:(NSInteger)index {
    return [[self bookAtIndex:index] objectForKey:@"coverurl"];
}

-(NSString *)bookNameAtIndex:(NSInteger)index {
    return [[self bookAtIndex:index] objectForKey:@"author"];
}
-(NSDictionary *)bookAtIndex:(NSInteger)index {
    return [books objectAtIndex:index];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bookCell";
    
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:CellIdentifier];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSURL *url=[NSURL URLWithString:[self bookUrlAtIndex:indexPath.row]];
    
    ImageDownloader *imageView = [[ImageDownloader alloc] initWithFrame:CGRectMake(10, 5,120, 100)];
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = IMAGE_VIEW_TAG;
   
   [[ImageLoader sharedLoader] cancelLoadingURL:imageView.imageURL];
    
    //load the image
    imageView.imageURL = url;
     [cell addSubview:imageView];
    UILabel *authorLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 30, 200, 20)];
    authorLabel.text=[self authorNameAtIndex:indexPath.row];
    authorLabel.textColor=[UIColor blackColor];
    authorLabel.textAlignment=NSTextAlignmentLeft;
    

    [cell addSubview:authorLabel];
    UILabel *bookLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 60, 200, 20)];
    bookLabel.text=[self bookNameAtIndex:indexPath.row];
    bookLabel.textColor=[UIColor blackColor];
    bookLabel.textAlignment= NSTextAlignmentLeft;
    bookLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
    [cell addSubview:bookLabel];
    return cell;
}
-(void)getBooksList
{
    // NSBundle* mainBundle = [NSBundle mainBundle];
    NSData* tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://myiosapps.comuf.com/mySampleProjects/jsonTutorial/sample.json"]];
    
    NSString* cacheDir = CacheDirectory;
    NSString* cachePath = [cacheDir stringByAppendingPathComponent:@"sample.json"];
    
    if (!tmpData){
        // attempt to get the data from the cache
        tmpData = [NSData dataWithContentsOfFile:cachePath];
    }
    
    
    
    [tmpData writeToFile:cachePath atomically:YES];
    NSLog(@"%@",cachePath);
    NSString *jsonString = [[NSString alloc] initWithData:tmpData encoding:NSASCIIStringEncoding];
    NSDictionary *results = [jsonString JSONValue];
    NSArray * json_issues = [NSArray arrayWithArray: [results objectForKey:@"books"]];
    
    books = [[NSArray alloc] initWithArray:json_issues];
   
    // Build an array from the dictionary for easy access to each entry
    //  NSArray * json_issues = [NSArray arrayWithArray: [results objectForKey:@"books"]];
    
}
-(NSThread *)callCustomThread
{
    if (_customThread == nil) {
        NSThread *myThreadTemp = [[NSThread alloc] init];
        [myThreadTemp start];
        
        self.customThread = myThreadTemp;
        //[myThreadTemp release];
        
    }
    [self performSelectorOnMainThread:@selector(getBooksList) withObject:nil waitUntilDone:YES];
    return _customThread;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
       
   // [self performSelectorInBackground:@selector(callCustomThread) withObject:nil];
   
    [self getBooksList];
    tableView.dataSource=self;
    tableView.delegate=self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
