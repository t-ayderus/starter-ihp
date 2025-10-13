-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE TABLE comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    post_id UUID NOT NULL,
    author TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE INDEX comments_post_id_index ON comments (post_id);
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
CREATE TABLE reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    emoji TEXT NOT NULL,
    post_id UUID DEFAULT uuid_generate_v4() NOT NULL,
    comment_id UUID NOT NULL
);
CREATE INDEX reactions_comment_id_index ON reactions (comment_id);
ALTER TABLE comments ADD CONSTRAINT comments_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE CASCADE;
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;
