# 将项目上传到 GitHub 并配置自动部署

## 第一步：在 GitHub 创建仓库

### 1. 登录 GitHub
访问 https://github.com 并登录你的账号

### 2. 创建新仓库
1. 点击右上角的 "+" 号
2. 选择 "New repository"（新建仓库）
3. 填写仓库信息：
   - **Repository name**（仓库名称）：`pbl-learning`
   - **Description**（描述）：`PBL Learning Platform - 基于项目的学习平台`
   - **Public/Private**（公开/私有）：选择 `Public`（公开）或 `Private`（私有）
   - ⚠️ **不要勾选** "Initialize this repository with a README"
   - ⚠️ **不要添加** .gitignore 或 license（我们已经有了）
4. 点击 "Create repository"（创建仓库）

### 3. 复制仓库地址
创建完成后，GitHub 会显示仓库地址，类似：
```
https://github.com/你的用户名/pbl-learning.git
```
或
```
git@github.com:你的用户名/pbl-learning.git
```

## 第二步：将本地代码推送到 GitHub

### 方法 1：使用 HTTPS（推荐新手）

在项目目录中运行以下命令：

```bash
# 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/你的用户名/pbl-learning.git

# 推送代码到 GitHub
git push -u origin main
```

**如果提示输入用户名和密码：**
- 用户名：你的 GitHub 用户名
- 密码：使用 Personal Access Token（不是 GitHub 密码）

**如何获取 Personal Access Token：**
1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 设置：
   - Note: `pbl-learning`
   - Expiration: 选择过期时间
   - 勾选 `repo` 权限
4. 点击 "Generate token"
5. **复制生成的 token**（只显示一次，请保存好）
6. 在命令行中使用这个 token 作为密码

### 方法 2：使用 SSH（推荐熟练用户）

**前提：需要先配置 SSH Key**

```bash
# 添加远程仓库（替换为你的仓库地址）
git remote add origin git@github.com:你的用户名/pbl-learning.git

# 推送代码到 GitHub
git push -u origin main
```

**如果还没有配置 SSH Key：**
1. 生成 SSH Key：
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
2. 复制公钥：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
3. 添加到 GitHub：
   - 访问 https://github.com/settings/keys
   - 点击 "New SSH key"
   - 粘贴公钥内容
   - 点击 "Add SSH key"

## 第三步：在 Zeabur 配置 GitHub 自动部署

### 1. 删除现有服务（可选）
如果你想用 GitHub 部署替换现有的上传部署：
1. 在 Zeabur 控制台中
2. 进入 pbl-learning 项目
3. 点击服务设置
4. 删除现有服务

### 2. 从 GitHub 创建新服务

1. **在 Zeabur 项目页面**，点击 "Add Service"（添加服务）
2. 选择 "Git"
3. 选择 "GitHub"
4. **首次使用需要授权**：
   - 点击 "Connect GitHub"
   - 在弹出窗口中授权 Zeabur 访问你的 GitHub
   - 选择授权所有仓库或特定仓库
5. **选择仓库**：
   - 在列表中找到 `pbl-learning`
   - 点击选择
6. **选择分支**：
   - 选择 `main` 分支
7. **配置构建**：
   - Framework: 自动检测为 `Next.js`
   - Build Command: `npm run build`（自动）
   - Start Command: `npm start`（自动）
8. 点击 "Deploy"（部署）

### 3. 配置环境变量

部署后，需要添加环境变量：

1. 点击服务进入详情页
2. 点击 "环境变量" 标签
3. 添加以下变量：
   ```
   NEXT_PUBLIC_SUPABASE_URL=你的Supabase地址
   NEXT_PUBLIC_SUPABASE_ANON_KEY=你的Supabase密钥
   OPENAI_API_KEY=你的OpenAI密钥（可选）
   ```
4. 点击 "保存"
5. 服务会自动重启

### 4. 配置域名

1. 点击 "网络" 标签
2. 点击 "+ Generate Domain" 生成免费域名
3. 或添加自定义域名

