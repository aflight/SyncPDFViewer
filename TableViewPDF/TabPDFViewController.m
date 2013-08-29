//
//  TabPDFViewController.m
//  TableViewPDF
//
//  Created by 周跃翔 on 13-4-18.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import "TabPDFViewController.h"

@interface TabPDFViewController ()
@property (strong,nonatomic) NSMutableArray *listArray;
@end

@implementation TabPDFViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 获取PDF文件名
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *files = [fileManage subpathsOfDirectoryAtPath:documentDirectory error:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in files) {
        if([string hasSuffix:@".pdf"]||[string hasSuffix:@".PDF"]){
            [array insertObject:string atIndex:0];
        }
    }
    self.listArray = array;
    
    // Add navigator bar button
//    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitButtonPressed:)];
//    exitButton.tintColor = [UIColor redColor];
//    self.navigationItem.rightBarButtonItem = exitButton;
}

- (IBAction)exitButtonPressed:(id)sender
{
    exit(0);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUInteger  row = [indexPath row];
    NSString *pdfTitle = [self.listArray objectAtIndex:row];
    cell.textLabel.text = pdfTitle;
    cell.textLabel.textAlignment = NSTextAlignmentLeft
    ;
    // Configure the cell...
    UIImage *image = [UIImage imageNamed:@"bluestar.png"];
    cell.imageView.image = image;
    UIImage *highImage = [UIImage imageNamed:@"yellowstar.png"];
    cell.imageView.highlightedImage = highImage;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    RootViewController *pcview = [storyboard instantiateViewControllerWithIdentifier:@"pcview"];
    pcview.fileName = [self.listArray objectAtIndex:[indexPath row]];
    pcview.title = pcview.fileName;
    [self.navigationController pushViewController:pcview animated:YES];
    
}

@end
















