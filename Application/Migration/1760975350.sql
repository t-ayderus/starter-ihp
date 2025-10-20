ALTER TABLE votes ADD COLUMN post_id UUID NOT NULL;
CREATE INDEX votes_post_id_index ON votes (post_id);
ALTER TABLE votes ADD CONSTRAINT votes_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
