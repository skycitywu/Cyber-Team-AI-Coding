# 人机混合团队协作框架 v1.0

**用途**：定义团队协作规则、角色分工和工作流程
**适用范围**：所有使用 Claude Code 进行 AI 辅助开发的项目
**阅读对象**：团队成员（人）+ Agent（AI）

---

## 1. 核心概念

### 1.1 术语

| 术语 | 定义 |
|------|------|
| **CyTeam** | 人机混合团队（Cyber Team） |
| **Member** | 团队中的真实人员（项目经理、产品经理、开发负责人、开发成员） |
| **Agent** | Claude Code 中的 AI 助手，扮演特定角色（BA、Arch、Dev、TechLead） |
| **操作者** | 当前正在使用 Claude Code 的 Member |

### 1.2 基本原则

- **AI 做苦力，人做判断**：Agent 负责执行，Member 负责决策
- **文档驱动交接**：所有 Agent 之间的协作通过文档传递，不依赖口头约定
- **测试驱动完成**：代码必须通过单元测试才算完成
- **Git 审计追踪**：所有操作通过 Git 记录，Agent 借用操作者的 Git 账号

---

## 2. 角色总览

### 2.1 Agent 角色

| Agent | 操作者 | 核心职责 | 详细指令 |
|-------|--------|---------|---------|
| **BA**（业务分析师） | 产品经理 | 需求结构化、生成 PRD 和 HTML 原型 | `config/roles/BA.md` |
| **Arch**（架构师） | 开发负责人 | 架构设计、任务拆解、脚手架搭建 | `config/roles/ARCH.md` |
| **Dev**（开发者） | 开发负责人/成员 | TDD 方式编码实现 | `config/roles/DEV.md` |
| **TechLead**（技术负责人） | 开发负责人 | 架构审查 + 代码 Review | `config/roles/TECHLEAD.md` |

### 2.2 Member 角色

| Member | 操作的 Agent | 主要职责 |
|--------|-------------|---------|
| 项目经理 | 不操作 Agent | 对客沟通、流程管理、资源协调 |
| 产品经理 | BA | 需求沟通、PRD 产出、HTML 原型确认、验收测试 |
| 开发负责人 | Arch / Dev / TechLead | 架构设计、核心编码、技术审查 |
| 开发成员 | Dev | 功能编码、单元测试 |

### 2.3 角色自主权边界

每个 Agent 都有明确的决策边界：

| | 自主决策（直接做） | 需要确认（先问人） | 不能做 |
|---|---|---|---|
| **BA** | 需求结构化、提问澄清、原型布局 | 需求范围取舍、优先级排序 | 技术选型、架构决策 |
| **Arch** | 技术栈选择、模块划分、接口设计 | 重大架构变更、新技术引入 | 需求理解、业务优先级 |
| **Dev** | 实现细节、重构、bug 修复、TDD | 偏离架构设计、引入新依赖 | 需求变更、架构变更 |
| **TechLead** | 风险评估、质量判断、审查意见 | 是否接受风险、是否推倒重来 | 最终业务决策、直接改代码（含脚手架搭建） |

---

## 3. 文档体系

### 3.1 框架文件（config/）

| 文件 | 用途 | 维护者 |
|------|------|--------|
| `TEAM_GUIDE.md` | 本文件，团队协作框架 | 框架级，很少改 |
| `roles/*.md` | 各 Agent 角色的详细工作指令 | 框架级，很少改 |
| `PROJECT_STATUS.md` | 项目进度日志，AI 的"工作记忆" | 各 Agent 每次收工更新 |
| `TECH_STATUS.md` | 技术交接中枢，Review 意见 ↔ Dev 修复 | TechLead 写，Dev 读 |

### 3.2 项目文档（docs/）

| 文件 | 用途 | 产出者 |
|------|------|--------|
| `INIT_REQ.md` | 原始需求（永久保留，不修改） | 产品经理手写 |
| `PRD.md` | 正式需求文档（含验收标准） | BA Agent |
| `ARCH.md` | 架构设计文档 | Arch Agent |
| `TASKS.md` | 开发任务清单（含状态跟踪） | Arch Agent 创建，Dev 更新状态 |
| `prototypes/` | HTML 原型文件 | BA Agent |

### 3.3 文档流转关系

```
INIT_REQ.md → [BA] → PRD.md + prototypes/
                         ↓
                      [Arch] → ARCH.md + TASKS.md
                                  ↓
                               [TechLead 审查架构] → TECH_STATUS.md
                                  ↓ 审查通过
                               [Arch 搭建脚手架] → 项目骨架代码
                                  ↓
                               [TechLead 审查脚手架] → TECH_STATUS.md
                                  ↓ 审查通过
                               [Dev TDD] → 代码 + 测试 → TASKS.md 更新
                                  ↓
                               [TechLead Review] → TECH_STATUS.md
                                  ↓
                               [Dev 修复] → 代码修复 → TECH_STATUS.md 更新
```

---

## 4. 完整协作流程

### 第 0 步：项目初始化（开发负责人，一次性）

- [ ] 创建项目目录结构（可使用 `init_project.sh` 脚本）
- [ ] 填写 `CLAUDE.md`（开发规范如有特殊要求、Git 团队配置）
- [ ] `git init`，并切换到开发分支：`git checkout -b dev`
- [ ] 各团队成员在本机确认 git 配置与 `CLAUDE.md` 中一致：
  ```bash
  git config user.name "姓名"
  git config user.email "邮箱"
  ```
- [ ] 通知产品经理开始编写 `docs/INIT_REQ.md`

### 第 1 步：需求阶段（产品经理操作 BA Agent）