## 第四步：实现自动部署

配置完成后，每次你推送代码到 GitHub，Zeabur 会自动：
1. 检测到代码更新
2. 自动拉取最新代码
3. 自动构建项目
4. 自动部署到服务器

### 测试自动部署

1. **修改代码**（例如修改首页标题）：
   ```bash
   # 编辑文件
   nano app/page.tsx

   # 提交更改
   git add app/page.tsx
   git commit -m "Update homepage title"

   # 推送到 GitHub
   git push
   ```

2. **查看 Zeabur 自动部署**：
   - 在 Zeabur 控制台中
   - 查看 "日志" 标签
   - 你会看到自动触发的构建过程

3. **等待部署完成**（通常 1-3 分钟）

4. **刷新浏览器**查看更新

## 日常开发流程

### 本地开发
```bash
# 启动开发服务器
npm run dev

# 在浏览器中测试：http://localhost:3000
```

### 提交更改
```bash
# 查看修改的文件
git status

# 添加文件到暂存区
git add .

# 提交更改
git commit -m "描述你的更改"

# 推送到 GitHub
git push
```

### 自动部署
- 推送后，Zeabur 会自动部署
- 在 Zeabur 控制台查看部署进度
- 部署完成后，访问域名查看更新

## 常见问题

### Q1: git push 时提示 "Permission denied"

**解决方法：**
- 检查是否正确配置了 SSH Key 或 Personal Access Token
- 确认仓库地址是否正确
- 尝试使用 HTTPS 方式推送

### Q2: Zeabur 没有自动部署

**可能原因：**
- GitHub 授权未正确配置
- Webhook 未正确设置

**解决方法：**
1. 在 GitHub 仓库中，进入 Settings → Webhooks
2. 检查是否有 Zeabur 的 webhook
3. 如果没有，在 Zeabur 中重新连接 GitHub

### Q3: 部署失败

**排查步骤：**
1. 查看 Zeabur 的构建日志
2. 检查环境变量是否配置正确
3. 确认 package.json 中的脚本是否正确
4. 检查是否有语法错误

### Q4: 如何回滚到之前的版本

**方法 1：通过 Git**
```bash
# 查看提交历史
git log

# 回滚到指定提交
git revert <commit-hash>
git push
```

**方法 2：通过 Zeabur**
1. 在 Zeabur 控制台中
2. 查看部署历史
3. 选择之前的部署版本
4. 点击 "Redeploy"

## 协作开发

### 添加协作者

**在 GitHub 上：**
1. 进入仓库页面
2. 点击 Settings → Collaborators
3. 点击 "Add people"
4. 输入协作者的 GitHub 用户名
5. 发送邀请

**协作者的工作流程：**
```bash
# 克隆仓库
git clone https://github.com/你的用户名/pbl-learning.git
cd pbl-learning

# 安装依赖
npm install

# 创建新分支
git checkout -b feature/new-feature

# 开发和提交
git add .
git commit -m "Add new feature"

# 推送分支
git push origin feature/new-feature

# 在 GitHub 上创建 Pull Request
```

## 分支管理策略

### 推荐的分支结构

- `main` - 生产环境分支（自动部署到 Zeabur）
- `develop` - 开发分支
- `feature/*` - 功能分支
- `bugfix/*` - 修复分支

### 工作流程

```bash
# 从 main 创建开发分支
git checkout -b develop

# 从 develop 创建功能分支
git checkout -b feature/user-profile

# 开发完成后合并回 develop
git checkout develop
git merge feature/user-profile

# 测试通过后合并到 main
git checkout main
git merge develop
git push

# Zeabur 自动部署 main 分支
```

## 下一步

1. ✅ 将代码推送到 GitHub
2. ✅ 在 Zeabur 配置 GitHub 自动部署
3. ✅ 测试自动部署流程
4. ✅ 配置生产环境的 Supabase
5. ✅ 添加自定义域名
6. ✅ 邀请团队成员协作

---

**需要帮助？** 如果在任何步骤遇到问题，请告诉我具体的错误信息。
