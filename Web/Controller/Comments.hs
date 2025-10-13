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
        comments <- query @Comment |> fetch
        render IndexView { .. }

    action NewCommentAction { postId } = do
        post <- fetch postId
        let comment = newRecord |> set #postId postId |> set #author currentUser.email
        setModal NewView{ .. }

        jumpToAction ShowPostAction {..}
        --NewView{ .. }

    action ShowCommentAction { commentId } = do
        comment <- fetch commentId
        render ShowView { .. }

    action EditCommentAction { commentId } = do
        comment <- fetch commentId
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
                    {-post <- fetch comment.postId
                        >>= pure . modify #comments (orderByDesc #createdAt)
                        >>= fetchRelated #comments
                    render ShowPostAction{ postId = comment.postId} -}
                    redirectTo ShowPostAction { postId = comment.postId }

    action DeleteCommentAction { commentId } = do
        comment <- fetch commentId
        deleteRecord comment
        setSuccessMessage "Comment deleted"
        redirectTo CommentsAction

buildComment comment = comment
    |> fill @'["postId", "author", "body"]
