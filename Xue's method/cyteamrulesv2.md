# CyTeam 协作规则 v1.0

**用途**: 定义人机混合团队（CyTeam）的协作规则和控制机制
**版本**: v1.0
**创建日期**: 2026-03-03
**适用场景**: 多人对多agent的团队协作

**阅读说明**：
- **Agent 只需要读正文部分**（第1-7节），附录部分供 member 参考
- Member 可以阅读全文，了解详细配置和操作说明

---

## 1. 核心概念

### 1.1 术语定义

| 术语 | 定义 |
|------|------|
| **CyTeam** | Cyber Team（人机混合团队） |
| **Member** | 团队中的真实人员 |
| **Agent** | Claude Code 中的 AI 助手（PM、Architect、Developer、QA、TechLead） |
| **CLI** | Claude Code CLI，member 和 agent 的编程工具 |

### 1.2 CyTeam 特点

| 特点 | 说明 |
|------|------|
| Member 可以兼职多个角色 | 一个 member 可以同时扮演 Developer 和 QA |
| Agent 不可以兼职 | 每个 agent 只能扮演一个角色 |
| Agent 借用 member 的账户 | Agent 使用 member 的 VPN 账户、Git 账户 |
| 审计追踪到 member | Git 记录的是 member 的操作痕迹，不是 agent |

---

## 2. 三层控制体系

```
第一层：VPN 控制（硬控制）→ 控制 member 对开发环境的访问
第二层：Git 控制（硬控制）→ 控制 member 对项目的访问 + 审计追踪
第三层：CLI 软约束（软控制）→ 提醒 agent 的职责边界
```

| 层级 | 控制对象 | 控制方式 | 作用 |
|------|---------|---------|------|
| 第一层 | Member | VPN 登录 | 谁能进入开发环境 |
| 第二层 | Member | Git 权限 | 谁能访问项目 + 审计追踪 |
| 第三层 | Agent | CLI 软约束 | 提醒 agent 职责边界 |

**说明**：
- VPN 和 Git 控制 member（agent 借用 member 的账户）
- CLI 软约束提醒 agent（可绕过，但会提醒）
- Git 提供完整的审计追踪（记录 member 的操作）

---

## 3. Agent 角色职责

| Agent 角色 | 职责范围 | 主要工作文件 |
|-----------|---------|------------|
| PM | 项目管理、需求确认、决策 | `docs/requirements.md`, `docs/project-statusv2.md` |
| Architect | 架构设计、技术方案 | `arch/architecture.md`, `arch/bsa-arch-v3.md` |
| Developer | 代码实现、bug修复 | `src/*` |
| QA | 测试、问题发现、验证 | `tests/*`, `docs/test-report-*.md` |
| TechLead | 技术审查、协调 | `docs/tech-statusv2.md` |

**说明**：
- 这些职责定义是软约束，不是硬限制
- Agent 可以读取所有文件
- Agent 应该主要修改自己职责范围内的文件
- CLI 会在 agent 越界时提醒

---

## 4. 角色兼职规则

### 4.1 Member 可以兼职多个角色

- 一个 member 可以同时扮演多个角色
- 例如：张三同时是 Developer 和 QA
- 配置方式：在 `cyteamconfig.md` 中配置

### 4.2 Agent 不可以兼职

- 每个 agent 只能扮演一个角色
- Developer Agent 只能做 Developer 的工作
- QA Agent 只能做 QA 的工作

### 4.3 特殊规则：同 member 兼职时的 agent 权限

**场景**：张三同时是 Developer 和 QA

**规则**：
- QA Agent 可以直接修改代码（因为张三也是 Developer）
- CLI 软约束会提醒，但不会阻止
- Git 日志记录的是张三的操作

---

## 5. 审计机制

### 5.1 审计层次

| 审计层次 | 审计内容 | 审计对象 | 审计工具 |
|---------|---------|---------|---------|
| VPN 审计 | 谁登录了开发环境 | Member | VPN 日志 |
| Git 审计 | 谁改了什么代码 | Member | Git 日志 |

**说明**：
- Git 日志提供完整、可靠、不可篡改的审计功能
- CLI 不提供审计功能（Git 审计已经足够）

### 5.2 Git 审计命令

```bash
# 查看某个文件的修改历史
git log --follow <file_path>

# 查看某个 member 的提交历史
git log --author="<author_name>"

# 查看某次提交的详细内容
git show <commit_hash>
```

---

## 6. 协作流程

### 6.1 跨角色协作（不同 member）

