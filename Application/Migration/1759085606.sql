ALTER TABLE users ALTER COLUMN locked_at SET DEFAULT null;
CREATE TABLE reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    emoji TEXT NOT NULL,
    post_id UUID DEFAULT uuid_generate_v4() NOT NULL,
    comment_id UUID NOT NULL
);
CREATE INDEX reactions_comment_id_index ON reactions (comment_id);
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE CASCADE;
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;
