<div align="center">

# 船长运维 · Captain Ops

一个可以私有化部署的 AI 运维助手：在聊天里说一句，它去机器上查问题、跑命令，危险的操作先找人审批。

简体中文 · [English](README.en.md)

</div>

> 还在设计阶段。这个仓库目前只有方案文档，没有能运行的代码。

## 这是什么

机器一多，运维的日常就是：告警响了，登上去翻日志、查进程、看磁盘，再照着经验处理。船长运维想让 AI 先把这些活干了，人只管拍板。

设想中的用法：

- 在飞书、钉钉、企业微信或网页里直接问“某某服务怎么又挂了”，它去相关机器上排查，把结论和证据回给你。
- 平时的问答能查内部知识库，不用再翻文档。
- 重启服务、删文件这类高危操作不会直接执行，要先发给有权限的人审批。
- 谁在什么时候让 AI 做了什么，全程留审计记录。
- 部署在内网里，机器不直接暴露在外，设计目标是能接上万台机器。

## 怎么搭的

| 层 | 用什么 | 负责什么 |
| --- | --- | --- |
| 前端 | React + TypeScript + Ant Design | 网页控制台 |
| 管控层 | Go | 业务网关、工具调用网关（MCP）、Agent 集群管理 |
| AI 层 | Python + LangGraph + 大模型 | 理解问题、规划排查步骤、判断风险 |
| 执行层 | 装在每台机器上的 Agent（Go）+ MCP 工具 | 真正去机器上执行命令 |
| 存储 | PostgreSQL + Redis + 向量数据库 | 业务数据、缓存、知识库检索 |

计划分四步走：先做技术验证（POC），再出最小可用版本，然后补功能，最后做到能上生产。

## 文档

- [技术白皮书](docs/AI-Ops技术白皮书-完善版.md)：定位、架构、执行流程、安全合规、高可用、AI 幻觉防护
- [风险评估报告](docs/风险评估报告.md)：可能踩的坑和应对办法
- [API 规范](docs/API规范.md)
- [数据库设计](docs/数据库设计.md)
- [开发计划](docs/开发计划.md)

## 许可证

[MIT](LICENSE)。

---

<sub>船长系列，来自 [heihuzi-labs](https://github.com/heihuzi-labs)：[船长派活](https://github.com/heihuzi-labs/captain-agents) · [船长 K8s](https://github.com/heihuzi-labs/captain-kube) · **船长运维** · [船长待办](https://github.com/heihuzi-labs/captain-todo)</sub>
