# 给apk签名
## 生成自定义签名证书
### 方式 A：使用电脑自带的 OpenSSL（无需安装 Java）
在当前项目的 PowerShell 终端中执行以下命令（生成的密钥有效期约 27 年）：
```powershell
# 1. 生成自签名证书与私钥
openssl req -x509 -newkey rsa:2048 -keyout temp_key.pem -out temp_cert.pem -days 10000 -nodes -subj "/CN=M328V6Host/O=M328V6/C=CN"

# 2. 打包为 Android 支持的标准 release.keystore (设置密码，例如 m328v6pass)
openssl pkcs12 -export -in temp_cert.pem -inkey temp_key.pem -out release.keystore -name m328v6 -passout pass:m328v6pass

# 3. 清理临时文件
Remove-Item temp_key.pem, temp_cert.pem
```

### 方式 B：使用 Java 的 `keytool`（若有 JDK 或 Android Studio）
```bash
%JAVA_HOME%\bin\keytool -genkeypair -v -keystore release.keystore -alias m328v6 -keyalg RSA -keysize 2048 -validity 10000 -storepass m328v6pass -keypass m328v6pass -dname "CN=M328V6Host, OU=Android, O=M328V6, C=CN"
```

## 将证书配置到 GitHub Secrets

生成 `release.keystore` 后，执行以下步骤：

### 第一步：将证书文件转为 Base64 文本
在 PowerShell 中运行以下命令，会自动将编码复制到剪贴板，同时在当前目录保存一份 `keystore_base64.txt`：
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$PWD\release.keystore")) | Set-Clipboard
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$PWD\release.keystore")) | Out-File -Encoding ascii keystore_base64.txt
```

### 第二步：在 GitHub 仓库添加 4 个 Secret
打开您的 GitHub 仓库网页：
1. 点击顶部 **Settings** -> 左侧侧边栏 **Secrets and variables** -> **Actions**。
2. 点击绿色的 **New repository secret** 按钮，分别添加以下 4 项：

| Secret 名称 | 填入内容 | 说明 |
| :--- | :--- | :--- |
| **`KEYSTORE_BASE64`** | 刚才复制的一长串 Base64 文本（或 `keystore_base64.txt` 内容） | 证书文件内容 |
| **`KEY_ALIAS`** | `m328v6` | 证书别名 |
| **`KEYSTORE_PASSWORD`** | 刚才设置的密码（如 `m328v6pass`） | Keystore 存储密码 |
| **`KEY_PASSWORD`** | 刚才设置的密码（如 `m328v6pass`） | 私钥密码（通常与上面一致） |
