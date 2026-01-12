-- PBL Learning Platform Database Schema
-- Comprehensive schema for multi-stage project-based learning system

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Projects table - Main project management
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'archived', 'paused')),
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    current_stage INTEGER DEFAULT 1 CHECK (current_stage >= 1 AND current_stage <= 6),
    start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    end_date TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Project members table - Multi-user collaboration
CREATE TABLE IF NOT EXISTS project_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'member' CHECK (role IN ('owner', 'admin', 'member', 'viewer')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(project_id, user_id)
);

-- Learning stages table - 6-stage workflow
CREATE TABLE IF NOT EXISTS learning_stages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    stage_number INTEGER NOT NULL CHECK (stage_number >= 1 AND stage_number <= 6),
    stage_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed', 'blocked')),
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    time_spent_minutes INTEGER DEFAULT 0,
    ai_guidance_used BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(project_id, stage_number)
);

-- ============================================================================
-- FIELD EXTRACTION TABLES (Stage-specific data)
-- ============================================================================

-- Stage 1: Requirements Analysis (需求分析)
CREATE TABLE IF NOT EXISTS stage1_requirements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    problem_description TEXT NOT NULL,
    target_users TEXT,
    core_features JSONB DEFAULT '[]',
    success_criteria TEXT,
    constraints TEXT,
    assumptions TEXT,
    extracted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    extracted_by UUID REFERENCES auth.users(id),
    version INTEGER DEFAULT 1,
    UNIQUE(project_id, version)
);

-- Stage 2: Solution Design (方案设计)
CREATE TABLE IF NOT EXISTS stage2_design (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    architecture_overview TEXT,
    tech_stack JSONB DEFAULT '{}',
    system_components JSONB DEFAULT '[]',
    data_model TEXT,
    api_design JSONB DEFAULT '[]',
    ui_mockups JSONB DEFAULT '[]',
    security_considerations TEXT,
    scalability_plan TEXT,
    extracted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    extracted_by UUID REFERENCES auth.users(id),
    version INTEGER DEFAULT 1,
    UNIQUE(project_id, version)
);

-- Stage 3: Implementation (实施开发)
CREATE TABLE IF NOT EXISTS stage3_implementation (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    code_repository_url TEXT,
    branch_name VARCHAR(255),
    commit_hash VARCHAR(255),
    files_changed JSONB DEFAULT '[]',
    lines_of_code INTEGER,
    implementation_notes TEXT,
    challenges_faced TEXT,
    solutions_applied TEXT,
    extracted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    extracted_by UUID REFERENCES auth.users(id),
    version INTEGER DEFAULT 1
);

-- Stage 4: Testing & Validation (测试验证)
CREATE TABLE IF NOT EXISTS stage4_testing (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    test_strategy TEXT,
    test_cases JSONB DEFAULT '[]',
    test_results JSONB DEFAULT '{}',
    bugs_found JSONB DEFAULT '[]',
    bugs_fixed JSONB DEFAULT '[]',
    code_coverage_percent DECIMAL(5,2),
    performance_metrics JSONB DEFAULT '{}',
    extracted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    extracted_by UUID REFERENCES auth.users(id),
    version INTEGER DEFAULT 1
);

-- Stage 5: Deployment (部署上线)
CREATE TABLE IF NOT EXISTS stage5_deployment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    deployment_environment VARCHAR(100),
    deployment_url TEXT,
    deployment_date TIMESTAMP WITH TIME ZONE,
    deployment_method VARCHAR(100),
    configuration JSONB DEFAULT '{}',
    monitoring_setup TEXT,
    rollback_plan TEXT,
    post_deployment_checks JSONB DEFAULT '[]',
    extracted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    extracted_by UUID REFERENCES auth.users(id),
    version INTEGER DEFAULT 1
);

-- Stage 6: Reflection & Summary (总结反思)
CREATE TABLE IF NOT EXISTS stage6_reflection (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    achievements TEXT,
    lessons_learned TEXT,
    what_went_well TEXT,
    what_could_improve TEXT,
    skills_gained JSONB DEFAULT '[]',
    future_improvements TEXT,
    overall_rating INTEGER CHECK (overall_rating >= 1 AND overall_rating <= 5),
    would_recommend BOOLEAN,
    extracted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    extracted_by UUID REFERENCES auth.users(id),
    version INTEGER DEFAULT 1,
    UNIQUE(project_id, version)
);

