# GitHub 上传快速指南

## 准备工作（只需做一次）

### 1. 在 GitHub 创建仓库

1. 访问 https://github.com/new
2. 填写信息：
   - Repository name: `pbl-learning`
   - 选择 Public 或 Private
   - ⚠️ **不要勾选** "Add a README file"
3. 点击 "Create repository"
4. **复制仓库地址**（在页面顶部显示）

## 快速命令（复制粘贴执行）

### 方法 1：使用 HTTPS（推荐）

```bash
# 1. 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/你的用户名/pbl-learning.git

# 2. 推送代码
git push -u origin main
```

**如果提示输入密码：**
- 用户名：你的 GitHub 用户名
- 密码：使用 Personal Access Token（不是密码）
- 获取 Token：https://github.com/settings/tokens → Generate new token (classic) → 勾选 repo

### 方法 2：使用 SSH

```bash
# 1. 添加远程仓库（替换为你的仓库地址）
git remote add origin git@github.com:你的用户名/pbl-learning.git

# 2. 推送代码
git push -u origin main
```

## 在 Zeabur 配置自动部署

### 1. 添加 GitHub 服务

1. 进入 Zeabur 项目：https://zeabur.cn
2. 点击 "+ Add Service"
3. 选择 "Git" → "GitHub"
4. 首次使用点击 "Connect GitHub" 授权
5. 选择 `pbl-learning` 仓库
6. 选择 `main` 分支
7. 点击 "Deploy"

### 2. 配置环境变量

在 Zeabur 服务中添加：
```
NEXT_PUBLIC_SUPABASE_URL=你的Supabase地址
NEXT_PUBLIC_SUPABASE_ANON_KEY=你的Supabase密钥
OPENAI_API_KEY=你的OpenAI密钥（可选）
```

### 3. 生成域名

1. 点击 "网络" 标签
2. 点击 "+ Generate Domain"
3. 访问生成的域名测试

## 日常更新流程

```bash
# 1. 修改代码后，查看更改
git status

# 2. 添加更改
git add .

# 3. 提交更改
git commit -m "描述你的更改"

# 4. 推送到 GitHub
git push

# 5. Zeabur 会自动检测并部署（1-3分钟）
```

## 常见问题

### 推送时提示 "remote origin already exists"

```bash
# 删除现有的 origin
git remote remove origin

# 重新添加
git remote add origin https://github.com/你的用户名/pbl-learning.git
```

### 推送时提示 "Permission denied"

**使用 HTTPS：**
- 确保使用 Personal Access Token 而不是密码
- 获取地址：https://github.com/settings/tokens

**使用 SSH：**
- 需要先配置 SSH Key
- 查看详细指南：`GITHUB_SETUP.md`

### 如何查看推送是否成功

```bash
# 查看远程仓库信息
git remote -v

# 查看推送状态
git log --oneline
```

访问 GitHub 仓库页面，应该能看到你的代码。

## 验证自动部署

1. 修改一个文件（如 README.md）
2. 提交并推送：
   ```bash
   git add README.md
   git commit -m "Test auto deploy"
   git push
   ```
3. 在 Zeabur 控制台查看 "日志" 标签
4. 等待部署完成（1-3分钟）
5. 刷新浏览器查看更新

---

📖 **详细文档**：查看 `GITHUB_SETUP.md` 获取完整指南
