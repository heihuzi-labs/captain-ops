# 参与船长运维

谢谢愿意来帮忙！修错字、补文档、报问题、写代码都欢迎。

船长运维现在分两块：能用的堡垒机（`backend/`、`frontend/`），和还在设计的 AI 运维助手（`docs/ai-ops/`）。两块都欢迎参与，对 AI 助手的设计有想法，直接开议题讨论就很有用。

## 动手之前

- 小改动（修 bug、改文档）直接提合并请求就行。
- 新功能先开个议题聊一下思路。
- 安全问题别公开，按 [SECURITY.md](https://github.com/heihuzi-labs/.github/blob/main/SECURITY.md) 私下报告。

## 跑起来

最省事的是 Docker：

```sh
docker compose up -d --build
```

打开 http://localhost:8080 ，用 `admin` / `admin123` 登录，里面有两台测试用的 SSH 服务器。

不用 Docker 的话，需要 Go 1.21 以上、Node.js、MySQL 和 Redis，配置在 `backend/config/config.yaml`：

```sh
cd backend && go run .            # 后端
cd frontend && npm ci && npm start   # 前端
```

本地开发也可以用 `./manage.sh start|stop|restart|status|logs` 一起管前后端。更多说明见 [docs/bastion/](docs/bastion/)。

## 提交前跑这些

```sh
cd backend && go build ./...
cd frontend && npm run build
```

后端目前还没有自动测试，`go vet` 在现有代码上也还有几处旧警告，都欢迎补。改了拦截规则或审计相关的代码，请在合并请求里写清楚手动验证了哪些命令、哪些情况。

## 这几条请特别注意

- **拦截和审计只收紧、不放宽。** 危险命令拦截、权限检查、审计记录是这个项目的根本，改动要说明为什么不会让原来拦得住的命令漏过去。
- **别提交真实数据。** 数据库初始化文件、截图、示例配置里只放测试数据，不放真实的服务器地址、密码、登录日志。
- 数据库结构变了，请同时补上迁移脚本（放在 `backend/migrations/`），并更新 `docker/mysql/init/`。

## 合并请求

写清楚改了什么、为什么、怎么验证的，模板里都有。一个合并请求只做一件事。

提交的代码按 [MIT](LICENSE) 许可证发布。

---

## Contributing (English)

Thanks for helping! Typos, docs, bug reports and code are all welcome. There are two parts: the working bastion host (`backend/`, `frontend/`) and the AI ops assistant design (`docs/ai-ops/`); design discussion in issues is very welcome.

- Small fixes: open a pull request directly. New features: open an issue first. Security problems: report privately, see [SECURITY.md](https://github.com/heihuzi-labs/.github/blob/main/SECURITY.md).
- Setup: `docker compose up -d --build`, then http://localhost:8080 with `admin` / `admin123`. Without Docker you need Go 1.21+, Node.js, MySQL and Redis (config in `backend/config/config.yaml`): `cd backend && go run .` and `cd frontend && npm ci && npm start`.
- Before submitting: `cd backend && go build ./...`, `cd frontend && npm run build`. There are no backend tests yet and `go vet` still has a few old warnings (fixes welcome); please describe what you checked by hand, especially for command blocking and audit changes.
- Command blocking, permission checks and auditing only get stricter. Never commit real data (server addresses, passwords, login logs), including in the init SQL and screenshots. Schema changes need a migration in `backend/migrations/` and an updated `docker/mysql/init/`.
- Contributions are released under the [MIT](LICENSE) license.
