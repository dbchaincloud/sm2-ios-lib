//
//  ViewController.m
//  Sm2FrameworkDemo
//
//  Created by iOS on 2021/9/29.
//

#import "ViewController.h"
#import "DBChainSm2/DBChainSm2.h"

#import "Sm2FrameworkDemo-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;

    NSArray *arr = [DBChainGMSm2Utils createKeyPair];
    /// 未压缩的公钥
    NSString *pubKey = arr[0];
    ///  私钥
    NSString *pirKey = arr[1];

    NSArray *arrCompress = [DBChainGMSm2Utils createKeyPairCompress:YES];
    /// 压缩的公钥
    NSString *compressPubKey = arrCompress[0];
    ///  私钥
    NSString *cpirKey = arrCompress[1];

    NSLog(@"压缩的公私钥对: %@",arrCompress);


    NSString *privateKey = @"A4AA6213F7C4ADD493FA6DD6E7A909223D053E8F0F21D6C0EAED4D211F6EC014";
    NSString *pubkey = [DBChainGMSm2Utils adoptPrivatekeyGetPublicKey:privateKey isCompress:YES];


    /// 获取地址
    Address *address = [[Address alloc]init];
    NSData *publicData = [DBChainGMUtils hexToData:pubkey];

    NSString *addressStr = [address sm2GetPubToDpAddress:publicData :ChainTypeCOSMOS_MAIN];
    NSLog(@"固定私钥得出公钥:%@,\n地址:%@",pubkey,addressStr);

    // *******   加密  *************
    NSString *plainStr = @"Hello,word";
    // 转Hex
    NSString *plainHex = [DBChainGMUtils stringToHex:plainStr];
    //  sm2 加密  Hex 格式明文
    NSString *enResult2 = [DBChainGMSm2Utils encryptHex:plainHex publicKey:pubKey]; // 加密 Hex 编码格式字符串
    // sm2 解密
    NSString *deResult2 = [DBChainGMSm2Utils decryptToHex:enResult2 privateKey:privateKey]; // 解密为 Hex 格式明文
    NSLog(@"加密-Hex字符串: %@",enResult2);

    // 判断 sm2 加解密结果
    if ([deResult2 isEqualToString:plainHex]) {
        NSLog(@"sm2 加密解密成功");
    }else{
        NSLog(@"sm2 加密解密失败");
    }

    //   ********   签名   *******
    // userID 传入 nil 或空时默认 1234567812345678；不为空时，签名和验签需要相同 ID
    NSString *userID = @"1234567812345678";
    NSString *userHex = [DBChainGMUtils stringToHex:userID]; // Hex 格式的 userID
    NSString *signStr2 = [DBChainGMSm2Utils signHex:plainHex privateKey:privateKey userHex:userHex];
    NSLog(@"签名验签 签名-Hex: %@",signStr2);
    // 验证签名
    BOOL isOK2 = [DBChainGMSm2Utils verifyHex:plainHex signRS:signStr2 publicKey:pubKey userHex:userHex];

    if ( isOK2 ) {
        NSLog(@"SM2 签名验签成功");
    }else{
        NSLog(@"SM2 签名验签失败");
    }

};


@end
