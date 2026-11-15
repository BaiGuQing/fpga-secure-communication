# 六人 Git 协作说明

组长维护 main 分支和 Quartus 工程。每位成员从最新 main 创建自己的分支，提交负责的模块及测试文件。公共接口的变化先在群里说明，由组长协调后更新。

团队仓库为 [baoyuxuan15/fpga-secure-communication](https://github.com/baoyuxuan15/fpga-secure-communication)。组长可在仓库设置中给组员添加协作者权限。

## 组员日常操作

首次获取仓库，在自己选定的目录执行：

```powershell
git clone https://github.com/baoyuxuan15/fpga-secure-communication.git D:\fpga-secure
cd D:\fpga-secure
git switch -c feature/uart
```

各自选不同的分支名，例如 `feature/uart`、`feature/protocol`、`feature/aes-encrypt`、`feature/aes-decrypt`、`feature/pc-test`。一个模块告一段落后检查并提交：

```powershell
git status
git diff
git add <本次修改的文件>
git commit -m "实现串口接收模块"
git push -u origin feature/uart
```

在仓库网站发起合并请求，写清功能、测试方法、实际结果和未解决问题。组长检查后合入 main。已有分支下后续上传可用 `git push`。

开始新任务前，先确保已提交或妥善保存当前修改，再更新主分支并创建新分支：

```powershell
git switch main
git pull --ff-only origin main
git switch -c feature/新任务
```

若多人修改了同一文件，组长与相关成员检查冲突内容，解决后重新测试。不要用覆盖文件的方式处理冲突。

## 仓库放什么

提交 Verilog 源码、testbench、电脑端脚本、Quartus 工程配置（如 `.qpf`、`.qsf`、`.sdc`）、必要的初始化文件和操作说明。Quartus 编译目录、仿真波形及临时文件由 `.gitignore` 排除。每次实板通过后记录对应 Git 提交号，并单独保存该版本的 `.sof` 和验收记录，供现场下载与复现。

不要上传个人访问令牌、密码或私有密钥。项目采用的公开 AES 测试密钥可以随测试向量提交。
