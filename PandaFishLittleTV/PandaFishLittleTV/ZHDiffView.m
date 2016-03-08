//
//  ZHDiffView.m
//  PandaFishLittleTV
//
//  Created by qianfeng on 16/2/26.
//  Copyright © 2016年 申泽华. All rights reserved.
//

#import "ZHDiffView.h"
#import <UIImageView+WebCache.h>


@interface ZHDiffView()

{
    UIView *_baseView;
    BOOL anibool;
    int _index;
}

@end
@implementation ZHDiffView

-(instancetype)init
{
    
    if (self=[super init]) {
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.height > 0) {
        if( _baseView==nil){
            [self viewDidLoad];
        }
    }
    
}
- (void)viewDidLoad
{
    _click=^(int i)
    {
        //NSLog(@"单击了第%d项",i);
    };
    _baseView=[[UIView alloc]init];
    _baseView.frame=self.bounds;
   // NSLog(@"_%f",_baseView.frame.size.height);
    [self addSubview:_baseView];
    //  [self createView];
    
    anibool=YES;
//        UISwipeGestureRecognizer *rec = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
//    
//        rec.direction = UISwipeGestureRecognizerDirectionUp;
//        [self addGestureRecognizer:rec];
//        UISwipeGestureRecognizer *recdown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
//        recdown.direction = UISwipeGestureRecognizerDirectionDown;
//        [self addGestureRecognizer:recdown];
//    
    
    
//    /*添加轻扫手势*/
    //注意一个轻扫手势只能控制一个方向，默认向右，通过direction进行方向控制
    UISwipeGestureRecognizer *swipeGestureToRight =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    //swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;//默认为向右轻扫
    [self addGestureRecognizer:swipeGestureToRight];
//
   
    UISwipeGestureRecognizer *swipeGestureToLeft =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    swipeGestureToLeft.direction =UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGestureToLeft];
//
}

- (void)swipeImage:(UISwipeGestureRecognizer *)swzer {
    
    if (swzer.direction == UISwipeGestureRecognizerDirectionRight) {
        // 向右滑动
        
        [self setAllFramge:1];
       // NSLog(@"油化");
    }
    
    if (swzer.direction == UISwipeGestureRecognizerDirectionLeft) {
        // 向左滑动
        [self setAllFramge:0];
        //NSLog(@"zuohua");
    }
}