1. 产品经理手写 `docs/INIT_REQ.md`（原始需求，不需要完美）
2. 启动 Claude Code，输入启动指令（见第 5 节）
3. BA Agent 读取 INIT_REQ.md → 对话澄清 → 产出 `docs/PRD.md`（含验收标准）
4. BA Agent 生成 HTML 原型到 `docs/prototypes/`
5. 产品经理用浏览器打开原型给客户确认
6. 更新 `config/PROJECT_STATUS.md`
7. `git commit`（产品经理账号）

**交接 Checklist**：
- [ ] PRD.md 已完成，每个功能点都有验收标准
- [ ] HTML 原型已生成，客户已确认
- [ ] PROJECT_STATUS.md 已更新

### 第 2 步：架构阶段（开发负责人操作 Arch Agent）

1. 启动 Claude Code，输入启动指令
2. Arch Agent 读取 PRD.md + 原型 → 产出 `docs/ARCH.md` + `docs/TASKS.md`
3. 开发负责人审核架构设计
4. 启动 TechLead Agent 审查架构 → 意见写入 `config/TECH_STATUS.md`
5. 开发负责人决策：通过 → 继续 / 需修改 → Arch 修改后重新审查
6. 架构审查通过后，继续使用 Arch Agent 搭建脚手架（骨架代码 + 接口定义）
7. 启动 TechLead Agent 审查脚手架 → 检查接口签名与 ARCH.md 一致性、模块边界、可构建性
8. 开发负责人决策：通过 → 进入开发循环 / 需修改 → Arch 修改后重新审查
9. 更新 `config/PROJECT_STATUS.md`
10. `git commit`（开发负责人账号）

**交接 Checklist**：
- [ ] ARCH.md 模块划分清晰、接口定义明确
- [ ] TASKS.md 每个任务有验收标准和负责人
- [ ] TechLead 架构审查通过
- [ ] 脚手架已搭建，项目可构建运行，各模块骨架接口与 ARCH.md 一致
- [ ] TechLead 脚手架审查通过
- [ ] PROJECT_STATUS.md 已更新

### 第 3 步：开发循环（每个任务重复）

```
3a. 开工 — Dev Agent 读 PROJECT_STATUS.md + TASKS.md + TECH_STATUS.md
     ↓
3b. TDD 编码 — 先写测试（红）→ 写实现 → 测试通过（绿）
     ↓        更新 TASKS.md 状态为"待 Review"
     ↓        git commit（开发者账号）
     ↓
3c. TechLead Review — 读代码 → 写审查意见到 TECH_STATUS.md
     ↓                 更新 TASKS.md 状态为"修复中"（如有问题）
     ↓
3d. 修复（如需要）— Dev 读 TECH_STATUS.md → 修复 → 重跑测试
     ↓               标记 TECH_STATUS.md 已解决
     ↓               git commit
     ↓
3e. 完成 — TASKS.md 状态改为"完成" → 更新 PROJECT_STATUS.md
     ↓
    下一个任务
```

### 第 4 步：集成验收

1. 本地所有单元测试全部通过
2. 开发负责人操作 TechLead 做最终宏观审查
3. 打包，拷贝到内网
4. 产品经理对照 PRD.md 验收标准 + HTML 原型做端到端测试
5. 更新 `config/PROJECT_STATUS.md` 为"完成"
6. `git tag vX.Y`

### 需求变更流程

当项目进行中需要变更需求时：
1. 产品经理在 `docs/PRD.md` 末尾的「变更记录」中追加变更条目
2. 启动 BA Agent 评估变更影响（告知 BA 当前架构约束，可提供 `docs/ARCH.md` 摘要作为上下文）
3. 开发负责人评估技术影响，更新 `docs/ARCH.md` 和 `docs/TASKS.md`
4. 若 ARCH.md 有实质变更，启动 TechLead Agent 重新审查架构；若接口签名有变更，Arch 更新脚手架后 TechLead 再审查脚手架
5. `docs/INIT_REQ.md` **永不修改**（保留原始意图作为对照）

---

## 5. Agent 启动方式

每次启动 Claude Code 后，输入以下格式的启动指令：

### BA（产品经理用）
```
你现在是 BA（业务分析师）角色，请读取 config/roles/BA.md 并按其中第一步完整了解背景。
准备好后告诉我你理解的当前状态和接下来要做什么。
```

### Arch（开发负责人用）
```
你现在是 Arch（架构师）角色，请读取 config/roles/ARCH.md 并按其中第一步完整了解背景。
准备好后告诉我你理解的当前状态和接下来要做什么。
```

### Dev（开发负责人/成员用）
```
你现在是 Dev（开发者）角色，请读取 config/roles/DEV.md 并按其中第一步完整了解背景。
准备好后告诉我今天要做什么。
```

### TechLead（开发负责人用）
```
你现在是 TechLead（技术负责人）角色，请读取 config/roles/TECHLEAD.md 并按其中第一步完整了解背景。
准备好后告诉我你理解的当前状态，然后我会告诉你本次审查任务。
```

---

## 6. Git 审计机制

### 基本原则

- **AI 只做本地提交**：Agent 执行 `git add` + `git commit`，不执行 `git push`
- **人工控制推送**：操作者在确认 commit 内容后手动执行 `git push`，对远程仓库的操作必须经人工确认
- 所有操作通过 Git 记录，Agent 借用当前 Member 的 Git 账号提交

### 常用审计命令

- 查看某个成员的提交：`git log --author="姓名"`
- 查看某个文件的修改历史：`git log --follow 文件路径`

---

## 版本历史

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0 | [创建日期] | 初始版本 |
