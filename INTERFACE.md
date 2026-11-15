# 接口约定

统一 50 MHz 时钟 clk，在上升沿采样。rst_n 低有效，复位清空收发状态、busy 和 done，逻辑灯状态 led_on 为 0。顶层将 led_on 取反后接到低有效的 D6。模块声明见 rtl/ 下对应文件。

| 连接 | 约定 |
|---|---|
| 电脑 ↔ UART | 115200、8N1、无流控。每次收发 16 个原始字节，先发分组 [127:120]；每个 UART 字节内低位先发。每次等整条回执。 |
| uart_rx → comm_ctrl | rx_valid 高一拍时提交 rx_data[7:0]。第 16 个字节到达后才启动解密。 |
| comm_ctrl → uart_tx | tx_valid 与 tx_ready 同时为高的上升沿接收 tx_data[7:0]。等待期间保持 tx_valid 和数据。 |
| comm_ctrl ↔ aes_dec / aes_enc | 控制器在 busy=0 时发一拍 start，同时提供 block_in[127:0]；核在该沿锁存输入。运算中 busy=1，完成时 busy=0 且 done=1 一个周期，该周期 block_out 有效。 |
| comm_ctrl → LED | led_on 为持续状态，1 表示亮。协议控制器是唯一写入者。 |

**命令明文**　开灯为 01 后接 15 字节零，关灯为 16 字节零。只有这两个完整分组合法。成功回执为 A0、灯状态（00 或 01）、14 字节零。非法命令保留灯状态，回执首字节改为 E0。命令与回执均使用同一实验密钥和 AES-128 单分组，无填充。

**断帧恢复**　复位 FPGA、清空电脑端串口缓存，再发整帧。串口自检版本仅将输入引脚采到的电平送回输出，验证线缆、跳帽和引脚；UART 模块完成后还需验证按字节收发。

**AES 字节顺序**　分组首字节对应状态矩阵第 0 行第 0 列，第二字节在第 1 行第 0 列，按列依次填充。rtl/aes_tables.vh 提供 aes_sbox(byte)、aes_inv_sbox(byte)、aes_round_key(round)，第 0 轮入口为原密钥。参考值可运行 pc/reference.py 得到。