-- ============================================================================
-- TESTING & EVALUATION SYSTEM
-- ============================================================================

-- Test questions for each stage
CREATE TABLE IF NOT EXISTS test_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    stage_number INTEGER NOT NULL CHECK (stage_number >= 1 AND stage_number <= 6),
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) CHECK (question_type IN ('multiple_choice', 'true_false', 'short_answer', 'essay')),
    options JSONB DEFAULT '[]',
    correct_answer TEXT,
    explanation TEXT,
    difficulty VARCHAR(50) CHECK (difficulty IN ('easy', 'medium', 'hard')),
    points INTEGER DEFAULT 10,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    is_active BOOLEAN DEFAULT TRUE
);

-- Test attempts and results
CREATE TABLE IF NOT EXISTS test_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    stage_number INTEGER NOT NULL CHECK (stage_number >= 1 AND stage_number <= 6),
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    total_questions INTEGER,
    correct_answers INTEGER,
    score DECIMAL(5,2),
    passed BOOLEAN,
    time_spent_seconds INTEGER,
    attempt_number INTEGER DEFAULT 1
);

-- Individual question answers
CREATE TABLE IF NOT EXISTS test_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    attempt_id UUID NOT NULL REFERENCES test_attempts(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES test_questions(id) ON DELETE CASCADE,
    user_answer TEXT,
    is_correct BOOLEAN,
    points_earned INTEGER,
    ai_feedback TEXT,
    answered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- PROGRESS TRACKING & ANALYTICS
-- ============================================================================

-- User progress tracking
CREATE TABLE IF NOT EXISTS user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    stage_number INTEGER NOT NULL CHECK (stage_number >= 1 AND stage_number <= 6),
    progress_percent DECIMAL(5,2) DEFAULT 0,
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_time_spent_minutes INTEGER DEFAULT 0,
    milestones_completed JSONB DEFAULT '[]',
    UNIQUE(user_id, project_id, stage_number)
);

-- Activity logs for audit trail
CREATE TABLE IF NOT EXISTS activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    action_type VARCHAR(100) NOT NULL,
    action_details JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- AI interactions log
CREATE TABLE IF NOT EXISTS ai_interactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    stage_number INTEGER CHECK (stage_number >= 1 AND stage_number <= 6),
    interaction_type VARCHAR(100),
    prompt TEXT,
    response TEXT,
    model_used VARCHAR(100),
    tokens_used INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- COLLABORATION & NOTIFICATIONS
-- ============================================================================

