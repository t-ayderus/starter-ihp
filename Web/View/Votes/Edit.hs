module Web.View.Votes.Edit where
import Web.View.Prelude

data EditView = EditView { vote :: Vote }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Vote</h1>
        {renderForm vote}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Votes" VotesAction
                , breadcrumbText "Edit Vote"
                ]

renderForm :: Vote -> Html
renderForm vote = formFor vote [hsx|
    {(textField #vote)}
    {(textField #userId)}
    {submitButton}

|]