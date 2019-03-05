
# Hello World


----------------------------

[《招聘一个靠谱的 iOS》]:http://blog.sunnyxx.com/2015/07/04/ios-interview/
[微博@我就叫Sunny怎么了]: http://weibo.com/u/1364395395 
[zhoushejun]: https://github.com/zhoushejun/  "zhoushejun的Github"
[孙源]:http://weibo.com/u/1364395395

---------------------------

#索引
1.[风格纠错题](https://github.com/zhoushejun/iOSInterviewQuestionsAndAnswers/blob/master/招聘一个靠谱的%20iOS%20参考答案.md#1风格纠错题)

2.[@property 后面可以有哪些修饰符？](https://github.com/zhoushejun/)

3.[什么情况使用 weak 关键字，相比 assign 有什么不同？](https://github.com/zhoushejun/)

4.[怎么用 copy 关键字？](https://github.com/zhoushejun/)

5.[这个写法会出什么问题：](https://github.com/zhoushejun/)

```Objective-C
@property (copy) NSMutableArray *array;
```

6.[如何让自己的类用 copy 修饰符？如何重写带 copy 关键字的 setter？](https://github.com/zhoushejun/)

7.[@property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的](https://github.com/zhoushejun/)

8.[@protocol 和 category 中如何使用 @property](https://github.com/zhoushejun/)

9.[runtime 如何实现 weak 属性](https://github.com/zhoushejun/)

10.[@property中有哪些属性关键字？](https://github.com/zhoushejun/)

11.[weak属性需要在dealloc中置nil么？]

12.[@synthesize和@dynamic分别有什么作用？]

13.[ARC下，不显式指定任何属性关键字时，默认的关键字都有哪些？]

14.[用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？]

15.[@synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量么？]

16.[在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？]

17.[objc中向一个nil对象发送消息将会发生什么？]

18.[objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？]

19.[什么时候会报unrecognized selector的异常？]

20.[一个objc对象如何进行内存布局？（考虑有父类的情况）]

21.[一个objc对象的isa的指针指向什么？有什么作用？]

22.[下面的代码输出什么？]

```
@implementation Son : Father
- (id)init
{
self = [super init];
if (self) {
NSLog(@"%@", NSStringFromClass([self class]));
NSLog(@"%@", NSStringFromClass([super class]));
}
return self;
}
@end
```

23.[runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）]

24.[使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？]

25.[objc中的类方法和实例方法有什么本质区别和联系？]

26.[_objc_msgForward函数是做什么的，直接调用它将会发生什么？]

27.[runtime如何实现weak变量的自动置nil？]

28.[能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？]

29.[runloop和线程有什么关系？]

30.[runloop的mode作用是什么？]

31.[以+ scheduledTimerWithTimeInterval...的方式触发的timer，在滑动页面上的列表时，timer会暂定回调，为什么？如何解决？]

32.[猜想runloop内部是如何实现的？]

33.[objc使用什么机制管理对象内存？]

34.[ARC通过什么方式帮助开发者管理内存？]

35.[不手动指定autoreleasepool的前提下，一个autorealese对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）]

36.[BAD_ACCESS在什么情况下出现？]

37.[苹果是如何实现autoreleasepool的？]

38.[使用block时什么情况会发生引用循环，如何解决？]

39.[在block内如何修改block外部变量？]

40.[使用系统的某些block api（如UIView的block版本写动画时），是否也考虑引用循环问题？]

41.[GCD的队列（dispatch_queue_t）分哪两种类型？]

42.[如何用GCD同步若干个异步调用？（如根据若干个url异步加载多张图片，然后在都下载完成后合成一张整图）]

43.[dispatch_barrier_async的作用是什么？]

44.[苹果为什么要废弃dispatch_get_current_queue？]

45.[以下代码运行结果如何？]

```
- (void)viewDidLoad
{
[super viewDidLoad];
NSLog(@"1");
dispatch_sync(dispatch_get_main_queue(), ^{
NSLog(@"2");
});
NSLog(@"3");
}
```

46.[addObserver:forKeyPath:options:context:各个参数的作用分别是什么，observer中需要实现哪个方法才能获得KVO回调？]

47.[如何手动触发一个value的KVO]

48.[若一个类有实例变量NSString *_foo，调用setValue:forKey:时，可以以foo还是_foo作为key？]

49.[KVC的keyPath中的集合运算符如何使用？]

50.[KVC和KVO的keyPath一定是属性么？]

51.[如何关闭默认的KVO的默认实现，并进入自定义的KVO实现？]

52.[apple用什么方式实现对一个对象的KVO？]

53.[IBOutlet连出来的视图属性为什么可以被设置成weak?]

54.[IB中User Defined Runtime Attributes如何使用？]

55.[如何调试BAD_ACCESS错误]

56.[lldb（gdb）常用的调试命令？]


-------------
-------------
-------------



###1.风格纠错题
![imageURL](http://ww4.sinaimg.cn/large/51530583jw1eqo0v3zgr8j20qc0f2dja.jpg)

###2.[@property 后面可以有哪些修饰符？]

###3.[什么情况使用 weak 关键字，相比 assign 有什么不同？]

###4.[怎么用 copy 关键字？]

###5.[这个写法会出什么问题：]

```Objective-C
@property (copy) NSMutableArray *array;
```

###6.[如何让自己的类用 copy 修饰符？如何重写带 copy 关键字的 setter？]

###7.[@property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的]

###8.[@protocol 和 category 中如何使用 @property]

###9.[runtime 如何实现 weak 属性]

###10.[@property中有哪些属性关键字？]

###11.[weak属性需要在dealloc中置nil么？]

###12.[@synthesize和@dynamic分别有什么作用？]

###13.[ARC下，不显式指定任何属性关键字时，默认的关键字都有哪些？]

###14.[用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？]

###15.[@synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量么？]

###16.[在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？]

###17.[objc中向一个nil对象发送消息将会发生什么？]

###18.[objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？]

###19.[什么时候会报unrecognized selector的异常？]

###20.[一个objc对象如何进行内存布局？（考虑有父类的情况）]

###21.[一个objc对象的isa的指针指向什么？有什么作用？]

###22.[下面的代码输出什么？]

```
@implementation Son : Father
- (id)init
{
self = [super init];
if (self) {
NSLog(@"%@", NSStringFromClass([self class]));
NSLog(@"%@", NSStringFromClass([super class]));
}
return self;
}
@end
```

###23.[runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）]

24.[使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？]

25.[objc中的类方法和实例方法有什么本质区别和联系？]

26.[_objc_msgForward函数是做什么的，直接调用它将会发生什么？]

27.[runtime如何实现weak变量的自动置nil？]

28.[能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？]

29.[runloop和线程有什么关系？]

30.[runloop的mode作用是什么？]

31.[以+ scheduledTimerWithTimeInterval...的方式触发的timer，在滑动页面上的列表时，timer会暂定回调，为什么？如何解决？]

32.[猜想runloop内部是如何实现的？]

33.[objc使用什么机制管理对象内存？]

34.[ARC通过什么方式帮助开发者管理内存？]

35.[不手动指定autoreleasepool的前提下，一个autorealese对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）]

36.[BAD_ACCESS在什么情况下出现？]

37.[苹果是如何实现autoreleasepool的？]

38.[使用block时什么情况会发生引用循环，如何解决？]

39.[在block内如何修改block外部变量？]

40.[使用系统的某些block api（如UIView的block版本写动画时），是否也考虑引用循环问题？]

41.[GCD的队列（dispatch_queue_t）分哪两种类型？]

42.[如何用GCD同步若干个异步调用？（如根据若干个url异步加载多张图片，然后在都下载完成后合成一张整图）]

43.[dispatch_barrier_async的作用是什么？]

44.[苹果为什么要废弃dispatch_get_current_queue？]

45.[以下代码运行结果如何？]

```
- (void)viewDidLoad
{
[super viewDidLoad];
NSLog(@"1");
dispatch_sync(dispatch_get_main_queue(), ^{
NSLog(@"2");
});
NSLog(@"3");
}
```

46.[addObserver:forKeyPath:options:context:各个参数的作用分别是什么，observer中需要实现哪个方法才能获得KVO回调？]

47.[如何手动触发一个value的KVO]

48.[若一个类有实例变量NSString *_foo，调用setValue:forKey:时，可以以foo还是_foo作为key？]

49.[KVC的keyPath中的集合运算符如何使用？]

50.[KVC和KVO的keyPath一定是属性么？]

51.[如何关闭默认的KVO的默认实现，并进入自定义的KVO实现？]

52.[apple用什么方式实现对一个对象的KVO？]

53.[IBOutlet连出来的视图属性为什么可以被设置成weak?]

54.[IB中User Defined Runtime Attributes如何使用？]

55.[如何调试BAD_ACCESS错误]

56.[lldb（gdb）常用的调试命令？]







-------------






