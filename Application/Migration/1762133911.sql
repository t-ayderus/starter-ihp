ALTER TABLE votes RENAME COLUMN vote TO ballot;
DROP INDEX votes_post_id_index;
DROP INDEX votes_user_id_index;
CREATE INDEX ballots_user_id_index ON votes (user_id);
CREATE INDEX ballots_post_id_index ON votes (post_id);
