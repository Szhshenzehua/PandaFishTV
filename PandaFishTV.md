#PandaFishTV

#目录

##第一章  前言

##第二章  在iOS编程语言中MVC设计理念 

   ###2.1 MVC的定义

   ###2.2 MVC的编程模式

## 第三章 我的所开发的APP

   ###3.1 热门

   ###3.2 分类

   ###3.3  直播

   ###3.4 我的收藏

   ###3.5 左边栏

  ## 第四章 总结

##第一章 前言

>　　APP（应用程序，Application的缩写）一般指手机软件
手机软件就是安装在手机上的软件，完善原始系统的不足与个性化。随着科技的发展，现在手机的功能也越来越多，越来越强大。不是像过去的那么简单死板，目前发展到了可以和电脑相媲美。手机软件与电脑一样，下载手机软件时还要考虑你购买这一款手机所安装的系统来决定要下相对应的软件。目前手机主流系统有以下：Symbian、Linux、Research in Motion、Windows Mobile.但是在2007年，苹果推出了运行自己软件的iPhone；Google宣布推出Android手机操作系统平台。手机软件就是安装在手机上的软件，完善原始系统的不足与个性化。随着科技的发展，现在手机的功能也越来越多，越来越强大。不是像过去的那么简单死板，目前发展到了可以和电脑相媲美。手机软件与电脑一样，下载手机软件时还要考虑你购买这一款手机所安装的系统来决定要下相对应的软件。目前手机主流系统有以下：Symbian、Linux、Research in Motion、Windows Mobile.但是在2007年，苹果推出了运行自己软件的iPhone；Google宣布推出Android手机操作系统平台

##第二章 在iOS编程语言中MVC设计理念 

###2.1 MVC的定义
>　　MVC开始是存在于桌面程序中的，M是指业务模型，V是指用户界面，C则是控制器，使用MVC的目的是将M和V的实现代码分离，从而使同一个程序可以使用不同的表现形式。比如一批统计数据可以分别用柱状图、饼图来表示。C存在的目的则是确保M和V的同步，一旦M改变，V应该同步更新。[1-2] 
模型－视图－控制器（MVC）是Xerox PARC在二十世纪八十年代为编程语言Smalltalk－80发明的一种软件设计模式，已被广泛使用。后来被推荐为Oracle旗下Sun公司Java EE平台的设计模式，并且受到越来越多的使用ColdFusion和PHP的开发者的欢迎。模型－视图－控制器模式是一个有用的工具箱，它有很多好处，但也有一些缺点。

##2.2 MVC的编程模式

>　　MVC是一种使用 MVC（Model View Controller 模型-视图-控制器）设计创建 Web 应用程序的模式：
　　Model（模型）表示应用程序核心（比如数据库记录列表）。
　　View（视图）显示数据（数据库记录）。
　　Controller（控制器）处理输入（写入数据库记录）。
　　MVC 模式同时提供了对 HTML、CSS 和 JavaScript 的完全控制。
　　Model（模型）是应用程序中用于处理应用程序数据逻辑的部分。通常模型对象负责在数据库中存取数据。
　　View（视图）是应用程序中处理数据显示的部分　通常视图是依据模型数据创建的。
Controller（控制器）是应用程序中处理用户交互的部分。通常控制器负责从视图读取数据，控制用户输入，并向模型发送数据。


>　MVC 分层有助于管理复杂的应用程序，因为您可以在一个时间内专门关注一个方面。例如，您可以在不依赖业务逻辑的情况下专注于视图设计。同时也让应用程序的测试更加容易。
MVC 分层同时也简化了分组开发。不同的开发人员可同时开发视图、控制器逻辑和业务逻辑。
　　MVC 提高了代码的不仅仅提高了代码的复用率，并且减少了程序的冗余。减轻了程序员的工作量
##第三章

###3.1 热门 

>　　该页面有两个接口，分别是推荐和返回的几个数据。
>　　 http://api.m.panda.tv/ajax_rmd_ads_get?__version=1.0.0.1140&__plat=ios&ts=%@
>　　 http://api.m.panda.tv/ajax_get_all_subcate?__plat=ios&__version=1.0.0.1140&ts=%@
参数ts表示时间戳。即计算机元年到现在的时间。在程序中通过代码来获取
>    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000.0000;
    NSString *timeString = [NSString stringWithFormat:@"%f",a];


>　　我们在向网络请求数据的时候，应当考虑多线程的问题。那么什么是多线程？多线程的定义是什么？首先我们应当了解，计算机在处理数据的时候，我们可以把其细分为时间片，意思就为，在一个时间片中之会处理一件事情，过来这个时间片，就会阻塞当前的任务。所有说如果只有一个线程，假如来了很多的任务。计算机在处理的时候就会非常的缓慢，具体可以体现在我们的UI上。即我们平时常见的卡死现象。
>　　
>　　
>　　  

