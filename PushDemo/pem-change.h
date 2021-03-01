//
//  pem-change.h
//  PushDemo
//
//  Created by aBerning on 2021/3/1.
//

#ifndef pem_change_h
#define pem_change_h
/**
 -in  infile   input filename
 -out outfile  output filename
 -node  don't encrypt private keys
 -clcerts      only output client certificates.
 -nocerts      don't output certificates.
 -cacerts      only output CA certificates.
 -nokeys       don't output private keys.
 
 #证书展开可以这样
 openssl pkcs12 -clcerts -nokeys -out apns-dev-cert.pem -in apns-dev-cert.p12
 openssl pkcs12 -nocerts -out apns-dev-key.pem -in apns-dev-key.p12
 cat apns-dev-cert.pem apns-dev-key.pem > apns-dev.pem

 #证书不展开
 openssl pkcs12 -in MyApnsCert.p12 -out ck.pem -nodes

 #测试证书是否可用
 *development
 openssl s_client -connect gateway.sandbox.push.apple.com:2195 -cert ck.pem
 
 *production
 -CAfile arg   - PEM format file of CA's
 openssl s_client -connect gateway.push.apple.com:2195 -cert ck.pem

 以上命令在 Mac 下没有问题，在其他操作系统下需要指定服务器当前的 CA 根证书，具体可以从网站上下载：
 entrust_2048_ca.cer 下载
 下载完成之后，在以上命令后面加上 -CAfile entrust2048ca.cer 即可



 */

#endif /* pem_change_h */
