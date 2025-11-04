module Web.Controller.Votes where

import Web.Controller.Prelude
import Web.View.Votes.Index
import Web.View.Votes.New
import Web.View.Votes.Edit
import Web.View.Votes.Show
import Web.Controller.Posts

instance Controller VotesController where
    action VotesAction = do
        votes <- query @Vote |> fetch
        render IndexView { .. }

    action NewVoteAction { postId, userId} = do
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
        ensureIsUser
        let postId = param @(Id Post) "postId"
        let ballot = param @Int "ballot"
        let userId = currentUserId

        existing <- query @Vote
            |> filterWhere (#postId, postId)
            |> filterWhere (#userId, userId)
            |> fetchOneOrNothing

        case existing of
            Just val -> 
                if get #ballot val == ballot 
                    then do
                        deleteRecord val
                        setSuccessMessage "Reaction removed"
                        jumpToAction ShowPostAction { postId }
                    else do
                        _ <- val 
                            |> set #ballot ballot 
                            |> updateRecord
                        setSuccessMessage "Vote updated"
                        jumpToAction ShowPostAction { postId }
            Nothing -> do
                _ <- newRecord @Vote
                    |> set #postId postId
                    |> set #userId userId        
                    |> set #ballot  ballot
                    |> createRecord
                setSuccessMessage "Reaction added"
                jumpToAction ShowPostAction { postId }

       


    action DeleteVoteAction { voteId } = do
        vote <- fetch voteId
        deleteRecord vote
        setSuccessMessage "Vote deleted"
        redirectTo VotesAction

buildVote vote = vote
    |> fill @'["ballot", "userId", "postId"]
