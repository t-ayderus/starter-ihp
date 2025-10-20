-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    user_id UUID NOT NULL
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
    comment_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    user_id UUID NOT NULL
);
CREATE INDEX reactions_comment_id_index ON reactions (comment_id);
CREATE INDEX reactions_created_at_index ON reactions (created_at);
CREATE INDEX reactions_user_id_index ON reactions (user_id);
CREATE TABLE votes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    vote INT NOT NULL,
    user_id UUID NOT NULL UNIQUE,
    post_id UUID NOT NULL
);
CREATE INDEX votes_user_id_index ON votes (user_id);
CREATE INDEX votes_post_id_index ON votes (post_id);
CREATE INDEX posts_user_id_index ON posts (user_id);
ALTER TABLE comments ADD CONSTRAINT comments_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;
ALTER TABLE posts ADD CONSTRAINT posts_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE CASCADE;
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE votes ADD CONSTRAINT votes_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;
ALTER TABLE votes ADD CONSTRAINT votes_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
