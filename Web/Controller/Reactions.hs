module Web.Controller.Reactions where

import Web.Controller.Prelude
import Web.View.Reactions.Index
import Web.View.Reactions.New
import Web.View.Reactions.Edit
import Web.View.Reactions.Show

instance Controller ReactionsController where
    action ReactionsAction = do
        reactions <- query @Reaction |> fetch
        render IndexView { .. }

    action NewReactionAction { postId } = do
        post <- fetch postId
        let reaction = newRecord |> set #postId postId
        render NewView { .. }

    action ShowReactionAction { reactionId } = do
        reaction <- fetch reactionId
        render ShowView { .. }

    action EditReactionAction { reactionId } = do
        reaction <- fetch reactionId
        render EditView { .. }

    action UpdateReactionAction { reactionId } = do
        reaction <- fetch reactionId
        reaction
            |> buildReaction
            |> ifValid \case
                Left reaction -> render EditView { .. }
                Right reaction -> do
                    reaction <- reaction |> updateRecord
                    setSuccessMessage "Reaction updated"
                    redirectTo EditReactionAction { .. }

    action CreateReactionAction = do
        let reaction = newRecord @Reaction
        reaction
            |> buildReaction
            |> ifValid \case
                Left reaction -> do
                    post <- fetch reaction.postId
                    render NewView { .. } 
                Right reaction -> do
                    reaction <- reaction |> createRecord
                    setSuccessMessage "Reaction created"
                    redirectTo ReactionsAction

    action DeleteReactionAction { reactionId } = do
        reaction <- fetch reactionId
        deleteRecord reaction
        setSuccessMessage "Reaction deleted"
        redirectTo ReactionsAction

buildReaction reaction = reaction
    |> fill @'["emoji", "postId", "commentId"]
