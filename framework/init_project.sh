#!/bin/bash
# ============================================================
# CyTeam 项目初始化脚本
# 用法: ./init_project.sh [--existing] <项目目录路径>
# 示例: ./init_project.sh /path/to/my-project            # 全新项目
#       ./init_project.sh --existing /path/to/my-project   # 接入已有项目（二期开发）
# ============================================================

set -e

# 解析参数
MODE="new"
if [ "$1" = "--existing" ]; then
    MODE="existing"
    shift
fi

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 [--existing] <项目目录路径>"
    echo ""
    echo "选项："
    echo "  --existing    接入已有项目（二期开发），额外创建 docs/phase1/ 目录和基线模板"
    echo ""
    echo "示例："
    echo "  $0 /path/to/my-project              # 全新项目"
    echo "  $0 --existing /path/to/my-project    # 二期接入"
    exit 1
fi

PROJECT_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$MODE" = "existing" ]; then
    echo "=========================================="
    echo "CyTeam 项目初始化（二期接入模式）"
    echo "项目目录: $PROJECT_DIR"
    echo "=========================================="
else
    echo "=========================================="
    echo "CyTeam 项目初始化（全新项目）"
    echo "项目目录: $PROJECT_DIR"
    echo "=========================================="
fi

# 创建目录结构
echo ""
echo "[1/4] 创建目录结构..."
mkdir -p "$PROJECT_DIR/config/roles"
mkdir -p "$PROJECT_DIR/docs/prototypes"
mkdir -p "$PROJECT_DIR/tests"
if [ "$MODE" = "existing" ]; then
    mkdir -p "$PROJECT_DIR/docs/phase1"
    echo "  ✅ 目录结构已创建（含 docs/phase1/）"
else
    echo "  ✅ 目录结构已创建"
fi

# 复制框架文件
echo ""
echo "[2/4] 复制框架文件..."
cp "$SCRIPT_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
cp "$SCRIPT_DIR/config/TEAM_GUIDE.md" "$PROJECT_DIR/config/TEAM_GUIDE.md"
cp "$SCRIPT_DIR/config/PROJECT_STATUS.md" "$PROJECT_DIR/config/PROJECT_STATUS.md"
cp "$SCRIPT_DIR/config/TECH_STATUS.md" "$PROJECT_DIR/config/TECH_STATUS.md"
cp "$SCRIPT_DIR/config/roles/BA.md" "$PROJECT_DIR/config/roles/BA.md"
cp "$SCRIPT_DIR/config/roles/ARCH.md" "$PROJECT_DIR/config/roles/ARCH.md"
cp "$SCRIPT_DIR/config/roles/DEV.md" "$PROJECT_DIR/config/roles/DEV.md"
cp "$SCRIPT_DIR/config/roles/TECHLEAD.md" "$PROJECT_DIR/config/roles/TECHLEAD.md"
echo "  ✅ 框架文件已复制"

# 复制文档模板
echo ""
echo "[3/4] 复制文档模板..."
cp "$SCRIPT_DIR/docs/INIT_REQ.md" "$PROJECT_DIR/docs/INIT_REQ.md"
cp "$SCRIPT_DIR/docs/PRD.md" "$PROJECT_DIR/docs/PRD.md"
cp "$SCRIPT_DIR/docs/ARCH.md" "$PROJECT_DIR/docs/ARCH.md"
cp "$SCRIPT_DIR/docs/TASKS.md" "$PROJECT_DIR/docs/TASKS.md"
if [ "$MODE" = "existing" ]; then
    cp "$SCRIPT_DIR/docs/phase1/INIT_REQ.md" "$PROJECT_DIR/docs/phase1/INIT_REQ.md"
    cp "$SCRIPT_DIR/docs/phase1/CODEBASE.md" "$PROJECT_DIR/docs/phase1/CODEBASE.md"
    echo "  ✅ 文档模板已复制（含 phase1/INIT_REQ.md 和 phase1/CODEBASE.md 模板）"
else
    echo "  ✅ 文档模板已复制"
fi

