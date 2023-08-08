# Tesla Camera

特斯拉行车记录仪桌面端（Mac、Windows）

### 效果图
<img src="https://github.com/Mario34/tesla-camera-app/blob/main/imgs/img_1.png" />
<img src="https://github.com/Mario34/tesla-camera-app/blob/main/imgs/img_2.gif" />

[安装包下载](https://github.com/Mario34/tesla-camera-app/releases)

### Flutter doctor

- Mac OS

```shell
[✓] Flutter (Channel stable, 3.10.5, on macOS 12.5 21G72 darwin-x64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 14.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.1)
[✓] IntelliJ IDEA Ultimate Edition (version 2023.1)
[✓] VS Code (version 1.73.1)
[✓] Connected device (2 available)
```
- Windows

```shell
[√] Flutter (Channel stable, 3.10.5, on Microsoft Windows [版本 10.0.22621.1992], locale zh-CN)
[√] Windows Version (Installed version of Windows is version 10 or higher)
[√] Chrome - develop for the web
[√] Visual Studio - develop for Windows (Visual Studio Community 2022 17.6.4)
[√] Android Studio (version 2022.2)
[√] Connected device (3 available)
```

### 打包

- Mac OS
> 使用`create-dmg`，脚本位于 `/shell/sh_dmg.sh`

- Windows
> 使用`InnoSetup`，[参考文档](https://juejin.cn/post/7108928269285589000)，脚本位于 `/shell/TeslaCam.iss`