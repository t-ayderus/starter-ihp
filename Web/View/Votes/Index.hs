module Web.View.Votes.Index where
import Web.View.Prelude

data IndexView = IndexView { votes :: [Vote] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Vote</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Vote</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach votes renderVote}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Votes" VotesAction
                ]

renderVote :: Vote -> Html
renderVote vote = [hsx|
    <tr>
        <td>{vote}</td>
        <td><a href={ShowVoteAction vote.id}>Show</a></td>
        <td><a href={EditVoteAction vote.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteVoteAction vote.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]