-- Project comments and discussions
CREATE TABLE IF NOT EXISTS project_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    stage_number INTEGER CHECK (stage_number >= 1 AND stage_number <= 6),
    parent_comment_id UUID REFERENCES project_comments(id) ON DELETE CASCADE,
    comment_text TEXT NOT NULL,
    mentions JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Notifications system
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    notification_type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    related_project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    related_entity_id UUID,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX idx_projects_created_by ON projects(created_by);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_current_stage ON projects(current_stage);
CREATE INDEX idx_project_members_project_id ON project_members(project_id);
CREATE INDEX idx_project_members_user_id ON project_members(user_id);
CREATE INDEX idx_learning_stages_project_id ON learning_stages(project_id);
CREATE INDEX idx_learning_stages_status ON learning_stages(status);
CREATE INDEX idx_test_questions_stage_number ON test_questions(stage_number);
CREATE INDEX idx_test_attempts_project_id ON test_attempts(project_id);
CREATE INDEX idx_test_attempts_user_id ON test_attempts(user_id);
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_user_progress_project_id ON user_progress(project_id);
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_project_id ON activity_logs(project_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);
CREATE INDEX idx_ai_interactions_user_id ON ai_interactions(user_id);
CREATE INDEX idx_ai_interactions_project_id ON ai_interactions(project_id);
CREATE INDEX idx_project_comments_project_id ON project_comments(project_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- ============================================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_learning_stages_updated_at BEFORE UPDATE ON learning_stages
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_project_comments_updated_at BEFORE UPDATE ON project_comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to log activity
CREATE OR REPLACE FUNCTION log_project_activity()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO activity_logs (user_id, project_id, action_type, action_details)
    VALUES (
        COALESCE(NEW.created_by, NEW.user_id, auth.uid()),
        NEW.id,
        TG_OP,
        jsonb_build_object('table', TG_TABLE_NAME, 'timestamp', NOW())
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply activity logging to projects table
CREATE TRIGGER log_project_insert AFTER INSERT ON projects
    FOR EACH ROW EXECUTE FUNCTION log_project_activity();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE stage1_requirements ENABLE ROW LEVEL SECURITY;
ALTER TABLE stage2_design ENABLE ROW LEVEL SECURITY;
ALTER TABLE stage3_implementation ENABLE ROW LEVEL SECURITY;
ALTER TABLE stage4_testing ENABLE ROW LEVEL SECURITY;
ALTER TABLE stage5_deployment ENABLE ROW LEVEL SECURITY;
ALTER TABLE stage6_reflection ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_interactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Projects policies
CREATE POLICY "Users can view projects they are members of"
    ON projects FOR SELECT
    USING (
        created_by = auth.uid() OR
        id IN (SELECT project_id FROM project_members WHERE user_id = auth.uid())
    );

CREATE POLICY "Users can create their own projects"
    ON projects FOR INSERT
    WITH CHECK (created_by = auth.uid());

CREATE POLICY "Project owners and admins can update projects"
    ON projects FOR UPDATE
    USING (
        created_by = auth.uid() OR
        id IN (SELECT project_id FROM project_members WHERE user_id = auth.uid() AND role IN ('owner', 'admin'))
    );

CREATE POLICY "Project owners can delete projects"
    ON projects FOR DELETE
    USING (created_by = auth.uid());

-- Project members policies
CREATE POLICY "Users can view project members of their projects"
    ON project_members FOR SELECT
    USING (
        project_id IN (
            SELECT id FROM projects WHERE created_by = auth.uid()
            UNION
            SELECT project_id FROM project_members WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Project owners and admins can manage members"
    ON project_members FOR ALL
    USING (
        project_id IN (
            SELECT id FROM projects WHERE created_by = auth.uid()
            UNION
            SELECT project_id FROM project_members WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- Learning stages policies
CREATE POLICY "Users can view stages of their projects"
    ON learning_stages FOR SELECT
    USING (
        project_id IN (
            SELECT id FROM projects WHERE created_by = auth.uid()
            UNION
            SELECT project_id FROM project_members WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Project members can update stages"
    ON learning_stages FOR ALL
    USING (
        project_id IN (
            SELECT id FROM projects WHERE created_by = auth.uid()
            UNION
            SELECT project_id FROM project_members WHERE user_id = auth.uid()
        )
    );

-- Stage data policies (apply same pattern to all stage tables)
CREATE POLICY "Users can view stage1 data" ON stage1_requirements FOR SELECT
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));
CREATE POLICY "Users can manage stage1 data" ON stage1_requirements FOR ALL
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));

CREATE POLICY "Users can view stage2 data" ON stage2_design FOR SELECT
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));
CREATE POLICY "Users can manage stage2 data" ON stage2_design FOR ALL
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));

CREATE POLICY "Users can view stage3 data" ON stage3_implementation FOR SELECT
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));
CREATE POLICY "Users can manage stage3 data" ON stage3_implementation FOR ALL
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));

CREATE POLICY "Users can view stage4 data" ON stage4_testing FOR SELECT
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));
CREATE POLICY "Users can manage stage4 data" ON stage4_testing FOR ALL
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));

CREATE POLICY "Users can view stage5 data" ON stage5_deployment FOR SELECT
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));
CREATE POLICY "Users can manage stage5 data" ON stage5_deployment FOR ALL
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));