# 创建 .gitignore
echo ""
echo "[4/4] 创建 .gitignore..."
cat > "$PROJECT_DIR/.gitignore" << 'GITIGNORE'
# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# 环境和密钥
.env
*.key
*.pem

# 构建产物
target/
build/
dist/
node_modules/
__pycache__/
*.pyc
*.class
*.jar
*.war

# 日志
*.log
logs/
GITIGNORE
echo "  ✅ .gitignore 已创建"

# 二期接入模式：自动修改 CLAUDE.md 中的项目阶段
if [ "$MODE" = "existing" ]; then
    sed -i '' 's/- \*\*当前模式\*\*：全新开发/- **当前模式**：二期接入/' "$PROJECT_DIR/CLAUDE.md"
    sed -i '' 's/- \*\*基线文档\*\*：无/- **基线文档**：docs\/phase1\//' "$PROJECT_DIR/CLAUDE.md"
    # 修改 PROJECT_STATUS.md 的项目模式
    sed -i '' 's/\*\*项目模式\*\*：全新开发/**项目模式**：二期接入/' "$PROJECT_DIR/config/PROJECT_STATUS.md"
fi

# 完成提示
echo ""
echo "=========================================="
echo "✅ 项目初始化完成！"
echo "=========================================="
echo ""
echo "目录结构："
echo "  $PROJECT_DIR/"
echo "  ├── CLAUDE.md                 ← 【开发负责人】请先填写技术栈和规范"
echo "  ├── config/"
echo "  │   ├── TEAM_GUIDE.md         ← 团队协作框架（通常不需要修改）"
echo "  │   ├── roles/                ← 角色工作指令（通常不需要修改）"
echo "  │   │   ├── BA.md"
echo "  │   │   ├── ARCH.md"
echo "  │   │   ├── DEV.md"
echo "  │   │   └── TECHLEAD.md"
echo "  │   ├── PROJECT_STATUS.md     ← 项目进度日志"
echo "  │   └── TECH_STATUS.md        ← 技术交接中枢"
echo "  ├── docs/"
echo "  │   ├── INIT_REQ.md           ← 【产品经理】请先填写原始需求"
echo "  │   ├── PRD.md                ← BA Agent 产出"
echo "  │   ├── ARCH.md               ← Arch Agent 产出"
echo "  │   ├── TASKS.md              ← Arch Agent 产出"
echo "  │   ├── prototypes/           ← BA Agent 产出的HTML原型"
if [ "$MODE" = "existing" ]; then
echo "  │   └── phase1/               ← 一期基线文档"
echo "  │       ├── INIT_REQ.md       ← 【产品经理】请先填写一期功能描述"
echo "  │       ├── CODEBASE.md       ← Arch Agent 逆向重建产出（代码导航）"
echo "  │       ├── PRD.md            ← BA Agent 逆向重建产出（不需要预先创建）"
echo "  │       └── ARCH.md           ← Arch Agent 逆向重建产出（不需要预先创建）"
fi
echo "  ├── tests/                    ← 单元测试"
echo "  └── .gitignore"
echo ""

if [ "$MODE" = "existing" ]; then
    echo "下一步操作（二期接入）："
    echo "  1. 开发负责人填写 CLAUDE.md（技术栈、Git配置、一期代码仓库路径）"
    echo "  2. 在项目目录执行 git init && git add -A && git commit -m 'init: 二期项目初始化'"
    echo "  3. 产品经理整理一期需求描述"
    echo "  4. 产品经理启动 BA Agent，执行基线 PRD 逆向重建"
    echo "  5. 开发负责人启动 Arch Agent，执行基线架构逆向重建"
    echo "  6. 开发负责人人工校验基线文档后，进入正常开发流程"
else
    echo "下一步操作："
    echo "  1. 开发负责人填写 CLAUDE.md（技术栈、Git配置等）"
    echo "  2. 在项目目录执行 git init && git add -A && git commit -m 'init: 项目初始化'"
    echo "  3. 产品经理填写 docs/INIT_REQ.md"
    echo "  4. 产品经理启动 Claude Code，输入 BA 启动指令开始需求分析"
fi
echo ""
