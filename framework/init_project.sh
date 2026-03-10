#!/bin/bash
# ============================================================
# CyTeam 项目初始化脚本
# 用法: ./init_project.sh <项目目录路径>
# 示例: ./init_project.sh /path/to/my-project
# ============================================================

set -e

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 <项目目录路径>"
    echo "示例: $0 /path/to/my-project"
    exit 1
fi

PROJECT_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "CyTeam 项目初始化"
echo "项目目录: $PROJECT_DIR"
echo "=========================================="

# 创建目录结构
echo ""
echo "[1/4] 创建目录结构..."
mkdir -p "$PROJECT_DIR/config/roles"
mkdir -p "$PROJECT_DIR/docs/prototypes"
mkdir -p "$PROJECT_DIR/tests"
echo "  ✅ 目录结构已创建"

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
echo "  ✅ 文档模板已复制"

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
echo "  │   └── prototypes/           ← BA Agent 产出的HTML原型"
echo "  ├── tests/                    ← 单元测试"
echo "  └── .gitignore"
echo ""
echo "下一步操作："
echo "  1. 开发负责人填写 CLAUDE.md（技术栈、Git配置等）"
echo "  2. 在项目目录执行 git init && git add -A && git commit -m 'init: 项目初始化'"
echo "  3. 产品经理填写 docs/INIT_REQ.md"
echo "  4. 产品经理启动 Claude Code，输入 BA 启动指令开始需求分析"
echo ""
