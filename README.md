# KeyboardManager

> 主要功能

集成了带X的身份证键盘和tableView,scrollView中键盘遮挡的问题

身份键盘:带X键,长按删除可以持续删除,在键盘上左滑右滑可以控制光标

键盘遮挡:调用一行代码,处理键盘遮挡问题

> 实现思路

身份键盘:
基于UIView开发,利用了UITextView和UITextField的inputView属性来处理

键盘遮挡:
给UIScrollView添加分类,将键盘的高度变化通知集成于分类中.利用runtime在UIViewController的生命周期方法中(viewDidAppear:和viewDidDisappear:)追加发送一个通知.在UIScrollView的分类中接收该通知,从而达到添加移除键盘的通知.

## 提交记录

2017.06.07 --  移除了测试时候使用dealloc函数,添加了键盘弹出和消失的block,且内部已经处理了相应的动画效果
