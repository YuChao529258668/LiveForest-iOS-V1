# LiveForest

活力森林，创业项目的第一个版本，做的运动社交。

已经从 App Store 下架，后台已挂，第三方库的 app key 也过期了。

代码可以运行，构造了大部分假数据。

除了平板和 iPhone 4s，所有的手机型号都适配了。界面绝大部分是用 Storyboard 或者 xib 做的。


## App 介绍
主要有5个部分：游戏、约伴、运动社、活动、个人主页：

![界面展示](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/界面展示.png)

其他设计图已经上传。

难点是手势操作和复杂的视图层次：

![手势](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/手势.gif)

上滑可以放大小卡片，在缩放的过程中跟随手指水平移动。小卡片上面放了一个 UITableView，滚动到顶部时才可以下滑缩小小卡片。

手势要考虑的东西很多，比如缩小时可以跟着手指离开屏幕边缘很远，缩放过程中可以跟着手指左右移动，放大结束后显示哪一个卡片，缩放过程中子控件的透明度变化，卡片放大后和 UITableView 的滚动手势冲突，以及屏幕适配等等。

这是运行效果的视频：

https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/LiveForest.mp4

在某些界面是通过下滑手势返回上一个界面。切换模块的时候，小卡片不会跟着滚动。

界面框架是，根控制器先放一个全屏的 UICollectionView，每个 cell 放一个控制器的 view。然后底部是一个大约半屏高度的 UIScrollView，上面放 UICollectionView，cell 上面放一个 UITableView。。。


这是项目结构：

![项目结构](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/项目结构.png)



## 关于代码质量
代码写的很烂，自己看都会忍不住发笑，比如视图和控制器互相强引用，有的模块没有数据模型(用字典代替)，很多地方有内存泄露。毕竟团队成员都是学生，有的是新手有的没学过iOS，手势和界面层次也非常复杂。很多功能都是熬夜通宵写的，老板也不同意重构代码。这个项目用来学习内存管理和优化，还是不错的。
