-------------------------------
# Hello World
-------------------------------

#索引

2. @property 后面可以有哪些修饰符？
```
a. 线程安全的 atomic/nonatomic
atomic：原子性，这个属性是为了保证程序在多线程下，编译器会自动生成自旋锁代码，避免该变量的读写不同步问题，提供多线程安全，即多线程中只能有一个线程对它访问
nonatomic：非原子性，非线程安全，多个线程可以同时对其进行访问，使用该属性编译器会少生成加锁代码，提高性能和效率。

b. 访问权限的 readonly/readwrite
readwrite：默认  拥有getter/setter方法  可读可写
readonly：只读属性， 只会生成getter方法，不会生成setter方法

c. 内存管理（ARC）assign/strong/copy/weak

assign  默认，适用于基本数据类型：NSInteger、CGFloat和C数据类型 int、float等

strong  对应MRC中的retain，强引用，只有OC对象才能够使用该属性，它使对象的引用计数加1

weak 弱引用，只是单纯引用某个对象，但是并未拥有该对象，即一个对象被持有无数个弱引用，只要没有强引用指向它，那么它就会被清除释放

copy 为减少对上下文的依赖而引入的机制，可以理解为内容的拷贝内容被拷贝后，内存中会有两个存储空间存储相同的内容。指针不是同一个地址

### UI控件使用weak的原因：
UI控件之所以可以使用弱指针，是因为控制器有强指针指向UIView，UIView 有强指针指向Subviews数组，数组中由强指针指向控件

### 代理必须是weak，因为代理一般都是指向控制器，会造成循环引用，无法释放，造成内存泄露

### 关于weak 与assign
在ARC，出现循环引用的时候，必须有一端使用weak，weak修饰的对象销毁的时候，指针会自动设置为nil，而assign不会，assign可以用于非OC对象，而weak必须用于OC对象


### 关于copy与strong
NSString、NSArray、NSDictionary常用copy，为什么不用strong？
strong是强引用，指向的是同一个内存地址，copy是内容拷贝，会另外开辟内存空间，指针指向一个不同的内存地址，copy返回的是一个不可变对象，如果使用strong修饰可变对象，那么对象就会有可能被不经意间修改，有时不是我们想要的，而copy不会发生这种意外。


d. 内存管理（MRC）assign/retain/release

e. 指定方法名 setter = / getter = 


### 关于@property的作用：使用@property，编译器会自动为我们添加getter和setter方法

```

3. 什么情况使用 weak 关键字，相比 assign 有什么不同？
```
在ARC，出现循环引用的时候，必须有一端使用weak，weak修饰的对象销毁的时候，指针会自动设置为nil，而assign不会，assign可以用于非OC对象，而weak必须用于OC对象
```

4. 怎么用 copy 关键字？
```
用途：

NSString、NSArray、NSDictionary 等等经常使用copy关键字，是因为他们有对应的可变类型：NSMutableString、NSMutableArray、NSMutableDictionary；
block 也经常使用 copy 关键字，具体原因见官方文档：Objects Use Properties to Keep Track of Blocks：
block 使用 copy 是从 MRC 遗留下来的“传统”,在 MRC 中,方法内部的 block 是在栈区的,使用 copy 可以把它放到堆区.在 ARC 中写不写都行：对于 block 使用 copy 还是 strong 效果是一样的，但写上 copy 也无伤大雅，还能时刻提醒我们：编译器自动对 block 进行了 copy 操作。如果不写 copy ，该类的调用者有可能会忘记或者根本不知道“编译器会自动对 block 进行了 copy 操作”，他们有可能会在调用之前自行拷贝属性值。这种操作多余而低效。你也许会感觉我这种做法有些怪异，不需要写依然写。如果你这样想，其实是你“日用而不知”，你平时开发中是经常在用我说的这种做法的，比如下面的属性不写copy也行，但是你会选择写还是不写呢？

@property (nonatomic, copy) NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId {
self = [super init];
if (!self) {
return nil;
}
_userId = [userId copy];
return self;
}
enter image description here

下面做下解释： copy 此特质所表达的所属关系与 strong 类似。然而设置方法并不保留新值，而是将其“拷贝” (copy)。 当属性类型为 NSString 时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个 NSMutableString 类的实例。这个类是 NSString 的子类，表示一种可修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。所以，这时就要拷贝一份“不可变” (immutable)的字符串，确保对象中的字符串值不会无意间变动。只要实现属性所用的对象是“可变的” (mutable)，就应该在设置新属性值时拷贝一份。

用 @property 声明 NSString、NSArray、NSDictionary 经常使用 copy 关键字，是因为他们有对应的可变类型：NSMutableString、NSMutableArray、NSMutableDictionary，他们之间可能进行赋值操作，为确保对象中的字符串值不会无意间变动，应该在设置新属性值时拷贝一份。
```

