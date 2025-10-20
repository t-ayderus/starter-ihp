module Web.Controller.Votes where

import Web.Controller.Prelude
import Web.View.Votes.Index
import Web.View.Votes.New
import Web.View.Votes.Edit
import Web.View.Votes.Show

instance Controller VotesController where
    action VotesAction = do
        votes <- query @Vote |> fetch
        render IndexView { .. }

    action NewVoteAction { postId, userId } = do
        let vote = newRecord |> set #postId postId |> set #userId userId
        post <- fetch postId
        render NewView { .. }

    action ShowVoteAction { voteId } = do
        vote <- fetch voteId
        render ShowView { .. }

    action EditVoteAction { voteId } = do
        vote <- fetch voteId
        render EditView { .. }

    action UpdateVoteAction { voteId } = do
        vote <- fetch voteId
        vote
            |> buildVote
            |> ifValid \case
                Left vote -> render EditView { .. }
                Right vote -> do
                    vote <- vote |> updateRecord
                    setSuccessMessage "Vote updated"
                    redirectTo EditVoteAction { .. }

    action CreateVoteAction = do
        let vote = newRecord @Vote
        vote
            |> buildVote
            |> ifValid \case
                Left vote -> render NewView { .. } 
                Right vote -> do
                    vote <- vote |> createRecord
                    setSuccessMessage "Vote created"
                    redirectTo VotesAction

    action DeleteVoteAction { voteId } = do
        vote <- fetch voteId
        deleteRecord vote
        setSuccessMessage "Vote deleted"
        redirectTo VotesAction

buildVote vote = vote
    |> fill @'["vote", "userId"]
