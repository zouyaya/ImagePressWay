//
//  ViewController.m
//  YOImagePress
//
//  Created by yangou on 2020/3/31.
//  Copyright © 2020 hello. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YOImagePressTool.h"

@interface ViewController ()<UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImageView *uploadImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _uploadImageView = [[UIImageView alloc]init];
    _uploadImageView.frame = CGRectMake(100, 100, 200, 100);
    _uploadImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_uploadImageView];
    
    UIButton *uploadButton = [[UIButton alloc]init];
    uploadButton.frame = _uploadImageView.frame;
    [uploadButton addTarget:self action:@selector(pressToUploadPic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadButton];
    
    
    
    
    
    
}


/**
 点击上传图片
 */
-(void)pressToUploadPic:(UIButton *)button
{
   
    
    [self creatCustomVeriftAlertView];

    
}


- (void)creatCustomVeriftAlertView {
   
    NSString *title = @"通知";
    NSString *message = @"图片压缩";
    NSString *leftActionStr = @"相册";
    NSString *rihghtCancle = @"相机";
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
              //改变title的大小和颜色
              NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:title];
              [titleAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, title.length)];
              [titleAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
              [alertController setValue:titleAtt forKey:@"attributedTitle"];
           
              //改变message的大小和颜色
              NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
              [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, message.length)];
              [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, message.length)];
              [alertController setValue:messageAtt forKey:@"attributedMessage"];
              
           
              UIAlertAction *alertActionCall = [UIAlertAction actionWithTitle:leftActionStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                   [self openPhotoAlbum];
                 
                
              }];
              [alertController addAction:alertActionCall];
              [alertActionCall setValue:[UIColor blackColor] forKey:@"titleTextColor"];
              
              UIAlertAction *alertActionContinue = [UIAlertAction actionWithTitle:rihghtCancle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  
                   [self onCameraPic];
              }];
              [alertController addAction:alertActionContinue];
              [alertActionContinue setValue:[UIColor blackColor] forKey:@"titleTextColor"];
              [self presentViewController:alertController animated:YES completion:nil];
           
    
  
    
}


-(void)openPhotoAlbum
{
    
    
    
    
}

//拍照
- (void)onCameraPic
{
    [self.view endEditing:YES];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return ;
    } else {
        //调用相机的代码写在这里
    }
    
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        return;
    }
    
    UIImagePickerController *imagePickerCamera = [[UIImagePickerController alloc] init];
    imagePickerCamera.delegate = self;
    imagePickerCamera.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePickerCamera.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:imagePickerCamera animated:YES completion:nil];
}



#pragma mark---------------------------- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* srcImage = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    //最大限制500 kb
    UIImage *newImage = [YOImagePressTool compressedImageFiles:srcImage LimitImageKB:500];
    
    _uploadImageView.image = newImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
