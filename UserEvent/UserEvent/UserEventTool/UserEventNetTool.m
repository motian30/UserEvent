//
//  UserEventNetTool.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "UserEventNetTool.h"
#import "UserEventDataTool.h"

@implementation UserEventNetTool

+ (void)uploadUserEvents{
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.81.118:8090/Info"];
    NSArray *data = [UserEventDataTool readDataFromUserEventPlist];
    
 
    NSLog(@"UserEvent %@",data);
    //[UserEventDataTool removeDataFromUserEventPlist];
    
    if (data.count >0) {
        
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        request.timeoutInterval = 10;
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:data options:0 error:NULL];;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        NSURLSession *session = [NSURLSession sharedSession];

        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (!error) {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                
                NSLog(@"--- %@",result);
                
                if ([result boolValue]) {
                    [UserEventDataTool removeDataFromUserEventPlist];
                }
            }

        }];
        [sessionDataTask resume];
    }
}

@end
