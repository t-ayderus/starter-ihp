module Web.View.Votes.New where
import Web.View.Prelude

data NewView = NewView { vote :: Vote }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Vote</h1>
        {renderForm vote}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Votes" VotesAction
                , breadcrumbText "New Vote"
                ]

renderForm :: Vote -> Html
renderForm vote = formFor vote [hsx|
    {(textField #vote)}
    {(hiddenField #userId)}
    {submitButton}

|]