5. 这个写法会出什么问题：

```
Objective-C
@property (copy) NSMutableArray *array;

两个问题：1、添加,删除,修改数组内的元素的时候,程序会因为找不到对应的方法而崩溃.因为 copy 就是复制一个不可变 NSArray 的对象；2、使用了 atomic 属性会严重影响性能 ；

比如下面的代码就会发生崩溃

// .h文件
// 下面的代码就会发生崩溃

@property (nonatomic, copy) NSMutableArray *mutableArray;

// .m文件
// 下面的代码就会发生崩溃

NSMutableArray *array = [NSMutableArray arrayWithObjects:@1,@2,nil];
self.mutableArray = array;
[self.mutableArray removeObjectAtIndex:0];
接下来就会奔溃：

-[__NSArrayI removeObjectAtIndex:]: unrecognized selector sent to instance 0x7fcd1bc30460
第2条原因，如下：

该属性使用了同步锁，会在创建时生成一些额外的代码用于帮助编写多线程程序，这会带来性能问题，通过声明 nonatomic 可以节省这些虽然很小但是不必要额外开销。

在默认情况下，由编译器所合成的方法会通过锁定机制确保其原子性(atomicity)。如果属性具备 nonatomic 特质，则不使用同步锁。请注意，尽管没有名为“atomic”的特质(如果某属性不具备 nonatomic 特质，那它就是“原子的”(atomic))。

在iOS开发中，你会发现，几乎所有属性都声明为 nonatomic。

一般情况下并不要求属性必须是“原子的”，因为这并不能保证“线程安全” ( thread safety)，若要实现“线程安全”的操作，还需采用更为深层的锁定机制才行。例如，一个线程在连续多次读取某属性值的过程中有别的线程在同时改写该值，那么即便将属性声明为 atomic，也还是会读到不同的属性值。

因此，开发iOS程序时一般都会使用 nonatomic 属性。但是在开发 Mac OS X 程序时，使用 atomic 属性通常都不会有性能瓶颈。

```

6. 如何让自己的类用 copy 修饰符？如何重写带 copy 关键字的 setter？
```
```

7. @property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的？
```
@property = ivar + getter + setter;
实例变量+get方法+set方法,也就是说使用@property 系统会自动生成setter和getter方法;
```

8. @protocol 和 category 中如何使用 @property
```
1.在 protocol 中使用 property 只会生成 setter 和 getter 方法声明,我们使用属性的目的,是希望遵守我协议的对象能实现该属性
2.category 使用 @property 也是只会生成 setter 和 getter 方法的声明,如果我们真的需要给 category 增加属性的实现,需要借助于运行时的两个函数：
3.objc_setAssociatedObject
4.objc_getAssociatedObject
```

