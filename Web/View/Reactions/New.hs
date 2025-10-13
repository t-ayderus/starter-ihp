module Web.View.Reactions.New where
import Web.View.Prelude

data NewView = NewView { reaction :: Reaction, post :: Post }
--{breadcrumb}
instance View NewView where
    html NewView { .. } = [hsx|
        
        <h1>New Reaction</h1>
        {renderForm reaction}
        
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Reactions" ReactionsAction
                , breadcrumbText "New Reaction"
                ]

renderForm :: Reaction -> Html
renderForm reaction = formFor reaction [hsx|
    {(textField #emoji)}
    {(hiddenField #postId)}
    {(hiddenField #commentId)}
    {submitButton}

|]