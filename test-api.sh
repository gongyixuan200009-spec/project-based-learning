#!/bin/bash

# API 测试脚本
# 用于测试 PBL Learning Platform 的 API 端点

BASE_URL="http://localhost:3002"

echo "🧪 开始测试 PBL Learning Platform API"
echo "=================================="
echo ""

# 测试 1: 健康检查
echo "📋 测试 1: 健康检查端点"
echo "GET $BASE_URL/api/health"
curl -s "$BASE_URL/api/health" | jq '.'
echo ""
echo ""

# 测试 2: 未认证访问项目列表（应该返回 401）
echo "📋 测试 2: 未认证访问项目列表（预期 401）"
echo "GET $BASE_URL/api/projects"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/projects")
if [ "$HTTP_CODE" = "401" ]; then
    echo "✅ 正确返回 401 Unauthorized"
else
    echo "❌ 返回了 $HTTP_CODE，预期是 401"
fi
echo ""
echo ""

# 测试 3: 未认证创建项目（应该返回 401）
echo "📋 测试 3: 未认证创建项目（预期 401）"
echo "POST $BASE_URL/api/projects"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/json" \
    -d '{"title":"测试项目","description":"这是一个测试项目"}' \
    "$BASE_URL/api/projects")
if [ "$HTTP_CODE" = "401" ]; then
    echo "✅ 正确返回 401 Unauthorized"
else
    echo "❌ 返回了 $HTTP_CODE，预期是 401"
fi
echo ""
echo ""

echo "=================================="
echo "✅ API 测试完成"
echo ""
echo "📝 注意事项："
echo "1. 认证端点正常工作（返回 401 表示需要登录）"
echo "2. 要测试完整功能，需要："
echo "   - 在 Supabase 中运行 supabase-setup.sql"
echo "   - 在浏览器中注册/登录账户"
echo "   - 使用浏览器测试完整的用户流程"
echo ""
echo "🌐 访问应用: $BASE_URL"
echo "🔐 登录页面: $BASE_URL/login"
echo "📊 项目看板: $BASE_URL/dashboard"