CREATE POLICY "Users can view stage6 data" ON stage6_reflection FOR SELECT
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));
CREATE POLICY "Users can manage stage6 data" ON stage6_reflection FOR ALL
    USING (project_id IN (SELECT id FROM projects WHERE created_by = auth.uid() UNION SELECT project_id FROM project_members WHERE user_id = auth.uid()));

-- Test questions policies (public read, admin write)
CREATE POLICY "Anyone can view active test questions"
    ON test_questions FOR SELECT
    USING (is_active = TRUE);

-- Test attempts policies
CREATE POLICY "Users can view their own test attempts"
    ON test_attempts FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "Users can create their own test attempts"
    ON test_attempts FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own test attempts"
    ON test_attempts FOR UPDATE
    USING (user_id = auth.uid());

-- Test answers policies
CREATE POLICY "Users can view their own test answers"
    ON test_answers FOR SELECT
    USING (attempt_id IN (SELECT id FROM test_attempts WHERE user_id = auth.uid()));

CREATE POLICY "Users can create their own test answers"
    ON test_answers FOR INSERT
    WITH CHECK (attempt_id IN (SELECT id FROM test_attempts WHERE user_id = auth.uid()));

-- User progress policies
CREATE POLICY "Users can view their own progress"
    ON user_progress FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "Users can manage their own progress"
    ON user_progress FOR ALL
    USING (user_id = auth.uid());

-- Activity logs policies
CREATE POLICY "Users can view their own activity logs"
    ON activity_logs FOR SELECT
    USING (user_id = auth.uid());

-- AI interactions policies
CREATE POLICY "Users can view their own AI interactions"
    ON ai_interactions FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "Users can create their own AI interactions"
    ON ai_interactions FOR INSERT
    WITH CHECK (user_id = auth.uid());

