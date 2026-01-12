export type Project = {
  id: string
  title: string
  description: string | null
  status: 'active' | 'completed' | 'archived' | 'paused'
  created_by: string
  current_stage: number
  start_date: string
  end_date: string | null
  metadata: Record<string, any>
  created_at: string
  updated_at: string
}

export type ProjectMember = {
  id: string
  project_id: string
  user_id: string
  role: 'owner' | 'admin' | 'member' | 'viewer'
  joined_at: string
}

export type LearningStage = {
  id: string
  project_id: string
  stage_number: number
  stage_name: string
  status: 'not_started' | 'in_progress' | 'completed' | 'blocked'
  started_at: string | null
  completed_at: string | null
  time_spent_minutes: number
  ai_guidance_used: boolean
  notes: string | null
  created_at: string
  updated_at: string
}

export type TestQuestion = {
  id: string
  stage_number: number
  question_text: string
  question_type: 'multiple_choice' | 'true_false' | 'short_answer' | 'essay'
  options: any[]
  correct_answer: string | null
  explanation: string | null
  difficulty: 'easy' | 'medium' | 'hard'
  points: number
  created_at: string
  created_by: string | null
  is_active: boolean
}

export type TestAttempt = {
  id: string
  project_id: string
  user_id: string
  stage_number: number
  started_at: string
  completed_at: string | null
  total_questions: number | null
  correct_answers: number | null
  score: number | null
  passed: boolean | null
  time_spent_seconds: number | null
  attempt_number: number
}

export type UserProgress = {
  id: string
  user_id: string
  project_id: string
  stage_number: number
  progress_percent: number
  last_activity_at: string
  total_time_spent_minutes: number
  milestones_completed: any[]
}
