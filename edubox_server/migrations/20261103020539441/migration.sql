BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_chats" (
    "id" bigserial PRIMARY KEY,
    "studentId" bigint NOT NULL,
    "subject" text NOT NULL,
    "classId" bigint,
    "title" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "ai_chats_student_idx" ON "ai_chats" USING btree ("studentId", "updatedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_messages" (
    "id" bigserial PRIMARY KEY,
    "chatId" bigint NOT NULL,
    "role" text NOT NULL,
    "content" text NOT NULL,
    "position" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "ai_messages_chat_position_idx" ON "ai_messages" USING btree ("chatId", "position");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_usage" (
    "id" bigserial PRIMARY KEY,
    "studentId" bigint NOT NULL,
    "day" text NOT NULL,
    "messageCount" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "ai_usage_student_day_idx" ON "ai_usage" USING btree ("studentId", "day");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "assignments" (
    "id" bigserial PRIMARY KEY,
    "classId" bigint NOT NULL,
    "teacherId" bigint NOT NULL,
    "exerciseId" bigint NOT NULL,
    "type" text NOT NULL,
    "title" text NOT NULL,
    "dueAt" timestamp without time zone,
    "timeLimitSec" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "assignments_class_idx" ON "assignments" USING btree ("classId");
CREATE INDEX "assignments_teacher_idx" ON "assignments" USING btree ("teacherId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "content" ADD COLUMN "originalFileName" text;
ALTER TABLE "content" ADD COLUMN "mimeType" text;
ALTER TABLE "content" ADD COLUMN "sizeBytes" bigint;
ALTER TABLE "content" ADD COLUMN "pageCount" bigint;
ALTER TABLE "content" ADD COLUMN "durationSeconds" bigint;
ALTER TABLE "content" ADD COLUMN "ingestStatus" text;
ALTER TABLE "content" ADD COLUMN "ingestReason" text;
CREATE INDEX "content_owner_idx" ON "content" USING btree ("ownerTeacherId");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "exercise_answer_keys" (
    "id" bigserial PRIMARY KEY,
    "questionId" bigint NOT NULL,
    "correctPosition" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "exercise_answer_keys_question_position_idx" ON "exercise_answer_keys" USING btree ("questionId", "correctPosition");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "exercise_options" (
    "id" bigserial PRIMARY KEY,
    "questionId" bigint NOT NULL,
    "position" bigint NOT NULL,
    "text" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "exercise_options_question_position_idx" ON "exercise_options" USING btree ("questionId", "position");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "exercise_questions" (
    "id" bigserial PRIMARY KEY,
    "exerciseId" bigint NOT NULL,
    "position" bigint NOT NULL,
    "stem" text NOT NULL,
    "multiSelect" boolean NOT NULL,
    "imagePath" text
);

-- Indexes
CREATE UNIQUE INDEX "exercise_questions_exercise_position_idx" ON "exercise_questions" USING btree ("exerciseId", "position");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "exercises" (
    "id" bigserial PRIMARY KEY,
    "contentId" bigint NOT NULL,
    "ownerTeacherId" bigint NOT NULL,
    "lessonContentId" bigint,
    "answerKeyVersion" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "exercises_content_idx" ON "exercises" USING btree ("contentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "progress" (
    "id" bigserial PRIMARY KEY,
    "studentId" bigint NOT NULL,
    "contentId" bigint NOT NULL,
    "status" text NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "progress_student_content_idx" ON "progress" USING btree ("studentId", "contentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "submissions" (
    "id" bigserial PRIMARY KEY,
    "assignmentId" bigint NOT NULL,
    "studentId" bigint NOT NULL,
    "clientSubmissionId" text NOT NULL,
    "status" text NOT NULL,
    "answersJson" text NOT NULL,
    "answerKeySnapshotJson" text,
    "answerKeyVersion" bigint NOT NULL,
    "score" double precision,
    "maxScore" double precision,
    "late" boolean NOT NULL,
    "startedAt" timestamp without time zone,
    "submittedAt" timestamp without time zone,
    "gradedAt" timestamp without time zone,
    "gradedBy" text,
    "failureReason" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "submissions_client_id_idx" ON "submissions" USING btree ("clientSubmissionId");
CREATE INDEX "submissions_assignment_student_idx" ON "submissions" USING btree ("assignmentId", "studentId");
CREATE INDEX "submissions_student_status_idx" ON "submissions" USING btree ("studentId", "status");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_chats"
    ADD CONSTRAINT "ai_chats_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_chats"
    ADD CONSTRAINT "ai_chats_fk_1"
    FOREIGN KEY("classId")
    REFERENCES "classes"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_messages"
    ADD CONSTRAINT "ai_messages_fk_0"
    FOREIGN KEY("chatId")
    REFERENCES "ai_chats"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_usage"
    ADD CONSTRAINT "ai_usage_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "assignments"
    ADD CONSTRAINT "assignments_fk_0"
    FOREIGN KEY("classId")
    REFERENCES "classes"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "assignments"
    ADD CONSTRAINT "assignments_fk_1"
    FOREIGN KEY("teacherId")
    REFERENCES "users"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "assignments"
    ADD CONSTRAINT "assignments_fk_2"
    FOREIGN KEY("exerciseId")
    REFERENCES "exercises"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "exercise_answer_keys"
    ADD CONSTRAINT "exercise_answer_keys_fk_0"
    FOREIGN KEY("questionId")
    REFERENCES "exercise_questions"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "exercise_options"
    ADD CONSTRAINT "exercise_options_fk_0"
    FOREIGN KEY("questionId")
    REFERENCES "exercise_questions"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "exercise_questions"
    ADD CONSTRAINT "exercise_questions_fk_0"
    FOREIGN KEY("exerciseId")
    REFERENCES "exercises"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "exercises"
    ADD CONSTRAINT "exercises_fk_0"
    FOREIGN KEY("contentId")
    REFERENCES "content"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "exercises"
    ADD CONSTRAINT "exercises_fk_1"
    FOREIGN KEY("ownerTeacherId")
    REFERENCES "users"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "exercises"
    ADD CONSTRAINT "exercises_fk_2"
    FOREIGN KEY("lessonContentId")
    REFERENCES "content"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "progress"
    ADD CONSTRAINT "progress_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "progress"
    ADD CONSTRAINT "progress_fk_1"
    FOREIGN KEY("contentId")
    REFERENCES "content"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "submissions"
    ADD CONSTRAINT "submissions_fk_0"
    FOREIGN KEY("assignmentId")
    REFERENCES "assignments"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "submissions"
    ADD CONSTRAINT "submissions_fk_1"
    FOREIGN KEY("studentId")
    REFERENCES "users"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR edubox
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('edubox', '20261103020539441', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261103020539441', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
