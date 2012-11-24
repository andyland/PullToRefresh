PullToRefresh

A simple iPhone TableView and Protocols for adding pull-to-refresh functionality.

![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-1.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-2.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-3.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-4.png)

Inspired by [Tweetie 2](http://www.atebits.com/tweetie-iphone/), [Oliver Drobnik's blog post](http://www.drobnik.com/touch/2009/12/how-to-make-a-pull-to-reload-tableview-just-like-tweetie-2/)
and [EGOTableViewPullRefresh](http://github.com/enormego/EGOTableViewPullRefresh).


How to intall

1. Copy the files, [PullRefreshTableViewController.h](https://github.com/andylanddev/PullToRefresh/raw/master/Classes/PullRefreshTableViewController.h),
[PullRefreshTableViewController.m](https://github.com/andylanddev/PullToRefresh/raw/master/Classes/PullRefreshTableViewController.m), 
[PullRefreshTableView.h](https://github.com/andylanddev/PullToRefresh/raw/master/Classes/PullRefreshTableView.h), 
[PullRefreshTableView.m](https://github.com/andylanddev/PullToRefresh/raw/master/Classes/PullRefreshTableView.m)
and [arrow.png](http://github.com/leah/PullToRefresh/raw/master/arrow.png) into your project.

2. Link against the QuartzCore framework (used for rotating the arrow image).

3. Use all the files exactly as you would their UIKit parents

4. Implement the -[id\<PullRefreshTableViewDataSource\> refreshPullRefreshTableView:(PullRefreshTableView*)tableview] protocol method


Enjoy!

Modified by [Andy McSherry](http://www.andymcsherry.com)
