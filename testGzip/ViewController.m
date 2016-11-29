//
//  ViewController.m
//  testGzip
//
//  Created by haohao on 16/9/14.
//  Copyright © 2016年 qiandai. All rights reserved.
//

#import "ViewController.h"
//#import <AFNetworking.h>
//#import <AFHTTPSessionManager.h>
#import "NSData+GZIP.h"
#import "GTMBase64.h"
//#import <zlib.h>

#define urlStr @"你的请求地址"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)testGzipReq {
    [self testGziReq2];return;
    
    
    NSString* param = @"testGzip1235874";
    NSData* paramData = [param dataUsingEncoding:NSUTF8StringEncoding];
    paramData = [paramData gzippedData];
    NSString* base =  [[NSString alloc] initWithData:[GTMBase64 encodeData:paramData] encoding:NSUTF8StringEncoding];
   
    // 2.构建网络URL对象, NSURL
    BOOL isGzip = true;
    NSString* gzipFlag = @"1";   //0 压缩    1未压缩
    if(isGzip){
        gzipFlag = @"0";
    }else{
        gzipFlag = @"1";
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?str=%@&gzipFlag=%@",urlStr,base,gzipFlag]];
    
    NSString* showMsg = [NSString stringWithFormat:@"请求的地址是：%@ \n       发送给服务器的请求数据是Gzip压缩数据：%@",url,base];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:showMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    NSLog(@"请求的地址是：%@        发送给服务器的请求数据是Gzip压缩数据：%@",url,base);
    
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* resp =  [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    
    if(isGzip){
        NSData* unData = [GTMBase64 decodeString:resp];
        
        NSData* resData = [unData gunzippedData];
        NSString* res = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
        
        NSString* resMsg = [NSString stringWithFormat:@"服务器返回的是Gzip压缩并且客户端解压后的响应数据：%@",res];
        UIAlertView* alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:resMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert2 show];
        NSLog(@"服务器返回的是Gzip压缩并且客户端解压后的响应数据：%@",res);
    }else{
        NSString* resMsg = [NSString stringWithFormat:@"服务器返回的是没有Gzip压缩的响应数据(和没有压缩的请求数据一样)：%@",resp];
        UIAlertView* alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:resMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert2 show];
        
        NSLog(@"服务器返回未压缩的响应数据(和没有压缩的请求数据一样)：%@",resp);
    }
}

-(void)testGziReq2{
    NSString* param = @"testGzip1235874";
    BOOL isGzip = false;
    if(isGzip){
        [self requestWithGzip:param];
        return;
    }else{
        [self requestNormalWithParam:param];
        return;
    }
}

-(void)requestNormalWithParam:(NSString*)param{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?str=%@&gzipFlag=1",urlStr,param]];
    
    NSString* showMsg = [NSString stringWithFormat:@"请求的地址是：%@ \n       发送给服务器的请求数据是Gzip压缩数据：%@",url,param];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:showMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    NSLog(@"请求的地址是：%@        发送给服务器的请求数据是Gzip压缩数据：%@",url,param);
    
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* resp =  [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    
    NSString* resMsg = [NSString stringWithFormat:@"服务器返回的是没有Gzip压缩的响应数据(和没有压缩的请求数据一样)：%@",resp];
    UIAlertView* alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:resMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert2 show];
    
    NSLog(@"服务器返回未压缩的响应数据(和没有压缩的请求数据一样)：%@",resp);
    
}

-(void)requestWithGzip:(NSString*)param{
    param = [NSString stringWithFormat:@"str=%@",param];
    NSData* paramData = [param dataUsingEncoding:NSUTF8StringEncoding];
    paramData = [paramData gzippedData];
    NSString* reqURL = [NSString stringWithFormat:@"%@?gzipFlag=0",urlStr];
//    NSString* reqURL = [urlStr stringByAppendingString:@"?gzipFlag=0"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURL]cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0f];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", [paramData length]];
    NSLog(@"压缩后的数据大小是======%@",postLength);
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];//POST请求
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:paramData];//body 数据
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSData* resData = [data gunzippedData];
    NSString* res = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    
    NSString* resMsg = [NSString stringWithFormat:@"服务器返回的是Gzip压缩并且客户端解压后的响应数据：%@",res];
    UIAlertView* alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:resMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert2 show];
    NSLog(@"服务器返回的是Gzip压缩并且客户端解压后的响应数据：%@",res);
    
}


@end
