# CyTeam 人机混合团队协作框架 — 快速上手指南

**用途**：本框架是企业团队使用AI Coding工具进行软件开发协作的一套实践方法。本指南旨在帮助团队成员快速理解和使用本框架

---

## 一句话说明

> 每个团队成员启动 Claude Code 后，告诉 AI "你是什么角色"，AI 就会自动读取框架文件，知道该做什么、怎么做、做完后更新什么。

---

## 核心概念（2 分钟理解）

### 4 个 AI 角色

| 角色 | 谁来操作 | 做什么 |
|------|---------|--------|
| **BA**（业务分析师） | 产品经理 | 把模糊需求变成结构化的 PRD + HTML 原型 |
| **Arch**（架构师） | 开发负责人 | 设计系统架构，把需求拆成开发任务 |
| **Dev**（开发者） | 开发负责人/成员 | 先写测试、再写代码，测试通过才算完成 |
| **TechLead**（技术负责人） | 开发负责人 | 审查架构设计 + 审查代码质量 |

### 3 个关键文件

| 文件 | 作用 | 类比 |
|------|------|------|
| `CLAUDE.md` | 告诉 AI 项目的技术栈和规范 | 项目"身份证" |
| `config/PROJECT_STATUS.md` | AI 的工作日志，每次开工读、收工写 | AI 的"日记本" |
| `config/TECH_STATUS.md` | TechLead 审查意见 ↔ Dev 修复记录 | 团队"便签墙" |

---

## 项目从 0 到 1 的完整步骤

### 第 0 步：初始化项目（开发负责人，5 分钟）

```bash
# 运行初始化脚本，创建目录结构和模板文件
./init_project.sh /path/to/my-project

# 进入项目目录
cd /path/to/my-project

# 编辑 CLAUDE.md，填写技术栈和规范
# （这是唯一需要手动编辑的框架文件）

# 初始化 Git
git init
git add -A
git commit -m "init: 项目初始化"
```

### 第 1 步：需求阶段（产品经理，约 1-2 小时）

1. **手写** `docs/INIT_REQ.md` — 用自己的话描述需求，不用完美
2. **打开 Claude Code**，输入：

```
你现在是 BA（业务分析师）角色，请读取 config/roles/BA.md 并按其中第一步完整了解背景。
准备好后告诉我你理解的当前状态和接下来要做什么。
```

3. **和 BA 对话**，回答它的澄清问题
4. **产出**：`docs/PRD.md` + `docs/prototypes/*.html`
5. 用浏览器打开 HTML 原型给客户确认
6. `git commit`

### 第 2 步：架构阶段（开发负责人，约 1-2 小时）

1. **打开 Claude Code**，输入：

```
你现在是 Arch（架构师）角色，请读取 config/roles/ARCH.md 并按其中第一步完整了解背景。
准备好后告诉我你理解的当前状态和接下来要做什么。
```

2. **审核产出**：`docs/ARCH.md` + `docs/TASKS.md`
3. **启动 TechLead 审查架构**（可选但建议）：

```
你现在是 TechLead（技术负责人）角色，请读取 config/roles/TECHLEAD.md 并按其中第一步完整了解背景。
准备好后告诉我你理解的当前状态，然后我会告诉你本次审查任务。
```

然后说："请对 docs/ARCH.md 进行架构审查"

4. **审查通过后，让 Arch 搭建脚手架**（在同一 Arch 会话中继续，或开新会话）：

```
你现在是 Arch（架构师）角色，请读取 config/roles/ARCH.md 并按其中第一步完整了解背景。
准备好后告诉我你理解的当前状态和接下来要做什么。
```

然后说："架构已通过 TechLead 审查，请按 ARCH.md 的设计搭建项目脚手架（骨架代码），确保项目可构建、各模块接口已定义。"

5. `git commit`

### 第 3 步：开发阶段（开发负责人/成员，按任务循环）

每个任务的工作流：

1. **打开 Claude Code**，输入：

```
你现在是 Dev（开发者）角色，请读取 config/roles/DEV.md 并按其中第一步完整了解背景。
准备好后告诉我今天要做什么。
```

2. **Dev Agent 会自动**：读任务 → 写测试 → 写代码 → 跑测试 → 更新进度
3. **任务完成后，启动 TechLead 做 Review**
4. **如有问题**，Dev 读 TECH_STATUS.md 修复 → 重跑测试
5. `git commit`

