module Web.View.Votes.Show where
import Web.View.Prelude

data ShowView = ShowView { vote :: Vote }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Vote</h1>
        <p>{vote}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Votes" VotesAction
                            , breadcrumbText "Show Vote"
                            ]