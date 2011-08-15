//
//  PullRefreshTableView.m
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

#import "PullRefreshTableView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface PullRefreshTableView()

@property (nonatomic, assign) NSProxy<PullRefreshTableViewDelegate> *privateDelegate;
@property (nonatomic, assign) NSProxy<PullRefreshTableViewDataSource> *privateDatasource;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy)   NSString *textPull;
@property (nonatomic, copy)   NSString *textRelease;
@property (nonatomic, copy)   NSString *textLoading;

- (void) startLoading;
- (void) refresh;
- (void) addPullToRefreshHeader;

@end

#pragma mark -

@implementation PullRefreshTableView

@synthesize privateDelegate;
@synthesize privateDatasource;
@synthesize textPull;
@synthesize textRelease;
@synthesize textLoading;
@synthesize refreshHeaderView;
@synthesize refreshLabel;
@synthesize refreshArrow;
@synthesize refreshSpinner;

#pragma mark -
#pragma mark Overwritten Getters and Setters

- (void) setDataSource:(id <PullRefreshTableViewDataSource>) dataSource {
    self.privateDatasource = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self];
}

- (id<PullRefreshTableViewDataSource>) dataSource {
    return self.privateDatasource;
}

- (void) setDelegate:(id <PullRefreshTableViewDelegate>) delegate{
    self.privateDelegate = delegate;
    [super setDelegate:(id<UITableViewDelegate>)self];
}

- (id<PullRefreshTableViewDelegate>) delegate {
    return self.privateDelegate;
}

#pragma mark -
#pragma mark Initialization

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addPullToRefreshHeader];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addPullToRefreshHeader];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self addPullToRefreshHeader];
    }
    return self;
}

- (void)addPullToRefreshHeader {
    self.refreshHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)] autorelease];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    self.refreshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)] autorelease];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    self.refreshArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
    self.refreshArrow.backgroundColor = [UIColor blackColor];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    (REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);
    
    self.refreshSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self addSubview:refreshHeaderView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Protocol Support

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
    
    if ([self.privateDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.privateDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    
    if ([self.privateDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.privateDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
    
    if ([self.privateDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.privateDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    [self.dataSource refreshPullRefreshTableView:self];
}

#pragma mark -
#pragma mark Public Methods

- (void) reloadData {
    [self stopLoading];
    [super reloadData];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Message Forwarding

- (BOOL) respondsToSelector:(SEL)selector {
    return [super respondsToSelector:selector] ||
           [self.privateDelegate respondsToSelector:selector] || 
           [self.privateDatasource respondsToSelector:selector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = nil;
    
    if ((signature = [super methodSignatureForSelector:aSelector])) {
        return signature;
    } else if ((signature = [self.privateDelegate methodSignatureForSelector:aSelector])) {
        return signature;
    } else if ((signature = [self.privateDatasource methodSignatureForSelector:aSelector])) {
        return signature;
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation*)invocation {
    if ([self.privateDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self.privateDelegate];
    } else if ([self.privateDatasource respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self.privateDatasource];
    } else {
        [super forwardInvocation:invocation];
    }
}

#pragma mark -
#pragma mark Memory Management;

- (void) dealloc {
    self.refreshHeaderView = nil;
    self.refreshLabel = nil;
    self.refreshArrow = nil;
    self.refreshSpinner = nil;
    self.textPull = nil;
    self.textRelease = nil;
    self.textLoading = nil;
    [super dealloc];
}

@end
