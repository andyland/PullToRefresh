//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Modified by Andrew McSherry on 5/22/11.
//  Copyright 2011 Andyland Development.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

@implementation PullRefreshTableViewController

@dynamic tableView;

- (id) init {
    if (self = [super init]) {
        style = UITableViewStylePlain;
        loadFromNIB = NO;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style_ {
    self = [super initWithStyle:style_];
    if (self != nil) {
        style = style_;
        loadFromNIB = NO;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        loadFromNIB = YES;
    }
    return self;
}

- (void) loadView {
    if (loadFromNIB) {
        [super loadView];
    } else {
        self.tableView = [[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:style] autorelease];
        self.view = self.tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
}

- (void) refreshPullRefreshTableView:(PullRefreshTableView *)tableView {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

@end
