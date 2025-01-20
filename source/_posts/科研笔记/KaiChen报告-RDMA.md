---
title: Towards a High-Performance RDMA Networking for Datacenters 报告笔记
date: 2022-09-15 11:57:00
tags: 
- datacenter
- RDMA
- 科研报告
categories: 
- 01 科研笔记
---
# background
- traditional software-based TCP/IP stack
    - 数据通过用户空间发送到远程device的用户空间。
    - 这个过程会经过若干次内存拷贝：应用缓存->kernel中的TCP协议栈缓存->驱动层->网卡缓存。
    - 多次内存拷贝需要CPU介入，处理时延大，>10us。
    - 解决方案：RDMA、TOE等。
- hardware-based RDMA
    - from HPC to Ethernet-based datacenters
<!--more-->
## DMA
允许在计算机主板上的设备直接把数据发送到内存中，其中数据的搬运不需要CPU的参与。
DMA Engine通过硬件复制数据，不需要CPU Copy的开销。

## TOE
TOE(TCP Offloading Engine)

TOE 技术需要特定支持 Offloading的网卡。

- CPU Offload: 这种特定网卡能够支持封装多层网络协议的数据包。讲协议栈中的一些操作转移到网卡硬件中进行，降低系统CPU的消耗。
- 普通网卡处理每个数据包都要触发一次中断，TOE 网卡则让每个应用程序完成一次完整的数据处理进程后才触发一次中断。
- **Kernel Bypass & Zero Copy**: TOE 网卡在接收数据时，在网卡内进行协议处理，因此，它不必将数据复制到内核空间缓冲区，而是直接复制到用户空间的缓冲区，这种“零拷贝”方式避免了网卡和服务器间的不必要的数据往复拷贝。

## RDMA
RDMA(Remote Direct Memory Access)
RDMA指的是两个主机通过Network通信，然后由RDMA Engine进行数据的拷贝，不经过CPU Copy。

![image](https://img-blog.csdnimg.cn/img_convert/2a16c57d091d93131b58dd517ff33287.png)


### RDMA的优势
- **零拷贝(Zero-copy)**: 应用程序能够直接执行数据传输，在不涉及到网络软件栈的情况下。数据能够被直接发送到缓冲区或者能够直接从缓冲区里接收，而不需要被复制到网络层。
- **内核旁路(Kernel bypass)**: 应用程序可以直接在用户态执行数据传输，不需要在内核态与用户态之间做上下文切换。
- **不需要CPU干预(No CPU involvement)**: 应用程序可以访问远程主机内存而不消耗远程主机中的任何CPU。远程主机内存能够被读取而不需要远程主机上的进程（或CPU)参与。远程主机的CPU的缓存(cache)不会被访问的内存内容所填充。
- **消息基于事务(Message based transactions)**: 数据被处理为离散消息而不是流，消除了应用程序将流切割为不同消息/事务的需求。
- **支持分散/聚合条目(Scatter/gather entries support)**: RDMA原生态支持分散/聚合。也就是说，读取多个内存缓冲区然后作为一个流发出去或者接收一个流然后写入到多个内存缓冲区里去。

### RDMA技术
Infiniband：基于 InfiniBand 架构的 RDMA 技术，由 IBTA（InfiniBand Trade Association）提出。搭建基于 IB 技术的 RDMA 网络需要专用的 IB 网卡和 IB 交换机。从性能上，很明显Infiniband网络最好，但网卡和交换机是价格也很高，然而RoCEv2和iWARP仅需使用特殊的网卡就可以了，价格也相对便宜很多。

### 关于无损
InfiniBand 架构获得了极好的性能，但是其不仅要求在服务器上安装专门的 InfiniBand 网卡，还需要专门的交换机硬件，成本十分昂贵。而在企业界大量部署的是以太网络，为了复用现有的以太网，同时获得 InfiniBand 强大的性能，IBTA 组织推出了 RoCE（RDMA over Converged Ethernet）。RoCE 支持在以太网上承载 IB 协议，实现 RDMA over Ethernet，这样一来，仅需要在服务器上安装支持 RoCE 的网卡，而在交换机和路由器仍然使用标准的以太网基础设施。网络侧需要支持无损以太网络，这是由于 IB 的丢包处理机制中，任意一个报文的丢失都会造成大量的重传，严重影响数据传输性能。

# 报告
- RDMA relies on lossless network to take effect
- lossy datacenter networking

# Related Links
- [RDMA 架构与实践](https://houmin.cc/posts/454a90d3/) (highly recommend)

- [【RDMA】技术详解（一）：RDMA概述](https://blog.csdn.net/bandaoyu/article/details/112859853)

- [网络】TOE、RDMA、smartNIC 是什么和区别|DPU](https://blog.csdn.net/bandaoyu/article/details/122868925)

- [RDMA 学习资料总目录](https://blog.csdn.net/bandaoyu/article/details/120485737)

- [RDMA核心概念](https://blog.csdn.net/yizhiniu_xuyw/article/details/126036648)


# iSing Lab

# intelligence
## congestion control(cc)

### problem
- converge speed
- overhead
- multi-request
- generalization

### background
- 目标：高吞吐、低延迟、公平(bandwidth)
- focus:
    - end-to-end algorithm
    - feedback-based
    - best effort service model(*)

- tranditional methods:
    - Cubic, Vegas, etc
    - 在具体的网络环境下设置的, 通用性不够

- DRL-based Scheme
    - input: RTT, thoughput
    - output: sending rate
    - chanllenges:
        - poor fairness
        - high overhead
        - multi-objective demand

    - 收敛差的原因分析:
        - others: 
            - single-flow
            - thoughtput + loss(丢包率)
        - need:
            - [Astrasa]
            - globally goal
            - multi-flow
            - multi-agent

    - 【Astrasa】
        - global metrics: 
            - 

- 【Spine】
    - bandwidth changes: fast[not suited for RL]
    - policy changes: slow
    - 思路: 直接给出sub policy, 降低决策频率, 可以尽快响应网络的变化
    - sub policy 输入(throughput, latency, tolerence, loss)
    - 200ms monitor


- Diverse Application Requirements
    - throughtput, latency, loss rate
    - 【MOCC】: single-objective -> multi-objective
        - preference sub-network

- forward
    - generalize: unseen network
# performance
异构计算 加速系统
- 网络部分: 有状态四层负载均衡网关
    - link到server之间的关系, 保持连接的一致性，不会造成服务中断
    - 目标：高吞吐，flow table size，flow table insertion speed
    - software-based LB的throughput有限
    - switch-based LB可扩展性差，流表大小and速度表现差
    - strawman solution: switch-server LB
        - 流量要有局部性：28法则/长尾分布
        - 但是线上的环境不一定能够遵循
    
    【Tiara】
    - SM: streaming mxxx p
    - EBR是啥
    
- 计算部分: 高性能

# security
【FLASH】
加速9个密码学的算子，提供加速
主要运算cost：模乘运算，模幂运算
加速联邦学习运算
快速幂
montgomery algorithm 可以由两个64位运算器完成

# points
- RTT是什么？
- loss: loss rate,  丢包率

# keypoints
- sub policy
- 实验计划-做实验

- baseline是怎么协同的?

- 学习遗忘的问题
    - 在线学习时：新旧数据作为输入
    - 遗忘可能是一个正确的选择

- 不同的RL决策频率的影响？
