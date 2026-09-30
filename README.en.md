<div align="center">

# Captain Ops · 船长运维

A self-hosted AI ops assistant: ask in chat, it investigates and runs commands on your machines, and anything risky waits for a human to approve.

[简体中文](README.md) · English

</div>

> Still at the design stage. This repo only holds the design documents so far; there is no runnable code yet.

## What it is

With enough machines, day-to-day ops looks the same every time: an alert fires, you log in, read logs, check processes and disks, then fix things from experience. Captain Ops aims to have AI do that legwork so people only make the calls.

How it's meant to work:

- Ask in Feishu, DingTalk, WeCom or a web page, e.g. "why did this service go down again?", and it investigates on the relevant machines and reports back with its evidence.
- Everyday questions can be answered from your internal knowledge base.
- Risky actions such as restarting services or deleting files never run straight away; they go to someone with the authority to approve them.
- Every action the AI takes, and who asked for it, is kept in an audit log.
- It runs inside your network so machines are never exposed, and the design target is tens of thousands of machines.

## How it's put together

| Layer | Built with | Responsible for |
| --- | --- | --- |
| Frontend | React + TypeScript + Ant Design | Web console |
| Control | Go | Business gateway, tool-call gateway (MCP), agent fleet management |
| AI | Python + LangGraph + LLMs | Understanding the question, planning the investigation, judging risk |
| Execution | An agent on every machine (Go) + MCP tools | Actually running commands on machines |
| Storage | PostgreSQL + Redis + a vector database | Business data, caching, knowledge-base search |

The plan has four steps: a proof of concept, a minimum usable version, filling in features, and finally production readiness.

## Documents (in Chinese)

- [Technical white paper](docs/AI-Ops技术白皮书-完善版.md): positioning, architecture, execution flow, security and compliance, high availability, guarding against AI hallucinations
- [Risk assessment](docs/风险评估报告.md): likely pitfalls and how to handle them
- [API specification](docs/API规范.md)
- [Database design](docs/数据库设计.md)
- [Development plan](docs/开发计划.md)

## License

[MIT](LICENSE).

---

<sub>Part of the Captain series from [heihuzi-labs](https://github.com/heihuzi-labs): [Captain Crew](https://github.com/heihuzi-labs/captain-crew) · [Captain Kube](https://github.com/heihuzi-labs/captain-kube) · **Captain Ops** · [Captain Todo](https://github.com/heihuzi-labs/captain-todo)</sub>
