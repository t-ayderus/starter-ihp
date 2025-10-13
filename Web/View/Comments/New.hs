module Web.View.Comments.New where
import Web.View.Prelude


data NewView = NewView { comment :: Comment, post :: Post }
--  <h1>New Comment for <q>{post.title}</q></h1>
--  {breadcrumb}
instance View NewView where
    html NewView { .. } = [hsx|
        {renderForm comment}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                  ,breadcrumbLink "Comments" CommentsAction
                   ,breadcrumbText "New Comment"
                ]

--made author hidden if it breaks
renderForm :: Comment -> Html
renderForm comment = formFor comment [hsx|
    {(hiddenField #postId)}
    {(hiddenField #author)}
    {(textField #body)}
    {submitButton}
|] 
