# 六人 Git 协作说明

团队原仓库为 [baoyuxuan15/fpga-secure-communication](https://github.com/baoyuxuan15/fpga-secure-communication)。当前采用公开仓库的 Fork 协作流程。组员登录自己的 GitHub，Fork 项目并向原仓库提交 Pull Request，组长根据请求中的提交人检查代码。原仓库的公开访问状态可在仓库首页查看。

成员先阅读 [并行开发与交付](并行开发与交付.md)，了解当天如何独立开工及各自需要提交的文件。

## 组员第一次操作

1. 打开原仓库右上方的 Fork，点击 Create fork，在自己账号下创建副本。记录原仓库 main 的起点提交号。
2. 在 GitHub Desktop 登录自己的账号，选择 File → Clone Repository，在 GitHub.com 列表选自己账号下的 fpga-secure-communication。Local Path 使用英文路径，如 D:\fpga-secure。
3. 克隆后在 Current Branch 选择 main，再用 New Branch 创建 README.md 分工表中自己的分支，如 feature/uart。
4. 用编辑器或本地 AI 打开该项目文件夹，阅读公共约定和自己的任务书，开始独立开发。
5. 如果已有本地副本，先检查 git remote -v，origin 应指向自己账号下的 Fork。把当前工作提交保存后，再请 AI 核对本地分支和远程地址，接到本流程中。

组长在原仓库维护 main，用 feature/integration 开展集成。仓库中的任务文件由组长统一合并。

## 完成一版后提交

在 GitHub Desktop 确认顶部为自己的任务分支，检查 Changes 中的文件。填写 Summary 后点击 Commit to 对应分支，再点击 Publish branch；后续上传该分支新提交使用 Push origin。

命令行使用者可以在自己的任务分支执行下列示例，分支名和文件按自己任务替换。

```powershell
git status
git diff
git add rtl/uart_rx.v rtl/uart_tx.v sim/tb_uart.sv
git commit -m "完成 UART 收发与独立测试"
git push -u origin feature/uart
```

打开原仓库的 Pull requests → New pull request，选择 compare across forks。base repository 选 baoyuxuan15/fpga-secure-communication，base 分支选 main；head fork 选自己的副本，compare 分支选自己的任务分支。填写并行开发与交付.md 中的交付表，点击 Create pull request。未完成的第一版可用 Draft pull request 说明进度。后续继续向同一分支 push，已有请求会更新。[GitHub Fork 合并请求说明](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/creating-a-pull-request-from-a-fork)

## 组长合入后如何同步

公共起点和接口有变更时，组长在群里通知提交号及影响。组员先将当前改动提交保存，随后同步团队 main 到自己的任务分支。

首次使用命令行同步，在本地仓库执行 git remote -v。若尚无 upstream，添加原仓库地址一次。

```powershell
git remote add upstream https://github.com/baoyuxuan15/fpga-secure-communication.git
```

下面以串口成员为例，其他成员换成自己的分支名。在工作区干净时执行。

```powershell
git fetch upstream
git switch feature/uart
git merge upstream/main
git push origin feature/uart
```

若出现冲突，记录冲突文件，和组长或对应成员核对两边改动，解决后重新测试并提交。组员可将这些步骤交给能访问本地仓库的 AI 执行。

新任务开始前，可在自己 Fork 的网页 main 页面点击 Sync fork → Update branch，接着在 GitHub Desktop 切到 main，Fetch origin 并 Pull origin，再从更新后的 main 新建任务分支。已有任务分支继续按上面的 merge 步骤引入更新。[GitHub 同步 Fork 说明](https://docs.github.com/en/pull-requests/how-tos/work-with-forks/syncing-a-fork)

## 保存哪些内容

Git 提交源码、testbench、电脑端脚本、Quartus 工程配置和必要的初始化文件。各角色的具体文件及结果表见 [交付清单](并行开发与交付.md#每个人到底交什么)。编译目录、波形和临时输出由 .gitignore 排除。组长在实板通过后按 Git 提交号另存 .sof 和验收记录。

公开测试密钥可随测试向量提交，个人访问令牌及账号密码由使用者本地保管。
