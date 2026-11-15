# 5 号任务书 · AES-128 解密

工作分支为 feature/aes-decrypt。负责 rtl/aes_dec.v，可增加 sim/tb_aes_dec_extra.sv。共用 sim/tb_aes.sv 由组长维护，可直接使用 TEST_DEC 模式。

开工时按 [并行开发与交付](../并行开发与交付.md) 使用模拟输入独立验证；交付文件和结果填写方式也见该说明。Fork 提交与同步见 [Git 协作说明](../Git协作说明.md)。

## 已有材料

模块端口与 aes_tables.vh 的 include 已备好。表内提供 aes_inv_sbox(byte) 及 aes_round_key(round)。固定密钥和列优先状态布局见 INTERFACE.md。可以直接把公开密文喂给本模块开发。

## 实现内容

- 接受 start 时锁存密文，初始异或第 10 轮密钥。
- 从第 9 轮到第 1 轮依次 InvShiftRows、InvSubBytes、AddRoundKey、InvMixColumns。
- 最后一轮执行 InvShiftRows、InvSubBytes、AddRoundKey，使用第 0 轮密钥。
- aes_round_key 直接返回原展开轮密钥，以上逆轮顺序按该表使用。状态机逐轮复用，一轮可拆为多拍。
- 完成时同拍给出 block_out、busy=0、done=1，下一拍清 done，结果保持。忙时忽略 start，复位中止任务。

InvShiftRows 将第 r 行循环右移 r 位。InvMixColumns 使用 AES GF(2^8) 中的 09、0B、0D、0E 系数，左移溢出按 8'h1b 约减。函数可置于本模块内。

## 独立验证与交付

运行 README.md 中 sim/tb_aes.sv 的 TEST_DEC 模式，独立核对标准密文和开灯密文恢复成约定明文。用 sim/tb_aes_dec_extra.sv 再验证连续任务、输入变化及复位恢复，确保 busy/done 与接口约定一致。提交源码、实际执行命令和结果。

第一天完成标准向量仿真，第二天交给组长和 3 号控制 LED。完成延迟小于 5000 拍即可按共同测试交付。

## 对接对象

3 号给出分组与 start，等待 done。4 号与本角色共享轮密钥、字节位序和忙状态约定。公共表的问题交由组长同步。

## 交给本角色 AI 的任务

> 先读 AGENTS.md、DESIGN.md、INTERFACE.md 和本任务书。实现按普通逆轮顺序运行的可综合 AES-128 解密，直接调用现有逆 S 盒及原轮密钥。运行独立 TEST_DEC 测试并检查握手。交付源码、执行命令、实际结果和待综合/实板事项。