-- Project comments policies
CREATE POLICY "Users can view comments on their projects"
    ON project_comments FOR SELECT
    USING (
        project_id IN (
            SELECT id FROM projects WHERE created_by = auth.uid()
            UNION
            SELECT project_id FROM project_members WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create comments on their projects"
    ON project_comments FOR INSERT
    WITH CHECK (
        user_id = auth.uid() AND
        project_id IN (
            SELECT id FROM projects WHERE created_by = auth.uid()
            UNION
            SELECT project_id FROM project_members WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update their own comments"
    ON project_comments FOR UPDATE
    USING (user_id = auth.uid());

CREATE POLICY "Users can delete their own comments"
    ON project_comments FOR DELETE
    USING (user_id = auth.uid());

-- Notifications policies
CREATE POLICY "Users can view their own notifications"
    ON notifications FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "Users can update their own notifications"
    ON notifications FOR UPDATE
    USING (user_id = auth.uid());

-- ============================================================================
-- FUNCTIONS FOR COMMON OPERATIONS
-- ============================================================================

-- Function to initialize learning stages for a new project
CREATE OR REPLACE FUNCTION initialize_project_stages(p_project_id UUID)
RETURNS VOID AS $$
BEGIN
    INSERT INTO learning_stages (project_id, stage_number, stage_name, status)
    VALUES
        (p_project_id, 1, '需求分析', 'not_started'),
        (p_project_id, 2, '方案设计', 'not_started'),
        (p_project_id, 3, '实施开发', 'not_started'),
        (p_project_id, 4, '测试验证', 'not_started'),
        (p_project_id, 5, '部署上线', 'not_started'),
        (p_project_id, 6, '总结反思', 'not_started');
END;
$$ LANGUAGE plpgsql;

-- Function to calculate project completion percentage
CREATE OR REPLACE FUNCTION calculate_project_completion(p_project_id UUID)
RETURNS DECIMAL AS $$
DECLARE
    completed_stages INTEGER;
    total_stages INTEGER := 6;
BEGIN
    SELECT COUNT(*) INTO completed_stages
    FROM learning_stages
    WHERE project_id = p_project_id AND status = 'completed';

    RETURN (completed_stages::DECIMAL / total_stages) * 100;
END;
$$ LANGUAGE plpgsql;

-- Function to get user's project statistics
CREATE OR REPLACE FUNCTION get_user_statistics(p_user_id UUID)
RETURNS TABLE (
    total_projects INTEGER,
    active_projects INTEGER,
    completed_projects INTEGER,
    total_time_spent_hours DECIMAL,
    average_test_score DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(DISTINCT p.id)::INTEGER as total_projects,
        COUNT(DISTINCT CASE WHEN p.status = 'active' THEN p.id END)::INTEGER as active_projects,
        COUNT(DISTINCT CASE WHEN p.status = 'completed' THEN p.id END)::INTEGER as completed_projects,
        COALESCE(SUM(up.total_time_spent_minutes) / 60.0, 0) as total_time_spent_hours,
        COALESCE(AVG(ta.score), 0) as average_test_score
    FROM projects p
    LEFT JOIN project_members pm ON p.id = pm.project_id
    LEFT JOIN user_progress up ON p.id = up.project_id AND up.user_id = p_user_id
    LEFT JOIN test_attempts ta ON p.id = ta.project_id AND ta.user_id = p_user_id
    WHERE p.created_by = p_user_id OR pm.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- INITIAL DATA SEEDING
-- ============================================================================

-- Insert default test questions for each stage
INSERT INTO test_questions (stage_number, question_text, question_type, options, correct_answer, explanation, difficulty, points) VALUES
(1, '需求分析阶段最重要的输出是什么？', 'multiple_choice',
 '["需求文档", "代码实现", "测试用例", "部署方案"]'::jsonb,
 '需求文档',
 '需求分析阶段的核心输出是清晰、完整的需求文档，它是后续所有工作的基础。',
 'easy', 10),

(2, '系统设计时需要考虑哪些方面？', 'multiple_choice',
 '["架构设计", "技术选型", "数据模型", "以上都是"]'::jsonb,
 '以上都是',
 '系统设计是一个综合性的工作，需要考虑架构、技术栈、数据模型等多个方面。',
 'medium', 15),

(3, '代码实现时应该遵循什么原则？', 'multiple_choice',
 '["快速完成", "代码质量", "可维护性", "后两者都重要"]'::jsonb,
 '后两者都重要',
 '代码质量和可维护性是长期项目成功的关键，不应该为了速度而牺牲质量。',
 'medium', 15),

(4, '测试的主要目的是什么？', 'multiple_choice',
 '["发现bug", "验证功能", "保证质量", "以上都是"]'::jsonb,
 '以上都是',
 '测试是一个综合性的质量保证过程，包括发现问题、验证功能和确保整体质量。',
 'easy', 10),

(5, '部署前需要做哪些准备？', 'multiple_choice',
 '["环境配置", "数据备份", "回滚方案", "以上都是"]'::jsonb,
 '以上都是',
 '部署是一个风险较高的操作，需要做好充分的准备工作以确保顺利进行。',
 'medium', 15),

(6, '项目总结的价值在于？', 'multiple_choice',
 '["完成任务", "经验积累", "持续改进", "后两者都重要"]'::jsonb,
 '后两者都重要',
 '项目总结不仅是为了完成任务，更重要的是积累经验和为未来的改进提供依据。',
 'easy', 10);

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON TABLE projects IS 'Main projects table for PBL learning platform';
COMMENT ON TABLE learning_stages IS '6-stage learning workflow tracking';
COMMENT ON TABLE stage1_requirements IS 'Requirements analysis data extraction';
COMMENT ON TABLE stage2_design IS 'Solution design data extraction';
COMMENT ON TABLE stage3_implementation IS 'Implementation phase data';
COMMENT ON TABLE stage4_testing IS 'Testing and validation data';
COMMENT ON TABLE stage5_deployment IS 'Deployment information';
COMMENT ON TABLE stage6_reflection IS 'Project reflection and summary';
COMMENT ON TABLE test_questions IS 'Test questions for each learning stage';
COMMENT ON TABLE test_attempts IS 'User test attempts and scores';
COMMENT ON TABLE user_progress IS 'User progress tracking across stages';
COMMENT ON TABLE activity_logs IS 'Audit trail for all user actions';
COMMENT ON TABLE ai_interactions IS 'Log of AI assistant interactions';
