//
//  MyCardTableViewCell.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/12.
//

#import "MyCardTableViewCell.h"
#import "TCCloudTalkingImageTool.h"
#import "TCMyCardModel.h"

@interface MyCardTableViewCell()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardIDL;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardStatusL;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardTimeL;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *CardTypeL;


@end
@implementation MyCardTableViewCell

+(instancetype)viewFromBundleXib{
    // 初始化时加载collectionCell.xib文件
    NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TCCloudTalking.bundle"]];
    NSArray *arrayOfViews = [bundle loadNibNamed:@"MyCardTableViewCell" owner:self options:nil];
    
    // 如果路径不存在，return nil
    
    if(arrayOfViews.count < 1){return nil;}
    // 如果xib中view不属于UICollectionViewCell类，return nil
    if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]]){
        return nil;
    }
    // 加载nib
    return [arrayOfViews objectAtIndex:0];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.CardTypeL.text = @"门\n禁\nIC\n卡";
    self.CardTypeL.numberOfLines = [self.CardTypeL.text length];
    self.CardTypeL.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];

    
}


- (void)setCardItems:(TCMyCardModel *)CardItems
{
    _CardItems = CardItems;
    self.CardIDL.text = CardItems.num;
    if (CardItems.expirationTime) {
        
        // 时间字符串
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *createdAtDate = [fmt dateFromString:CardItems.expirationTime];
        int resultValue = 0;
        resultValue = [self compareOneDay:[self getCurrentTime] withAnotherDay:createdAtDate];
        if (resultValue == -1) {
            self.CardTimeL.text = [NSString stringWithFormat:@"有效期:%@",CardItems.expirationTime];
            self.CardStatusL.text = @"正常使用";
            self.CardStatusL.textColor = [UIColor whiteColor];
        }else if (resultValue == 0)
        {
            self.CardTimeL.text = [NSString stringWithFormat:@"有效期:%@",CardItems.expirationTime];
            self.CardStatusL.text = @"即将过期";
            self.CardStatusL.textColor = [UIColor yellowColor];
        }else
        {
            self.CardTimeL.text = [NSString stringWithFormat:@"有效期:%@",CardItems.expirationTime];
            self.CardStatusL.text = @"已经过期";
            self.CardStatusL.textColor = [UIColor redColor];
        }
        NSLog(@"结果---%i",[self compareOneDay:[self getCurrentTime] withAnotherDay:createdAtDate]);
        
        
        
    }else
    {
        self.CardTimeL.text = @"有效期:无限期";
        self.CardStatusL.text = @"正常使用";
        self.CardStatusL.textColor = [UIColor whiteColor];
    }
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    return date;
}
-
(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1 is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}





@end
