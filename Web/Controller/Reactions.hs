module Web.Controller.Reactions where

import Web.Controller.Prelude
import Web.View.Reactions.Index
import Web.View.Reactions.New
import Web.View.Reactions.Edit
import Web.View.Reactions.Show
import Web.Controller.Posts

instance Controller ReactionsController where
    action ReactionsAction = do
        reactions <- query @Reaction |> fetch
        render IndexView { .. }

    action NewReactionAction { postId } = do
        ensureIsUser
        post <- fetch postId
        let reaction = newRecord @Reaction
                    |> set #postId postId 
                    |> set #userId currentUserId
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
        ensureIsUser
        let postId = param @(Id Post) "postId"
        let emoji  = param @Text "emoji"
        let userId = currentUserId

        existing <- query @Reaction
            |> filterWhere (#postId, postId)
            |> filterWhere (#userId, userId)
            |> fetchOneOrNothing

        case existing of
            Just react -> 
                if get #emoji react == emoji 
                    then do
                        deleteRecord react
                        setSuccessMessage "Reaction removed"
                        jumpToAction ShowPostAction { postId }
                    else do
                        _ <- react 
                            |> set #emoji emoji 
                            |> updateRecord
                        setSuccessMessage "Reaction updated"
                        jumpToAction ShowPostAction { postId }
            Nothing -> do
                _ <- newRecord @Reaction
                    |> set #postId postId
                    |> set #userId userId        
                    |> set #emoji  emoji
                    |> createRecord
                setSuccessMessage "Reaction added"
                jumpToAction ShowPostAction { postId }

{--
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
                    jumpToAction ShowPostAction { postId = reaction.postId }
-}
    action DeleteReactionAction { reactionId } = do
        reaction <- fetch reactionId
        deleteRecord reaction
        setSuccessMessage "Reaction deleted"
        redirectTo ReactionsAction

buildReaction reaction = 
    reaction
        |> fill @'["userId","emoji", "postId"]
