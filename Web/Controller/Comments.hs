module Web.Controller.Comments where

import Web.Controller.Prelude
import Web.View.Comments.Index
import Web.View.Comments.New
import Web.View.Comments.Edit
import Web.View.Comments.Show
import Web.Controller.Posts



instance Controller CommentsController where
    --beforeAction = ensureIsUser

    action CommentsAction = do
        comments <- query @Comment 
            |> orderByDesc #createdAt
            |> fetch
        render IndexView { .. }

    action NewCommentAction { postId } = do
        ensureIsUser
        post <- fetch postId
        let user = currentUser
        let comment = newRecord |> set #postId postId |> set #author currentUser.email |> set #userId currentUserId
        setModal NewView{ .. }

        jumpToAction ShowPostAction {..}
        --NewView{ .. }

    action ShowCommentAction { commentId } = do
        comment <- fetch commentId
        render ShowView { .. }

    action EditCommentAction { commentId } = do
        comment <- fetch commentId
        accessDeniedUnless (comment.userId == currentUserId)
        render EditView { .. }

    action UpdateCommentAction { commentId } = do
        comment <- fetch commentId
        comment
            |> buildComment
            |> ifValid \case
                Left comment -> render EditView { .. }
                Right comment -> do
                    comment <- comment |> updateRecord
                    setSuccessMessage "Comment updated"
                    redirectTo EditCommentAction { .. }

    action CreateCommentAction = do
        let userId = currentUserId
        let comment = newRecord @Comment
        comment
            |> buildComment
            |> ifValid \case
                Left comment -> do 
                    post <- fetch comment.postId -- <--render NewView { .. } 
                    setErrorMessage "Naur"
                    render NewView{..}
                Right comment -> do
                    comment <- comment |> createRecord
                    setSuccessMessage "Comment created"  
                    jumpToAction ShowPostAction { postId = comment.postId }

    action DeleteCommentAction { commentId } = do
        comment <- fetch commentId
        accessDeniedUnless (comment.userId == currentUserId)
        deleteRecord comment
        setSuccessMessage "Comment deleted"
        jumpToAction ShowPostAction { postId = comment.postId }


buildComment comment = comment
    |> fill @'["postId", "author", "body", "userId"]
