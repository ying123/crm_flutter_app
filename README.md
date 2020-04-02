# crm_flutter_app

> 基于[flutter](https://github.com/flutter/flutter)的新版CRM项目

## Getting Started

1. 安装Flutter，配置环境 https://flutterchina.club/get-started/install/

2. 运维工单申请gitlab加入btr-flutter-package 分组，工程依赖的自研插件在内网私有仓库。

   

## iOS 环境

1. 安装最新版Xcode command line tools。终端输入命令：

   ```shell
   xcode-select –install
   ```

2. 安装Fastlane。终端输入命令：

   ```shell
   sudo gem install fastlane --verbose
   或：sudo gem install -n /usr/local/bin fastlane –verbose
   ```

3. 下载安装苹果开发者证书和描述文件

4. iOS配置了启动图替代白屏，启动图路径 crm_flutter_app/ios/Runner/Assets.xcassets/crm_welcome.imageset/crm_welcome.png



### iOS 打包上传蒲公英

```shell
flutter pub get
flutter clean
flutter build ios --release --no-codesign
 
 
cd ios
fastlane jenkinsBuildUploadPgy desc:测试CRM打包
```

### android 打包上传蒲公英

```shell

//1、打包并上传蒲公英：
cd android
fastlane jenkinsBuildUploadPgy desc:测试CRM打包
 
 
//2、只打包安卓apk：
cd android
fastlane BuildApk

```

