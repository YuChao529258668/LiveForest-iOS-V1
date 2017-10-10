# LiveForest

活力森林，创业项目的第一个版本，做的运动社交。

已经从 App Store 下架，后台已挂，构造了大部分假数据。

除了平板和 iPhone 4s，所有的手机型号都适配了。界面绝大部分是用 Storyboard 或者 xib 做的。


## App 介绍
主要有5个部分：游戏、约伴、运动社、活动、个人主页：

![界面展示](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/界面展示.png)

其他设计图已经上传。

难点是手势操作和复杂的视图层次：

![手势](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/手势.gif)

上滑可以放大小卡片，在缩放的过程中跟随手指水平移动。小卡片上面放了一个 UITableView，滚动到顶部时才可以下滑缩小小卡片。

手势要考虑的东西很多，比如缩小时可以跟着手指离开屏幕边缘很远，缩放过程中可以跟着手指左右移动，放大结束后显示哪一个卡片，缩放过程中子控件的透明度变化，卡片放大后和 UITableView 的滚动手势冲突，以及屏幕适配等等。

这是优酷的运行效果视频：

http://v.youku.com/v_show/id_XMjc1OTgyNzE1Mg==.html?spm=a2h3j.8428770.3416059.1

或者从 github 下载视频：

https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/LiveForest.mp4

在某些界面是通过下滑手势返回上一个界面。切换模块的时候，小卡片不会跟着滚动。

界面框架是，根控制器先放一个全屏的 UICollectionView，每个 cell 放一个控制器的 view。然后底部是一个大约半屏高度的 UIScrollView，上面放 UICollectionView，cell 上面放一个 UITableView。。。


这是项目结构：

![项目结构](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/项目结构.png)