### 第 4 步：集成验收

1. 本地所有测试通过
2. 打包拷贝内网
3. 产品经理对照 PRD + HTML 原型做端到端测试
4. `git tag vX.Y`

---

## 每天的工作流程（日常操作）

```
开工：
  打开 Claude Code → 输入角色启动指令 → AI 自动读取进度文件
  → AI 告诉你"上次做到哪了，今天建议做什么"

工作中：
  和 AI 对话完成工作 → AI 按角色指令执行

收工：
  AI 更新 PROJECT_STATUS.md → git commit → 关闭 Claude Code
```

---

## 各角色速查卡

### 产品经理

```
你的 Agent：BA
你的工作：
  1. 手写 INIT_REQ.md（原始需求）
  2. 启动 BA Agent，对话产出 PRD.md + HTML 原型
  3. 带 HTML 原型给客户确认
  4. 项目完成时，对照 PRD 做验收
你不需要：写代码、懂技术、配置环境
```

### 开发负责人

```
你的 Agent：Arch / Dev / TechLead（按阶段切换）
你的工作：
  1. 初始化项目，填写 CLAUDE.md
  2. 操作 Arch Agent 做架构设计、任务拆解和脚手架搭建
  3. 操作 Dev Agent 做核心模块编码
  4. 操作 TechLead Agent 审查架构和代码
  5. 分配任务给开发成员
你是关键人：架构决策、技术审查、最终质量把关
```

### 开发成员

```
你的 Agent：Dev
你的工作：
  1. 读 TASKS.md 领取任务
  2. 启动 Dev Agent，TDD 方式编码
  3. 测试通过后等待 Review
  4. 按 TECH_STATUS.md 修复问题
你不需要：做架构决策、做需求分析
```

---

## 常见问题

**Q：AI 能记住昨天做了什么吗？**
A：不能，AI 没有跨会话记忆。但每次开工时 AI 会读 `PROJECT_STATUS.md`，里面有完整的工作记录，所以它能"恢复记忆"。**收工前一定要让 AI 更新这个文件。**

**Q：产品经理不懂技术，能操作 Claude Code 吗？**
A：能。只需要复制启动指令粘贴到 Claude Code 中，然后用自然语言和 AI 对话即可。BA Agent 会引导你完成所有工作。

**Q：开发负责人要在 Arch/Dev/TechLead 之间频繁切换？**
A：是的，但每次切换只需要关闭当前会话、开新会话、粘贴对应启动指令。实际上这和日常工作中你在"设计""编码""Review"之间切换是一样的，只是现在有 AI 帮你执行。

**Q：多个开发成员同时开发不同任务会冲突吗？**
A：不会，每个人操作自己的 Claude Code 会话，开发不同的任务。通过 Git 管理代码合并。TASKS.md 中每个任务标注了负责人，避免重复工作。

**Q：内网测试发现 bug 怎么办？**
A：在 `config/PROJECT_STATUS.md` 中记录 bug 为阻塞项，然后启动 Dev Agent 修复。修复后重新打包拷贝内网验证。

**Q：需求变更怎么办？**
A：产品经理在 `docs/PRD.md` 的「变更记录」中追加变更条目（不修改 INIT_REQ.md），然后启动 BA Agent 评估影响。开发负责人更新 ARCH.md 和 TASKS.md。

---

## 文件清单（完整列表）

```
framework/
├── CLAUDE.md                       # AI 项目说明书（放项目根目录）
├── config/
│   ├── TEAM_GUIDE.md               # 团队协作框架
│   ├── roles/
│   │   ├── BA.md                   # BA 角色指令
│   │   ├── ARCH.md                 # Arch 角色指令
│   │   ├── DEV.md                  # Dev 角色指令
│   │   └── TECHLEAD.md             # TechLead 角色指令
│   ├── PROJECT_STATUS.md           # 项目进度日志
│   └── TECH_STATUS.md              # 技术交接中枢
├── docs/
│   ├── INIT_REQ.md                 # 原始需求模板
│   ├── PRD.md                      # PRD 模板
│   ├── ARCH.md                     # 架构文档模板
│   ├── TASKS.md                    # 任务清单模板
│   └── prototypes/                 # HTML 原型目录
├── init_project.sh                 # 项目初始化脚本
└── QUICK_START.md                  # 本文件（快速上手指南）
```