-(void)setImages:(NSArray *)images
{
    
    _images = images;
    
    int count = (int)images.count;
    // 数组长度 / 2
    int mid = count / 2;
    
    CGFloat smallH = 30;
    
    if (count > 6) {
        smallH = 20;
    }
    //~~~~~~
    // 368 -  60 * mid
    CGFloat myH = _baseView.frame.size.height - smallH * mid * 2;
    
    for (int i = 0; i < count; i++) {
        // if (i!=mid) {
        
        UIImageView *view1=[[UIImageView alloc]init];
        
        /*
         5张图片  i = 0 , dd = 2.5 -0   第一张图 2.5 ;
         
         i = 1, dd = 2.5 - 1           第二张图 1.5
         
         i = 2 , dd = 2.5 - 2         第三张图 0.5
         
         i = 3  dd = 3 - 2.5         第四张图  0.5
         
         i = 4 dd = 4 - 2.5           第五张图 1.5
         */
        
        CGFloat dd = abs(mid-i);
        
        
        // 第一个函数 mid 2.5  1 2 3
        if (i< mid ) {
            
           view1.frame=CGRectMake(smallH*dd, smallH*i, 65 + 15 * i  , smallH + 20 );
            
//            view1.frame = CGRectMake(0 , 20, 30 + 10 * i , myH-20+i*5);
//            
            //第二个函数 4 5
        }else if(i>mid)
        {
//            
            view1.frame=CGRectMake(smallH*dd , myH+smallH*(i-1) - 20, 90 - 10*(i - mid), smallH + 20);
            
//            view1.frame=CGRectMake(_baseView.frame.size.width- 90 + 10 * i, 20,70 - i *10 , myH + 90 - i * 10);
            
            
//             view1.frame=CGRectMake(_baseView.frame.size.width- 90 + 10 * i, 20,_baseView.frame.size.width- 180 , myH - i * 5);
            
        }else
        {
            // 第三个函数 即当前显示的图片大小
           view1.frame=CGRectMake(10, smallH*mid, _baseView.frame.size.width- 110, myH -20 );
            
//            
//            view1.frame=CGRectMake( 90, 20, _baseView.frame.size.width- 180, myH );
        }
        
       //  本地 view1.image = images[i];
        
        
        [view1 sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:[UIImage imageNamed:@"person2"]];
        
        view1.backgroundColor=[UIColor clearColor];
        view1.tag= i + 1;
        //view1.clipsToBounds  = YES;
        //添加四个边阴影
        view1.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        view1.layer.shadowOffset = CGSizeMake(4,4);//偏移距离
        view1.layer.shadowOpacity = 0.8;//不透明度
        view1.layer.shadowRadius = 2.0;//半径
        // view1.contentMode=UIViewContentModeScaleAspectFill;
        // view1.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        
        [_baseView addSubview:view1];
        
        // }
        // _baseView.backgroundColor = [UIColor redColor];
        
    }
    
    CGFloat btnX=_baseView.frame.origin.x;
    CGFloat btnY=_baseView.frame.origin.y;
    CGFloat btnW=_baseView.frame.size.width;
    CGFloat btnH=smallH*mid;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
    btn.tag=1;
    // btn.backgroundColor=[UIColor yellowColor];
    [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(btnX, btnY+myH+smallH*mid, btnW, btnH);
    //  btn2.backgroundColor=[UIColor blueColor];
    btn2.tag=2;
    [btn2 addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(2, smallH*mid, _baseView.frame.size.width-4, myH);
    // btn3.backgroundColor=[UIColor blackColor];
    btn3.tag=3;
    [btn3 addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn3];
    
}
-(void)setImageNames:(NSArray *)imageNames
{
    _imageNames=imageNames;
    int count=(int)imageNames.count;
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<count; i++) {
        UIImage *image=[UIImage imageNamed:imageNames[i]];
        [array addObject:image];
    }
    [self setImages:array];
    
}

-(void)swipeUp:(UISwipeGestureRecognizer *)zer
{
    if (zer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        [self setAllFramge:0];
    }else if(zer.direction==UISwipeGestureRecognizerDirectionDown)
    {
        [self setAllFramge:1];
    }
}

-(void)chick:(UIButton *)btn
{
    if (btn.tag==3) {
        
        _click(_index);
       // NSLog(@"单击了");
    }else
    {
        [self setAllFramge:(int)btn.tag];
    }
    
}
-(void)setAllFramge:(int)tag
{
    
    if (anibool == NO) {
        return;
    }
    
    anibool = NO;
    unsigned long count=_baseView.subviews.count;
    
    if (tag == 1) {
        CGFloat minH=0;
        UIView *minHiew;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            CGFloat min=CGRectGetMaxY(view1.frame);
            if (min>minH) {
                minH=min;
                minHiew=[_baseView viewWithTag:i];
            }
            
        }
        if (minH>0) {
            for (int j=0; j<count; j++)
                [_baseView sendSubviewToBack:minHiew];
            
        }
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=[[_baseView viewWithTag:1] frame];
            for (int i=1; i<count+1; i++)
            {
                
                if (i==count) {
                    [[_baseView viewWithTag:i] setFrame:rect];
                }
                else
                {
                    [[_baseView viewWithTag:i] setFrame:[[_baseView viewWithTag:i+1] frame]];
                }
            }
            
            
        } completion:^(BOOL finished) {
            anibool=YES;
            [self bigtop];
        }];
        
    }else
    {
        
        CGFloat minH=10000;
        UIView *minHiew;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            
            CGFloat min=CGRectGetMinY(view1.frame);
            if (min<minH) {
                minH=min;
                
                minHiew=[_baseView viewWithTag:i];
            }
        }
        if (minH<10000) {
            for (int j=0; j<count; j++)[_baseView sendSubviewToBack:minHiew];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=[[_baseView viewWithTag:count] frame];
            for (int i=1; i<count+1; i++)
            {
                
                if (i==count) {
                    [[_baseView viewWithTag:1] setFrame:rect];
                }
                else
                {
                    [[_baseView viewWithTag:count-i+1] setFrame:[[_baseView viewWithTag:count-i] frame]];
                }
            }
        } completion:^(BOOL finished) {
            anibool=YES;
            [self bigtop];
            
        }];
    }
}

-(void)bigtop
{
    unsigned long count=_baseView.subviews.count;
    CGFloat maxW=0;
    UIView *maxHiew;
    for (int i=1; i<count+1; i++)
    {
        UIView *view1=[_baseView viewWithTag:i];
        if (view1.frame.size.width>maxW) {
            maxW=view1.frame.size.width;
            maxHiew=[_baseView viewWithTag:i];
            _index=i;
        }
        
    }
    if (maxW>0) {
        for (int j=0; j<count; j++)[_baseView bringSubviewToFront:maxHiew];
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
