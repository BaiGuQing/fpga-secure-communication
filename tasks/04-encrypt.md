# 4 号任务书 · AES-128 加密

工作分支为 feature/aes-encrypt。负责 rtl/aes_enc.v，可增加 sim/tb_aes_enc_extra.sv。共用 sim/tb_aes.sv 由组长维护，可直接使用其中的加密模式。

## 已有材料

aes_enc 的端口与 aes_tables.vh 的 include 已备好。表内提供 aes_sbox(byte) 及 aes_round_key(round)，固定实验密钥为 00 至 0F。输入输出与矩阵的对应见 INTERFACE.md。

## 实现内容

- 接受 start 时锁存 block_in，初始异或第 0 轮密钥。
- 第 1–9 轮依次 SubBytes、ShiftRows、MixColumns、AddRoundKey。
- 第 10 轮执行 SubBytes、ShiftRows、AddRoundKey。
- 采用逐轮复用的状态机，一轮可拆成多个 clk，控制器允许核的完成延迟变化。计算中 busy=1。
- 完成时同拍更新 block_out、busy=0、done=1，下一拍清除 done。block_out 持有结果。忙时忽略新 start，复位中止任务。

逐个字节进行查表。ShiftRows 将第 r 行循环左移 r 位。MixColumns 使用 AES 的 GF(2^8) 运算，左移溢出按 8'h1b 约减。函数可以放在当前模块内。

## 独立验证与交付

运行 README.md 中 sim/tb_aes.sv 的加密模式，核对标准分组和开灯分组。用 sim/tb_aes_enc_extra.sv 再验证一次握手完成后第二次启动，以及忙时修改输入不改变当前结果。检查 done 为单拍，复位恢复空闲。提交源码、实际执行命令和结果。

第一天完成标准向量仿真，第二天交给组长与 3 号接入。完成延迟小于 5000 拍即可按共同测试交付。

## 对接对象

3 号仅依赖 start/busy/done 和分组端口。与 5 号共用相同密钥及位序。公共表发现问题时附失败输入和预期值，由组长同步修正。

## 交给本角色 AI 的任务

> 先读 AGENTS.md、DESIGN.md、INTERFACE.md 和本任务书。按既有端口实现可综合、逐轮复用的 AES-128 加密，直接调用已有 S 盒及轮密钥。运行共用加密测试并核对启动、忙状态和单拍 done。交付源码、执行命令、实际结果和待综合/实板事项。
