console.log('========================================')
console.log('🚀 Starting PBL Learning Platform...')
console.log('========================================')
console.log('Environment Check:')
console.log('- NEXT_PUBLIC_SUPABASE_URL:', process.env.NEXT_PUBLIC_SUPABASE_URL ? '✅ Set' : '❌ Missing')
console.log('- NEXT_PUBLIC_SUPABASE_ANON_KEY:', process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ? '✅ Set' : '❌ Missing')
console.log('- OPENAI_API_KEY:', process.env.OPENAI_API_KEY ? '✅ Set' : '❌ Missing')
console.log('- NODE_ENV:', process.env.NODE_ENV)
console.log('- PORT:', process.env.PORT || '3000')
console.log('========================================')

// Start Next.js
require('child_process').spawn('npm', ['start'], {
  stdio: 'inherit',
  shell: true
})