9.[runtime 如何实现 weak 属性](https://github.com/zhoushejun/)

10.  数据结构
```
数据结构：是指相互之间存在着一种或多种关系的数据元素的集合和该集合中数据元素之间的关系组成。
包括三个组成成分：数据的逻辑结构、物理结构（存储结构）、运算结构。
数据的逻辑结构：
1、集合（数据之间无关系）
2、线性结构（一对一）
3、树形结构（一对多）
4、图形结构（多对多）
数据的物理结构：指数据在计算机存储空间的存放形式；
顺序存储、链表存储、索引存储、散列存储
常用的数据结构：
1、数组
2、栈（先进后出、线性表）
3、队列（先进先出、后进后出、线性表）
4、链表（每个节点包括两个部分：一个存储数据元素的数据域、另一个存储下一个节点地址的指针域）
5、树
6、图
7、堆（是一种动态的树形结构）
8、散列表
而在C／C++中，我们常说的堆区、栈区则并不是数据结构中的堆、栈，而是满足数据结构中堆、栈性质的数据结构的形式。
一个程序在加载到内存中时；抽象的将编译的程序所占用的内存分为以下几个部分：
1、栈区（stack）— 由编译器自动分配释放 ，存放函数的参数、局部变量等。其操作方式类似于数据结构中的栈。
2、堆区（heap）— 由程序员分配释放， 若程序员不释放，程序结束时可能由OS回收。注意它与数据结构中的堆是两回事，分配方式倒是类似于链表。
3、静态区（static）—全局变量和局部静态变量的存储是放在一块的。程序结束后由系统释放。
4、文字常量区—常量字符串就是放在这里的，程序结束后由系统释放 。
5、程序代码区— 存放函数体的二进制代码。
```

11. weak属性需要在dealloc中置nil么？
```
不需要。
在ARC环境无论是强指针还是弱指针都无需在 dealloc 设置为 nil ， ARC 会自动帮我们处理
即便是编译器不帮我们做这些，weak也不需要在 dealloc 中置nil
```
12. @synthesize和@dynamic分别有什么作用？
```
1.@synthesize告诉编译器：如果你没有手动实现setter和getter方法，编译器会自动帮你生成
2.@dynamic告诉编译器：用户需要自己实现setter和getter方法，不自动生成。假如一个属性被声明为 @dynamic var，然后你没有提供 @setter方法和 @getter 方法，编译的时候没问题，但是当程序运行到 instance.var = someVar，由于缺 setter 方法会导致程序崩溃；或者当运行到 someVar = var时，由于缺 getter 方法同样会导致崩溃。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定。
```

13. ARC下，不显式指定任何属性关键字时，默认的关键字都有哪些？
```
1.对应基本数据类型默认关键字是 atomic,readwrite,assign 
2.对于普通的 Objective-C 对象 atomic,readwrite,strong
```

14. 用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？
```
1.因为父类指针可以指向子类对象,使用 copy 的目的是为了让本对象的属性不受外界影响,使用 copy 无论给我传入是一个可变对象还是不可对象,我本身持有的就是一个不可变的副本.
2.如果我们使用 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性.
copy 此特质所表达的所属关系与 strong 类似。然而设置方法并不保留新值，而是将其“拷贝” (copy)。 当属性类型为 NSString 时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个 NSMutableString 类的实例。这个类是 NSString 的子类，表示一种可修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。所以，这时就要拷贝一份“不可变” (immutable)的字符串，确保对象中的字符串值不会无意间变动。只要实现属性所用的对象是“可变的” (mutable)，就应该在设置新属性值时拷贝一份。
```
15. @synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量么？

16. 在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？

17. objc中向一个nil对象发送消息将会发生什么？
```
在 Objective-C 中向 nil 发送消息是完全有效的——只是在运行时不会有任何作用:

如果一个方法返回值是一个对象，那么发送给nil的消息将返回0(nil)。例如：
Person * motherInlaw = [[aPerson spouse] mother];
1. 如果 spouse 对象为 nil，那么发送给 nil 的消息 mother 也将返回 nil。 2. 如果方法返回值为指针类型，其指针大小为小于或者等于sizeof(void*)，float，double，long double 或者 long long 的整型标量，发送给 nil 的消息将返回0。 2. 如果方法返回值为结构体,发送给 nil 的消息将返回0。结构体中各个字段的值将都是0。 2. 如果方法的返回值不是上述提到的几种情况，那么发送给 nil 的消息的返回值将是未定义的。

具体原因如下：

objc是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)。

objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行，然后在发送消息的时候，objc_msgSend方法不会返回值，所谓的返回内容都是具体调用时执行的。 那么，回到本题，如果向一个nil对象发送消息，首先在寻找对象的isa指针时就是0地址返回了，所以不会出现任何错误。
```

18. objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？
```
[obj foo];在objc编译时，会被转意为：objc_msgSend(obj, @selector(foo));。
```

19. 什么时候会报unrecognized selector的异常？
```
简单来说：

当调用该对象上某个方法,而该对象上没有实现这个方法的时候， 可以通过“消息转发”进行解决。

简单的流程如下，在上一题中也提到过：

objc是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)。

objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行，如果，在最顶层的父类中依然找不到相应的方法时，程序在运行时会挂掉并抛出异常unrecognized selector sent to XXX 。但是在这之前，objc的运行时会给出三次拯救程序崩溃的机会：

1. Method resolution
objc运行时会调用+resolveInstanceMethod:或者 +resolveClassMethod:，让你有机会提供一个函数实现。如果你添加了函数，那运行时系统就会重新启动一次消息发送的过程，否则 ，运行时就会移到下一步，消息转发（Message Forwarding）。

2. Fast forwarding
如果目标对象实现了-forwardingTargetForSelector:，Runtime 这时就会调用这个方法，给你把这个消息转发给其他对象的机会。 只要这个方法返回的不是nil和self，整个消息发送的过程就会被重启，当然发送的对象会变成你返回的那个对象。否则，就会继续Normal Fowarding。 这里叫Fast，只是为了区别下一步的转发机制。因为这一步不会创建任何新的对象，但下一步转发会创建一个NSInvocation对象，所以相对更快点。 3. Normal forwarding

这一步是Runtime最后一次给你挽救的机会。首先它会发送-methodSignatureForSelector:消息获得函数的参数和返回值类型。如果-methodSignatureForSelector:返回nil，Runtime则会发出-doesNotRecognizeSelector:消息，程序这时也就挂掉了。如果返回了一个函数签名，Runtime就会创建一个NSInvocation对象并发送-forwardInvocation:消息给目标对象。
```


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
```
类方法：
1.类方法是属于类对象的
2.类方法只能通过类对象调用
3.类方法中的self是类对象
4.类方法可以调用其他的类方法
5.类方法中不能访问成员变量
6.类方法中不能直接调用对象方法

实例方法：
1.实例方法是属于实例对象的
2.实例方法只能通过实例对象调用
3.实例方法中的self是实例对象
4.实例方法中可以访问成员变量
5.实例方法中直接调用实例方法
6.实例方法中也可以调用类方法(通过类名)
```

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

39. 在block内如何修改block外部变量？
```
Block不允许修改外部变量的值，(这里所说的外部变量的值，指的是栈中指针的内存地址)，__block 所起到的作用就是只要观察到该变量被 block 所持有，就将“外部变量”在栈中的内存地址放到了堆中，进而在block内部也可以修改外部变量的值。
```

40.[使用系统的某些block api（如UIView的block版本写动画时），是否也考虑引用循环问题？]
```
```
41. GCD的队列（dispatch_queue_t）分哪两种类型？
```
1.串行队列Serial Dispatch Queue
2.并行队列Concurrent Dispatch Queue
```
42.[如何用GCD同步若干个异步调用？（如根据若干个url异步加载多张图片，然后在都下载完成后合成一张整图）]

43. dispatch_barrier_async的作用是什么？
```
通过dispatch_barrier_async函数提交的任务会等它前面的任务执行完才开始，然后它后面的任务必须等它执行完毕才能开始. 必须使用dispatch_queue_create创建的队列才会达到上面的效果.
```

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


