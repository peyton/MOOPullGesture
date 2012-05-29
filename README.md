![Pull to create / pull to refresh](https://s3.amazonaws.com/peyton.github.com/MOOPullGesture/Why.png)

# Introduction
----------

MOOPullGesture implements pull gestures on table views through a UIGestureRecognizer subclass. Built to be extensible, MOOPullGesture comes with pull-to-create and pull-to-refresh.

MOOPullGesture contains [`MOOPullGestureRecognizer`](https://github.com/peyton/MOOPullGesture/blob/master/MOOPullGesture/MOOPullGestureRecognizer.h), which tracks a table view's scrolling and communicates updates to a trigger view through a simple protocol, [`MOOTriggerView`](https://github.com/peyton/MOOPullGesture/blob/master/MOOPullGesture/MOOTriggerView.h).

# Usage
----------

The [`Demo Project`](https://github.com/peyton/MOOPullGesture/tree/master/Demo%20Project) folder contains working examples of pull-to-create and pull-to-refresh.

### Pull-to-create

Please see [`PullToCreateViewController.m`](https://github.com/peyton/MOOPullGesture/blob/master/Demo%20Project/MOOPullGesture%20Demo/PullToCreateViewController.m) and [`PullToCreateDelegate.m`](https://github.com/peyton/MOOPullGesture/blob/master/Demo%20Project/MOOPullGesture%20Demo/PullToCreateDelegate.m). Pay special attention to the `UIScrollViewDelegate` methods on the delegate--it's important to forward those.

### Pull-to-refresh

Take a look at [`PullToRefreshViewController.m`](https://github.com/peyton/MOOPullGesture/blob/master/Demo%20Project/MOOPullGesture%20Demo/PullToRefreshViewController.m).

# Installation
----------

###First: Clone into a submodule

In your project's folder, type:

    git submodule add git://github.com/peyton/MOOPullGesture.git

A submodule allows your repository to contain a clone of an external project. If you don't want a submodule, use:

    git clone git://github.com/peyton/MOOPullGesture.git

###Next: Add classes

Drag `MOOPullGesture/` into your Xcode project's file browser.

*Note:* An options dialog will pop up. If you're using MOOPullGesture as a submodule, you should uncheck "Copy items into destination group's folder (if needed)."

###Then: Add QuartzCore.framework

![QuartzCore.framework installation](https://s3.amazonaws.com/peyton.github.com/MOOPullGesture/AddQuartzCoreFramework.png)

With your application's target selected in the navigator, click on the "Build Phases" tab. Under "Link Binary With Libraries," click the "+" button and add `QuartzCore.framework`.

###Finally: Import the headers

    #import "MOOPullGestureRecognizer.h"

...and a `MOOTriggerView`, either `MOOCreateView.h` or `MOORefreshView.h`

###Later: Update to the latest version

`cd` into the MOOPullGesture directory and run:

    git pull

# Credits
----------

Inspired by Pier-Olivier Thibault's [PHRefreshTriggerView](https://github.com/pothibo/PHRefreshTriggerView), [Clear's](http://www.realmacsoftware.com/clear/) pull-to-create, and [Twitter's](http://itunes.apple.com/us/app/twitter/id333903271?mt=8) pull-to-refresh.
