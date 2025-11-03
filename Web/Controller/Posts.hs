module Web.Controller.Posts where

import Web.Controller.Prelude
import Web.View.Posts.Index
import Web.View.Posts.New
import Web.View.Posts.Edit
import Web.View.Posts.Show
import qualified Text.MMark as MMark

instance Controller PostsController where
    action PostsAction = do
        posts <- query @Post 
            |> orderByDesc #createdAt
            |> fetch
        render IndexView { .. }
        
    action NewPostAction = do
        ensureIsUser
        let post = newRecord  |> set #userId currentUserId
        render NewView { .. }
           

    action ShowPostAction { postId } = do
        post <- fetch postId
            >>= pure . modify #comments (orderByDesc #createdAt)
            >>= fetchRelated #comments
        reactions <- query @Reaction
            |> filterWhere (#postId, postId)
            |> fetch
        votes <- query @Vote
            |> filterWhere (#postId, postId)
            |> fetch
        render ShowView {..}

    action EditPostAction { postId } = do
        post <- fetch postId     
        accessDeniedUnless (post.userId == currentUserId)
        render EditView { .. }

    action UpdatePostAction { postId } = do
        post <- fetch postId
        post
            |> buildPost
            |> ifValid \case
                Left post -> render EditView { .. }
                Right post -> do
                    post <- post |> updateRecord
                    setSuccessMessage "Post updated"
                    --redirectTo EditPostAction { .. }
                    post <- fetch postId
                        >>= pure . modify #comments (orderByDesc #createdAt)
                        >>= fetchRelated #comments
                    reactions <- query @Reaction
                         |> filterWhere (#postId, postId)
                         |> fetch
                    votes <- query @Vote
                        |> filterWhere (#postId, postId)
                        |> fetch
                    render ShowView { .. }

    action CreatePostAction = do
        let post = newRecord @Post
        post
            |> buildPost
            |> ifValid \case
                Left post -> render NewView { .. } 
                Right post -> do
                    post <- post |> createRecord
                    setSuccessMessage "Post created"
                    posts <- query @Post 
                        |> orderByDesc #createdAt
                        |> fetch
                    render IndexView { .. }
                    --redirectTo PostsAction

    action DeletePostAction { postId } = do
        post <- fetch postId
        accessDeniedUnless (post.userId == currentUserId)
        deleteRecord post
        setSuccessMessage "Post deleted"
        redirectTo PostsAction

buildPost post = post
    |> fill @'["userId", "title", "body"]
    |> validateField #title nonEmpty
    |> validateField #body nonEmpty
    |> validateField #body nonEmpty
    |> validateField #body isMarkdown

isMarkdown :: Text -> ValidatorResult
isMarkdown text =
    case MMark.parse "" text of
        Left _ -> Failure "Please provide valid Markdown"
        Right _ -> Success