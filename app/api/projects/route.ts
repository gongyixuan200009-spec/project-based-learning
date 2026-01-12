import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase-server'

// GET /api/projects - List all projects for the current user
export async function GET(request: NextRequest) {
  try {
    const supabase = createClient()
    
    // Get current user
    const { data: { user }, error: authError } = await supabase.auth.getUser()
    if (authError || !user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    // Get projects where user is creator or member
    const { data: projects, error } = await supabase
      .from('projects')
      .select(`
        *,
        project_members!inner(role),
        learning_stages(stage_number, status)
      `)
      .or(`created_by.eq.${user.id},project_members.user_id.eq.${user.id}`)
      .order('created_at', { ascending: false })

    if (error) {
      console.error('Error fetching projects:', error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ projects })
  } catch (error: any) {
    console.error('Unexpected error:', error)
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}

// POST /api/projects - Create a new project
export async function POST(request: NextRequest) {
  try {
    const supabase = createClient()
    
    // Get current user
    const { data: { user }, error: authError } = await supabase.auth.getUser()
    if (authError || !user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { title, description, metadata } = body

    if (!title) {
      return NextResponse.json({ error: 'Title is required' }, { status: 400 })
    }

    // Create project
    const { data: project, error: projectError } = await supabase
      .from('projects')
      .insert({
        title,
        description,
        metadata: metadata || {},
        created_by: user.id,
        status: 'active',
        current_stage: 1
      })
      .select()
      .single()

    if (projectError) {
      console.error('Error creating project:', projectError)
      return NextResponse.json({ error: projectError.message }, { status: 500 })
    }

    // Initialize learning stages
    const { error: stagesError } = await supabase.rpc('initialize_project_stages', {
      p_project_id: project.id
    })

    if (stagesError) {
      console.error('Error initializing stages:', stagesError)
      // Don't fail the request, just log the error
    }

    // Add creator as owner in project_members
    const { error: memberError } = await supabase
      .from('project_members')
      .insert({
        project_id: project.id,
        user_id: user.id,
        role: 'owner'
      })

    if (memberError) {
      console.error('Error adding project member:', memberError)
    }

    return NextResponse.json({ project }, { status: 201 })
  } catch (error: any) {
    console.error('Unexpected error:', error)
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
