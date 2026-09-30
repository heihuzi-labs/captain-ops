<div align="center">

# 船长运维 · Captain Ops

管住“谁能登哪台机器、登上去做了什么”的运维平台。现在是一套能跑的堡垒机，下一步把 AI 助手接进来。

简体中文 · [English](README.en.md)

</div>

![仪表板](docs/images/dashboard.png)

## 这是什么

服务器多了、人多了，最怕的是说不清：谁登过生产机、敲了什么命令、是谁把服务弄挂的。船长运维分两步解决这件事。

**第一步，堡垒机（已经能用）。** 所有人都从这里登机器，不再各自拿着密码直连。网页上点一下就能开终端，每次登录都录下来，事后能像看视频一样回放；`rm -rf` 这类危险命令当场拦住；登录、操作、敲过的每条命令都记进审计日志。

**第二步，AI 运维助手（正在设计）。** 在飞书、钉钉、企业微信里说一句“某某服务怎么又挂了”，AI 去机器上排查，把结论和证据回给你。AI 碰不到服务器，它想好的命令要走和堡垒机一样的拦截、审批和审计。

> 堡垒机部分是给学习和测试用的，自带默认密码和默认密钥，别原样放到生产环境。

## 堡垒机能做什么

<table>
<tr>
<td width="50%"><img src="docs/images/webssh.png" alt="网页终端"><br><sub>网页终端：左边按分组挑机器，右边直接开终端，能同时开好几个标签页</sub></td>
<td width="50%"><img src="docs/images/session-replay.png" alt="会话回放"><br><sub>会话回放：每次登录都录下来，右边列出敲过的命令，点一下跳到那个时刻</sub></td>
</tr>
<tr>
<td><img src="docs/images/command-filter.png" alt="危险命令拦截"><br><sub>危险命令拦截：<code>rm</code>、<code>rm -rf</code>、换个写法的 <code>\rm</code> 都拦得住</sub></td>
<td><img src="docs/images/security.png" alt="操作审计"><br><sub>操作审计：谁在什么时候、从哪里、做了什么，一条条都查得到</sub></td>
</tr>
</table>

- **用户和权限**：按角色分权限（管理员、运维人员、审计员），每个操作都先查权限。
- **资产和凭证**：机器按生产、测试、开发等分组；登录密码和密钥加密保存，用的人不用知道密码本身。
- **网页终端**：浏览器里直接登机器，不用装客户端，断线会自动重连。
- **命令规则**：把命令编成组，按用户、机器、登录账号配“禁止”“放行”或“告警”。
- **审计**：在线会话能实时看、能强制踢下线；登录日志、操作日志、命令记录、录像都能按人、按机器、按时间查。

## 跑起来

需要 Docker（带 Compose），机器上留出 4GB 内存。

```sh
git clone https://github.com/heihuzi-labs/captain-ops.git && cd captain-ops
docker compose up -d --build
```

打开 http://localhost:8080 ，用 `admin` / `admin123` 登录（登录后先改密码）。里面已经放了两台测试用的 SSH 服务器，可以直接连上去试拦截和回放。

更多说明，比如不用 Docker 本地开发、数据库怎么导入，见 [Docker 部署](docs/bastion/Docker部署.md) 和 [数据库导入指南](docs/bastion/数据库导入指南.md)。本地开发可以用 `./manage.sh start|stop|restart|status|logs` 一起管前后端。

**上线前一定要改的**：`admin` 的密码、`backend/config/config.yaml` 和 `docker/backend/config.docker.yaml` 里的数据库密码和 JWT 密钥，以及 `docker-compose.yml` 里的 MySQL 密码。

## 下一步：AI 运维助手

![AI 助手的设想](docs/images/overview.svg)

AI 只负责想，不负责动手。它想好的每一条命令都交给网关，网关查权限、过危险命令名单、记审计，才转给机器上的 Agent 执行。按危险程度分四档：

| 档位 | 举例 | 怎么处理 |
| --- | --- | --- |
| 低 | 看日志、看状态、只读查询 | 先给你看要执行什么，然后执行 |
| 中 | 重启服务、清理临时文件 | 先给你看，你点确认才执行 |
| 高 | 重启机器、改配置 | 发给一位有权限的人审批 |
| 最高 | 删数据、格式化磁盘 | 两个人都批了，执行前还要再确认一次 |

大模型会“一本正经地胡说”，所以从听懂问题到执行，中间还设了五道关：听懂了吗、参数齐不齐、有多危险、命令合不合法、执行前再看一眼。另外限速，同一台机器一小时最多 3 条高危指令，一次最多动 50 台。

计划先做最小可用版：接飞书一个渠道、最多 10 台机器、5 个最常用的排查工具，审计和危险命令拦截第一天就有。完整方案在 [docs/ai-ops/](docs/ai-ops/)：

- [技术白皮书](docs/ai-ops/AI-Ops技术白皮书-完善版.md)：架构、执行流程、审批流程、安全合规、高可用、AI 幻觉防护，都配了流程图
- [风险评估报告](docs/ai-ops/风险评估报告.md) · [API 规范](docs/ai-ops/API规范.md) · [数据库设计](docs/ai-ops/数据库设计.md) · [开发计划](docs/ai-ops/开发计划.md)

## 怎么做出来的

堡垒机的后端（Go，约 2.4 万行）和前端（React + TypeScript，约 2.7 万行）几乎全是 AI 写的，主要用 Claude Code，少量用 Cursor。人负责提需求、拍板和验收。

做法是每个功能先写需求、设计和任务清单，再让 AI 照着一步步做，做完测试、写总结。这些过程文件都留在 [.specs/](.specs/) 里，流程本身的说明见 [开发功能](docs/bastion/specs开发工作流-开发功能.md) 和 [修复问题](docs/bastion/specs工作流-修复过程.md)。

## 目录

| 位置 | 是什么 |
| --- | --- |
| `backend/` | 后端：Go + Gin + GORM，JWT 登录，WebSocket 终端，Redis |
| `frontend/` | 前端：React 18 + TypeScript + Ant Design + xterm.js |
| `docker/`、`docker-compose.yml` | 一键部署：前端、后端、MySQL、Redis 和两台测试 SSH 服务器 |
| `scripts/` | 建表、迁移、清理用的脚本 |
| `docs/bastion/` | 堡垒机的需求、架构、接口、审计规范、命令拦截调研 |
| `docs/ai-ops/` | AI 运维助手的设计文档 |
| `.specs/` | 每个功能的需求、设计、任务记录 |

## 许可证

[MIT](LICENSE)。

---

<sub>船长系列，来自 [heihuzi-labs](https://github.com/heihuzi-labs)：[船长派活](https://github.com/heihuzi-labs/captain-agents) · [船长 K8s](https://github.com/heihuzi-labs/captain-kube) · **船长运维** · [船长密码箱](https://github.com/heihuzi-labs/captain-password) · [船长待办](https://github.com/heihuzi-labs/captain-todo)</sub>
