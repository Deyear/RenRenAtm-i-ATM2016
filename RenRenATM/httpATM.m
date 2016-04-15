//
//  httpATM.m
//  RenRenATM
//
//   
//
//

#import "httpATM.h"
#import "AFNetworking/AFNetworking.h"
@implementation httpATM

+(void)setphone:(NSString*)arr  setint:(void (^)(NSDictionary * dic))blok
{
     NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/atm?relation=services,evaluations"];
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   float currentLatitude = [userDefaults floatForKey:@"currentLatitude"];
   float currentLongtitude = [userDefaults floatForKey:@"currentLongtitude"];
    NSString *longitudelongitude = [NSString stringWithFormat:@"%f",currentLongtitude];
    NSString *latitudelatitude = [NSString stringWithFormat:@"%f",currentLatitude];
    NSDictionary *paratemetrs = @{@"longitude":longitudelongitude,
                                  @"latitude":latitudelatitude,
                                  @"radius":@"3000"};
    //                NSLog(@"========%@",paratemetrs);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:str parameters:paratemetrs progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //                    NSLog(@"-------------%@",responseObject);
        
        blok(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
