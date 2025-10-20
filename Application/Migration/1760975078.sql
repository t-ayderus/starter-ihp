ALTER TABLE reactions ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE reactions ADD COLUMN user_id UUID NOT NULL;
CREATE INDEX reactions_created_at_index ON reactions (created_at);
CREATE INDEX reactions_user_id_index ON reactions (user_id);
CREATE TABLE votes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    vote INT NOT NULL,
    user_id UUID NOT NULL
);
ALTER TABLE votes ADD CONSTRAINT votes_user_id_key UNIQUE(user_id);
CREATE INDEX votes_user_id_index ON votes (user_id);
ALTER TABLE reactions ADD CONSTRAINT reactions_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE votes ADD CONSTRAINT votes_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