###3.2分类
> 　接口http://mmmono.com/api/v2/waterfall。
> 

###3.3 直播

###3.4 我的收藏

> 在收藏中我使用了轻量级的数据库FMDB。并且对数据库的使用时，用单例这个设计模式。什么是单例，单例简单来说就这种类型的数据，在程序中就此一个。单例这种设计模式，是程序员们经过长久经验积累而得到的一种程序的设计模式。
> 
> 
> 
>       //非标准单例
    + (DBManager *)sharedManager {
    static DBManager *manager = nil;
    @synchronized(self) {
    //同步 执行 防止多线程操作
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
    }
    - (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        NSString *filePath = [self getFileFullPathWithFileName:@"app.db"];
        //2.创建database
        _database = [[FMDatabase alloc] initWithPath:filePath];
        //3.open
        //第一次 数据库文件如果不存在那么 会创建并且打开
        //如果存在 那么直接打开
        if ([_database open]) {
            //            NSLog(@"数据库打开成功");
            //创建表 不存在 则创建
            [self creatTable];
        }else {
            NSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
    　}　
     }

>在OC中，+ 表示类方法，在其他的类中使用的时候不用创建对象就可以使用
>
>创建表
    #pragma mark - 创建表
    - (void)creatTable {
         //字段: roomID  name roomKey imageURL fenshu
         NSString *sql = @"create table if not exists pandaFish(roomID Varchar(1024) Primary Key Not Null,name Varchar(1024),roomKey Varchar(1024),imageURl Varchar(1024),fenshu Varchar(1024))";
        //创建表 如果不存在则创建新的表
        BOOL isSuccees = [_database executeUpdate:sql];
         if (!isSuccees) {
        NSLog(@"creatTable error:%@",_database.lastErrorMessage);
     }
    }
    //#pragma make - 删除表
     - (BOOL)dropTable {
     //    NSString *sql = @"select * from appInfo";
      NSString *str = @"delete from pandaFish";
         return [_database executeUpdate:str];
}


> ####数据库的操作
> 
>
  　            在轻量级的数据库中，也就是本APP中我们使用删除指定的元素，增加数据，根据指定的类型，这条记录在数据库中是否存在。
    // 删除指定的元素
     - (BOOL)deleteValueWithRoomId:(NSString *)roomID{
      NSString *str = [NSString stringWithFormat:@"delete from pandaFish where roomID = %@",roomID];
      return [_database executeUpdate:str];
     }

 
>  增加数据 
>           
>     //增加 数据 收藏/浏览/下载记录
     //存储类型 favorites downloads browses
    - (void)insertModel:(ShouCangModel *)model {
    ShouCangModel *relutModel = model;
    if ([self isExistAppForRoomID:model.roomID]) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
        return ;
    }
    NSString *sql = @"insert into pandaFish(roomID,name,roomKey,ImageURl,fenshu) values (?,?,?,?,?)";
    BOOL isSuccess = [_database executeUpdate:sql,relutModel.roomID,relutModel.name,relutModel.roomKey,relutModel.imageURl,relutModel.pinFen];
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
     }
    }
  在添加数的时候，我选择了添加数据模型，也是我们所说的model。这样做，可在我们添加数据的时候形式清晰。减少代码量。
>
>####查找数据
>    
     //根据指定的类型 返回 这条记录在数据库中是否存在
    - (BOOL)isExistAppForRoomID:(NSString *)roomID {
    NSString *sql = @"select * from pandaFish where roomID = ?";
    FMResultSet *rs = [_database executeQuery:sql,roomID];
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
    }
在程序中，我们很多的地方都用到了这个方法，用这个方法作为一个参数，来确定收藏按钮的图片，以及点击收藏按钮以后的响应事件。
>
>而在我的收藏页面中，我们需要加载数据源，以及刷新UI，并且实现一些方法就可以在界面上得到我们数据了
>
>     - (void)loadDataSource {
       self.dataSource = [NSMutableArray new];
       self.dataSource = (NSMutableArray *) [[DBManager sharedManager] readAllModelsWithFenShu];
       // 结束刷新
      [self endRedresh];
      // 刷新UI
      [self.tableView reloadData];
    }

>

###3.5 左边栏

###3.6 程序

##第四章 总结 

>　　本程序实现了



###参考文献  


###致谢  
>　谢谢指导老师。 通过这段时间的研究设计学习，我学到了很多以前不知道的知识，并且在学习中培养了一种做事情一丝不苟的态度和耐心，为以后的工作打下了坚实的基础。
　　在此我要向我们论文的指导老师表示衷心的感谢，可以让我通过这次机会系统学习了OC，并能具体结合实践生活完成直播平台，老师幽默，风趣，严谨的教学作风将是我学习的榜样。