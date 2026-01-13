# 数据库设置指南

## 重要：在测试之前必须完成数据库设置

当前应用需要在 Supabase 中创建数据库表才能正常工作。请按照以下步骤操作：

## 步骤 1: 登录 Supabase Dashboard

1. 访问 https://supabase.com/dashboard
2. 选择你的项目

## 步骤 2: 运行 SQL 脚本

1. 在左侧菜单中点击 **SQL Editor**
2. 点击 **New Query** 创建新查询
3. 复制 `supabase-setup.sql` 文件的全部内容
4. 粘贴到 SQL 编辑器中
5. 点击 **Run** 按钮执行脚本

## 步骤 3: 验证表已创建

在 SQL Editor 中运行以下查询来验证：

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

你应该看到以下表：
- projects
- project_members
- learning_stages
- stage_fields
- test_questions
- test_attempts
- test_answers
- ai_interactions
- progress_snapshots

## 步骤 4: 配置认证设置（可选）

如果你想跳过邮箱验证（方便测试）：

1. 在左侧菜单中点击 **Authentication** > **Settings**
2. 找到 **Email Auth** 部分
3. 关闭 **Enable email confirmations**
4. 点击 **Save**

## 步骤 5: 测试应用

完成数据库设置后：

1. 访问 http://localhost:3002
2. 点击"登录/注册"
3. 注册一个新账户
4. 登录后应该能看到项目看板
5. 尝试创建一个新项目

## 常见问题

### Q: 运行 SQL 脚本时出错
A: 确保你的 Supabase 项目已启用 UUID 扩展。如果出现权限错误，可能需要联系 Supabase 支持。

### Q: 创建项目时返回 401 错误
A: 确保你已经登录，并且 Supabase 认证配置正确。

### Q: 创建项目时返回 500 错误
A: 检查浏览器控制台和终端日志，可能是数据库表未正确创建。

## 当前状态

✅ 本地服务器运行在: http://localhost:3002
✅ 健康检查端点正常: /api/health
⚠️ 需要完成数据库设置才能使用完整功能

## 下一步

完成数据库设置后，你可以：
1. 测试完整的 6 阶段 PBL 工作流
2. 创建多个项目
3. 在不同阶段之间导航
4. 填写每个阶段的表单
5. 跟踪项目进度
