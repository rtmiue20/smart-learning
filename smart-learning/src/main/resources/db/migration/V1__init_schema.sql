-- =============================================
-- SMART LEARNING AI TUTOR - DATABASE SCHEMA
-- V1__init_schema.sql
-- =============================================

-- ---------------------------------------------
-- 1. USERS
-- ---------------------------------------------
CREATE TABLE users (
                       id          BIGINT          NOT NULL AUTO_INCREMENT,
                       email       VARCHAR(255)    NOT NULL,
                       password    VARCHAR(255)    NOT NULL,
                       full_name   VARCHAR(255)    NOT NULL,
                       role        VARCHAR(50)     NOT NULL,   -- STUDENT, TEACHER, PARENT, ADMIN
                       active      BOOLEAN         NOT NULL DEFAULT TRUE,
                       created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                       CONSTRAINT pk_users       PRIMARY KEY (id),
                       CONSTRAINT uq_users_email UNIQUE (email)
);

CREATE TABLE student_profiles (
                                  user_id     BIGINT          NOT NULL,
                                  grade       INT,
                                  parent_id   BIGINT,

                                  CONSTRAINT pk_student_profiles PRIMARY KEY (user_id),
                                  CONSTRAINT fk_student_user     FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE teacher_profiles (
                                  user_id     BIGINT          NOT NULL,
                                  bio         TEXT,

                                  CONSTRAINT pk_teacher_profiles PRIMARY KEY (user_id),
                                  CONSTRAINT fk_teacher_user     FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE parent_profiles (
                                 user_id     BIGINT          NOT NULL,

                                 CONSTRAINT pk_parent_profiles  PRIMARY KEY (user_id),
                                 CONSTRAINT fk_parent_user      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE admin_profiles (
                                user_id     BIGINT          NOT NULL,

                                CONSTRAINT pk_admin_profiles   PRIMARY KEY (user_id),
                                CONSTRAINT fk_admin_user       FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Note: student_profiles.parent_id already handles relationship, but let's keep it consistent
ALTER TABLE student_profiles ADD CONSTRAINT fk_student_parent FOREIGN KEY (parent_id) REFERENCES users(id);

-- ---------------------------------------------
-- 2. COURSE (Subject → Chapter → Lesson)
-- ---------------------------------------------
CREATE TABLE subjects (
                          id          BIGINT          NOT NULL AUTO_INCREMENT,
                          name        VARCHAR(255)    NOT NULL,
                          grade       INT             NOT NULL,   -- 10, 11, 12
                          description TEXT,
                          created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

                          CONSTRAINT pk_subjects PRIMARY KEY (id)
);

CREATE TABLE chapters (
                          id          BIGINT          NOT NULL AUTO_INCREMENT,
                          subject_id  BIGINT          NOT NULL,
                          title       VARCHAR(255)    NOT NULL,
                          order_index INT             NOT NULL DEFAULT 0,

                          CONSTRAINT pk_chapters          PRIMARY KEY (id),
                          CONSTRAINT fk_chapters_subject  FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

CREATE TABLE lessons (
                         id          BIGINT          NOT NULL AUTO_INCREMENT,
                         chapter_id  BIGINT          NOT NULL,
                         title       VARCHAR(255)    NOT NULL,
                         content     LONGTEXT,
                         order_index INT             NOT NULL DEFAULT 0,
                         created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

                         CONSTRAINT pk_lessons           PRIMARY KEY (id),
                         CONSTRAINT fk_lessons_chapter   FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- 3. DOCUMENTS (RAG)
-- ---------------------------------------------
CREATE TABLE documents (
                           id          BIGINT          NOT NULL AUTO_INCREMENT,
                           subject_id  BIGINT          NOT NULL,
                           title       VARCHAR(255)    NOT NULL,
                           file_path   VARCHAR(500)    NOT NULL,
                           file_size   BIGINT,
                           status      VARCHAR(50)     NOT NULL DEFAULT 'PENDING',  -- PENDING, PROCESSING, DONE, FAILED
                           uploaded_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

                           CONSTRAINT pk_documents         PRIMARY KEY (id),
                           CONSTRAINT fk_docs_subject      FOREIGN KEY (subject_id)  REFERENCES subjects(id)
);

CREATE TABLE embedding_chunks (
                                  id          BIGINT          NOT NULL AUTO_INCREMENT,
                                  document_id BIGINT          NOT NULL,
                                  chunk_index INT             NOT NULL,
                                  content     TEXT            NOT NULL,
                                  vector_id   VARCHAR(255),               -- ID lưu trong Vector DB (Qdrant)
                                  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

                                  CONSTRAINT pk_embedding_chunks      PRIMARY KEY (id),
                                  CONSTRAINT fk_chunks_document       FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- 4. QUIZ
-- ---------------------------------------------
CREATE TABLE quizzes (
                         id          BIGINT          NOT NULL AUTO_INCREMENT,
                         lesson_id   BIGINT          NOT NULL,
                         title       VARCHAR(255)    NOT NULL,
                         created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

                         CONSTRAINT pk_quizzes           PRIMARY KEY (id),
                         CONSTRAINT fk_quizzes_lesson    FOREIGN KEY (lesson_id)  REFERENCES lessons(id) ON DELETE CASCADE
);

CREATE TABLE questions (
                           id              BIGINT          NOT NULL AUTO_INCREMENT,
                           quiz_id         BIGINT          NOT NULL,
                           content         TEXT            NOT NULL,
                           correct_answer  VARCHAR(10)     NOT NULL,   -- A, B, C, D
                           explanation     TEXT,
                           order_index     INT             NOT NULL DEFAULT 0,

                           CONSTRAINT pk_questions         PRIMARY KEY (id),
                           CONSTRAINT fk_questions_quiz    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

CREATE TABLE answers (
                         id          BIGINT      NOT NULL AUTO_INCREMENT,
                         question_id BIGINT      NOT NULL,
                         option_key  VARCHAR(10) NOT NULL,   -- A, B, C, D
                         content     TEXT        NOT NULL,

                         CONSTRAINT pk_answers           PRIMARY KEY (id),
                         CONSTRAINT fk_answers_question  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE submissions (
                             id          BIGINT          NOT NULL AUTO_INCREMENT,
                             quiz_id     BIGINT          NOT NULL,
                             student_id  BIGINT          NOT NULL,
                             score       DECIMAL(5,2),
                             submitted_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

                             CONSTRAINT pk_submissions           PRIMARY KEY (id),
                             CONSTRAINT fk_submissions_quiz      FOREIGN KEY (quiz_id)     REFERENCES quizzes(id),
                             CONSTRAINT fk_submissions_student   FOREIGN KEY (student_id)  REFERENCES users(id)
);

CREATE TABLE submission_answers (
                                    id              BIGINT      NOT NULL AUTO_INCREMENT,
                                    submission_id   BIGINT      NOT NULL,
                                    question_id     BIGINT      NOT NULL,
                                    selected_answer VARCHAR(10) NOT NULL,   -- A, B, C, D
                                    is_correct      BOOLEAN     NOT NULL DEFAULT FALSE,

                                    CONSTRAINT pk_submission_answers            PRIMARY KEY (id),
                                    CONSTRAINT fk_sub_answers_submission        FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
                                    CONSTRAINT fk_sub_answers_question          FOREIGN KEY (question_id)   REFERENCES questions(id)
);

-- ---------------------------------------------
-- 5. LEARNING PROGRESS
-- ---------------------------------------------
CREATE TABLE learning_progress (
                                   id              BIGINT          NOT NULL AUTO_INCREMENT,
                                   student_id      BIGINT          NOT NULL,
                                   lesson_id       BIGINT          NOT NULL,
                                   status          VARCHAR(50)     NOT NULL DEFAULT 'NOT_STARTED', -- NOT_STARTED, IN_PROGRESS, COMPLETED
                                   completion_percent INT          NOT NULL DEFAULT 0,
                                   last_accessed_at DATETIME,

                                   CONSTRAINT pk_learning_progress         PRIMARY KEY (id),
                                   CONSTRAINT uq_progress_student_lesson   UNIQUE (student_id, lesson_id),
                                   CONSTRAINT fk_progress_student          FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
                                   CONSTRAINT fk_progress_lesson           FOREIGN KEY (lesson_id)  REFERENCES lessons(id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- 6. AI CHAT SESSION
-- ---------------------------------------------
CREATE TABLE chat_sessions (
                               id          BIGINT          NOT NULL AUTO_INCREMENT,
                               student_id  BIGINT          NOT NULL,
                               lesson_id   BIGINT,                     -- nullable: chat chung hoặc theo bài
                               title       VARCHAR(255)    NOT NULL,
                               created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

                               CONSTRAINT pk_chat_sessions         PRIMARY KEY (id),
                               CONSTRAINT fk_sessions_student      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
                               CONSTRAINT fk_sessions_lesson       FOREIGN KEY (lesson_id)  REFERENCES lessons(id)
);

CREATE TABLE chat_messages (
                               id          BIGINT          NOT NULL AUTO_INCREMENT,
                               session_id  BIGINT          NOT NULL,
                               role        VARCHAR(20)     NOT NULL,   -- USER, ASSISTANT
                               content     TEXT            NOT NULL,
                               created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

                               CONSTRAINT pk_chat_messages         PRIMARY KEY (id),
                               CONSTRAINT fk_messages_session      FOREIGN KEY (session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE
);