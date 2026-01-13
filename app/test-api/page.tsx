'use client'

import { useState } from 'react'

export default function TestAPIPage() {
  const [result, setResult] = useState<any>(null)
  const [loading, setLoading] = useState(false)

  const testHealth = async () => {
    setLoading(true)
    try {
      const res = await fetch('/api/health')
      const data = await res.json()
      setResult({ endpoint: '/api/health', data })
    } catch (error: any) {
      setResult({ error: error.message })
    }
    setLoading(false)
  }

  const testProjects = async () => {
    setLoading(true)
    try {
      const res = await fetch('/api/projects')
      const data = await res.json()
      setResult({ endpoint: '/api/projects', data })
    } catch (error: any) {
      setResult({ error: error.message })
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 p-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold mb-8 text-gray-900 dark:text-white">
          🔧 API 测试页面
        </h1>

        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4 text-gray-900 dark:text-white">
            测试新部署的 API 端点
          </h2>
          
          <div className="space-y-4">
            <button
              onClick={testHealth}
              disabled={loading}
              className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
            >
              测试 /api/health
            </button>

            <button
              onClick={testProjects}
              disabled={loading}
              className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 disabled:opacity-50 ml-4"
            >
              测试 /api/projects
            </button>
          </div>
        </div>

        {result && (
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h3 className="text-lg font-semibold mb-4 text-gray-900 dark:text-white">
              结果：
            </h3>
            <pre className="bg-gray-100 dark:bg-gray-900 p-4 rounded overflow-auto text-sm text-gray-900 dark:text-gray-100">
              {JSON.stringify(result, null, 2)}
            </pre>
          </div>
        )}

        <div className="mt-8 bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg p-6">
          <h3 className="text-lg font-semibold mb-2 text-yellow-900 dark:text-yellow-200">
            ⚠️ 当前部署状态
          </h3>
          <div className="space-y-3 text-yellow-800 dark:text-yellow-300">
            <div className="flex items-start">
              <span className="mr-2">✅</span>
              <span>后端 API 已部署成功</span>
            </div>
            <div className="flex items-start">
              <span className="mr-2">✅</span>
              <span>数据库架构已设计完成（在 supabase-setup.sql）</span>
            </div>
            <div className="flex items-start">
              <span className="mr-2">⚠️</span>
              <span>需要在 Supabase 中运行 SQL 文件来创建新表</span>
            </div>
            <div className="flex items-start">
              <span className="mr-2">❌</span>
              <span>前端界面还未构建（这就是为什么主页看起来没变化）</span>
            </div>
            <div className="flex items-start">
              <span className="mr-2">📋</span>
              <span>查看项目根目录的 REFACTORING_PROGRESS.md 了解完整进度</span>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-6">
          <h3 className="text-lg font-semibold mb-2 text-blue-900 dark:text-blue-200">
            📚 新架构包含的功能
          </h3>
          <ul className="list-disc list-inside space-y-2 text-blue-800 dark:text-blue-300">
            <li>6 阶段 PBL 学习工作流（需求分析、方案设计、实施开发、测试验证、部署上线、总结反思）</li>
            <li>多用户协作系统</li>
            <li>每个阶段的字段提取功能</li>
            <li>测试和评估系统</li>
            <li>进度跟踪和分析</li>
            <li>AI 交互日志</li>
          </ul>
        </div>
      </div>
    </div>
  )
}
