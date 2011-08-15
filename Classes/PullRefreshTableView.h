//
//  PullRefreshTableView.h
//  PullToRefresh
//
//  Created by Andrew McSherry on 5/22/11.
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PullRefreshTableView;

@protocol PullRefreshTableViewDataSource <UITableViewDataSource>

- (void) refreshPullRefreshTableView:(PullRefreshTableView*)tableView;

@end

#pragma mark -

@protocol PullRefreshTableViewDelegate <UITableViewDelegate>

@end

#pragma mark -

@interface PullRefreshTableView : UITableView {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property (nonatomic, assign) id<PullRefreshTableViewDataSource> dataSource;
@property (nonatomic, assign) id<PullRefreshTableViewDelegate> delegate;

//No need to call stopLoading if this is called
- (void) reloadData;

- (void) stopLoading;

@end