**协作方式**：通过 Git 和项目文档交流

```
Developer Agent（张三）→ 提交代码 → Git
    ↓
QA Agent（李四）→ 拉取代码 → 测试 → 写测试报告
    ↓
Developer Agent（张三）→ 读测试报告 → 修复 bug → 提交代码
```

### 6.2 同 member 跨角色协作

**协作方式**：可以直接修改代码

```
QA Agent（张三）→ 发现 bug → 直接修改代码 → 提交代码
```

---

## 7. CLI 软约束机制

### 7.1 当 agent 启动时

CLI 提醒 member：
- 当前 agent 的角色
- 职责范围
- 主要工作文件

### 7.2 当 agent 越界操作时

CLI 提醒 member：
- 当前操作超出职责范围
- 建议获得相关角色的同意
- 建议在 `docs/tech-statusv2.md` 中记录修改原因

### 7.3 当 member 坚持越界时

CLI 允许操作，但提醒 member 记录修改原因。

---

## 附录（供 Member 参考）

### 附录A：配置检查清单

#### PM 的配置检查清单

**VPN 配置**：
- [ ] 为每个 member 创建 VPN 账户
- [ ] 分发 VPN 账户信息
- [ ] 每个 member 都能成功登录 VPN

**Git 配置**：
- [ ] 为每个 member 创建 Git 账户（或使用现有账户）
- [ ] 将 member 添加到 Git 项目
- [ ] 每个 member 都能成功克隆项目

**CyTeam 配置**：
- [ ] 填写 `cyteamconfig.md`（member 和 agent 的配对关系）
- [ ] 每个 member 都理解自己的角色和职责

#### Member 的使用检查清单

**首次使用**：
- [ ] 能够登录 VPN
- [ ] 能够克隆 Git 项目
- [ ] 能够启动 Claude Code CLI
- [ ] 能够启动自己的 agent

**日常使用**：
- [ ] 遵守 agent 的职责边界
- [ ] 当越界操作时，记录原因
- [ ] 定期检查 Git 日志

---

### 附录B：常见问题

**Q1：如果我忘记了 VPN 账户信息怎么办？**
A：联系 PM，PM 可以重置密码。

**Q2：如果我需要修改其他角色的文件怎么办？**
A：CLI 会提醒你越界。如果你确实需要修改，可以继续，但请在 `docs/tech-statusv2.md` 中记录修改原因。

**Q3：如果我同时是 Developer 和 QA，QA Agent 可以改代码吗？**
A：可以。因为你也是 Developer，QA Agent 可以直接修改代码。

**Q4：Git 日志记录的是 member 还是 agent？**
A：Git 日志记录的是 member。Agent 借用 member 的 Git 账户。

**Q5：为什么 CLI 不提供审计功能？**
A：因为 Git 已经提供了完整、可靠、不可篡改的审计功能。

---

### 附录C：VPN 和 Git 配置详细说明

#### VPN 账户管理

**账户分配**：
- PM 为每个 member 创建 VPN 账户
- 账户信息：用户名 + 密码
- 分发方式：通过安全渠道分发

**Agent 使用**：
- Agent 借用 member 的 VPN 账户
- VPN 日志记录的是 member 的登录行为

#### Git 账户管理

**账户分配**：
- PM 为每个 member 创建 Git 账户（或使用现有账户）
- 账户信息：用户名 + 密码/SSH Key

**Agent 使用**：
- Agent 借用 member 的 Git 账户
- Git 日志记录的是 member 的提交行为

**Git 权限模型**：
- 所有 member 对项目目录下的所有文件都有读写权限
- 这和纯人力团队的 Git 权限模型一致

---

## 版本历史

**v1.0 (2026-03-03)**
- 初始版本
- 定义三层控制体系（VPN、Git、CLI）
- 明确控制对象（VPN 和 Git 控制 member，CLI 提醒 agent）
- 定义角色兼职规则（member 可以兼职，agent 不可以）
- 简化审计机制（只保留 VPN 日志和 Git 日志）
- 采用"核心内容在前，详细解释在后"的结构
- Agent 只需要读正文部分

---

## 文件维护

**维护者**：PM
**最后更新**：2026-03-03
**相关文件**：
- `cyteamconfig.md` - CyTeam 配置（member 和 agent 的配对关系）
- `hingeclaudev2c.md` - 协作框架（通用规则）
- `docs/project-statusv2.md` - 项目进度跟踪
- `docs/tech-statusv2.md` - 技术协调记录
