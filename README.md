# FPGA 硬件加密通信系统

数字逻辑六人小组作业。电脑发一条加密命令，征途 Pro 解密后开关 D6，再把执行回执加密发回。三天交付两条命令、一盏灯和一个串口终端。

## 小组成员开始开发

六个编号代表小组职责，成员姓名由小组填写。每位成员先阅读本页、DESIGN.md、INTERFACE.md、AGENTS.md，再打开自己对应的任务书。任务书包含修改范围、实现步骤、上下游、最小验证和可直接发给 AI 的提示词。

网页 AI 使用者将这四份公共文档、对应任务书和该模块源码一起上传或粘贴。能够读取仓库的 AI 从当前分支直接读取。统一时序以 INTERFACE.md 为准。

六个人如何当天同时开工、上游未完成时用什么测试、每人需要提交哪些文件，都列在 [并行开发与交付](并行开发与交付.md)。组员完成一版后提交源码和测试文件，运行命令、实际结果及模拟范围写入 Pull Request 正文。

| 人员 | Git 分支 | 负责文件 | 交付条件 |
|---|---|---|---|
| [1 · 组长与集成](tasks/01-integration.md) | feature/integration | rtl/top.v、quartus/、共享文档及查表 | 第一天检查线路，第二天集成正式模块，第三天验收并保存提交号。 |
| [2 · 串口收发](tasks/02-uart.md) | feature/uart | rtl/uart_rx.v、rtl/uart_tx.v、sim/tb_uart.sv | 完成 115200、8N1 的收发，验证独立位序、连续字节和发送握手。 |
| [3 · 协议与灯控制](tasks/03-protocol.md) | feature/protocol | rtl/comm_ctrl.v、sim/tb_comm_ctrl.sv | 用模拟 AES 验证完整请求、单次启动、灯状态和 16 字节回执。 |
| [4 · AES 加密](tasks/04-encrypt.md) | feature/aes-encrypt | rtl/aes_enc.v、独立扩展测试 | 复用已有 S 盒和轮密钥，通过标准分组、开灯分组及握手验证。 |
| [5 · AES 解密](tasks/05-decrypt.md) | feature/aes-decrypt | rtl/aes_dec.v、独立扩展测试 | 复用逆 S 盒和轮密钥，通过标准密文、开灯密文及握手验证。 |
| [6 · 电脑端与记录](tasks/06-pc-test.md) | feature/pc-test | pc/demo.py（新建）、pc/reference.py、电脑端测试 | 复用参考代码实现串口 on/off，核对回执，协助整机验证。 |

## 共同编码约束

- RTL 使用可综合 Verilog-2001，统一 50 MHz 上升沿时钟和低有效复位，时序块使用非阻塞赋值。
- 保持现有模块端口和字节排列。数据只在公共握手约定的时钟沿接受，每个信号有唯一驱动者。
- 每人维护自己的文件和测试，公共接口由组长协调更新。仿真替身放入 sim/，正式工程使用真实 RTL。
- 每次交付附实际命令和结果。详细规则见 [AGENTS.md](AGENTS.md)，握手、复位、位序和向量见 [INTERFACE.md](INTERFACE.md)。

## 第一次开工

组员登录 GitHub，在原仓库右上角 Fork → Create fork 创建自己的副本，再用 GitHub Desktop 克隆自己账号下的仓库到英文路径，如 D:\fpga-secure。从 main 用 Current Branch → New Branch 创建所负责的任务分支。代码上传到自己的 Fork，再向原仓库 main 提交 Pull Request。完整步骤见 [Git 操作](Git协作说明.md)。

组长在原仓库负责集成。现有 Quartus 18.0 编译检查在中文工程路径下遇到打开工程错误，英文路径已编译通过。

每人推自己的分支，向 main 发起合并请求。第一天并行开发、晚间首次合并。第二天按串口、协议、解密、加密回执的顺序接入，下午首次整机上板。第三天留给复测、复位恢复和换人复现。[Git 操作](Git协作说明.md) · [三天工作流](六人三天开发工作流.md)

## 第一次上板

用 Quartus 18.0 打开 `quartus/secure_comm.qpf`，在 **Project → Revisions** 选 **board_echo** 后编译。用 USB-Blaster 下载 `quartus/output_files/board_echo.sof`。按野火说明连接板载 USB 串口和跳帽，在串口工具选择对应 COM、115200、8N1、无流控，关闭本地回显，按 HEX 发送 `00 55 AA FF`。应收到相同的四字节，按住复位可点亮 D6。该版本验证物理串口线路。正式工程选 **secure_comm**，其顶层已接好，各功能模块留给负责人实现。[串口接线图](https://doc.embedfire.com/fpga/altera/ep4ce10_pro/zh/latest/code/rs232.html) · [D6 说明](https://doc.embedfire.com/fpga/altera/ep4ce10_pro/zh/latest/code/led.html)

## 模块测试

在仓库根目录执行以下命令。电脑参考程序打印开灯、关灯的发送密文与预期回执，并核对标准向量。

```powershell
python -m pip install -r pc/requirements.txt
python pc/reference.py
```

加密、解密负责人可以在已设置 ModelSim 命令路径的 PowerShell 中，从仓库根目录运行下列测试。

```powershell
vlib work
vlog +incdir+rtl rtl/aes_enc.v rtl/aes_dec.v
vlog -sv sim/tb_aes.sv
vsim -c tb_aes -do "run -all; quit -f"
vlog -sv +define+TEST_DEC sim/tb_aes.sv
vsim -c tb_aes -do "run -all; quit -f"
```

两个模式分别检查标准分组和开灯分组。核实现后应输出 `PASS: both AES blocks`，当前占位模块会在等待 done 时超时。

## 框架验证状态

已核对电脑端离线参考向量、正式顶层端口展开及 board_echo 的 Quartus 完整编译。UART、协议和两个 AES 核的 RTL 目前仍为占位。硬件业务在各成员提交实现后联调验收。ModelSim 命令是成员的运行步骤，共用 AES testbench 在当前环境尚待运行。
