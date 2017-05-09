# LiveForest

活力森林，创业项目的第一个版本，做的运动社交。

已经从 App Store 下架，后台已挂，第三方库的 app key 也过期了。

代码可以运行，构造了大部分假数据。

除了平板和 iPhone 4s，所有的手机型号都适配了。界面绝大部分是用 Storyboard 或者 xib 做的。


## 
主要有5个部分：游戏、约伴、运动社、活动、个人主页：

![界面展示](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/界面展示.png)

其他设计图已经上传。

难点是手势操作和复杂的视图层次：
![手势](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V1/手势.gif)

这是运行效果的视频： https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V2/身动-演示.mov

这是目录结构：



这是某个控制器的代码组织：


某个函数的讲解：

HSHttpRequestTool 是对 AFNetWorking 的封装。字典转模型用的 MJExtension，tableView 下拉刷新用的 MJRefresh。


## 关于代码质量
代码写的很烂，比如视图和控制器互相强引用，有的模块没有数据模型(用字典代替)，很多地方有内存泄露。毕竟团队成员都是学生，有的是新手有的没学过iOS，手势和界面层次也非常复杂。很多功能都是熬夜通宵写的，老板也不同意重构代码。这个项目用来学习内存管理和优化，还是不错的。
