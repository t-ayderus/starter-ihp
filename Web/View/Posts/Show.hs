module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Include "comments" Post }
--        <a href ={NewReactionAction post.id}> Add Reaction </a>
-- {inner}
instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <p>{post.createdAt |> timeAgo}</p>
        <p>{post.body |> renderMarkdown}</p>

        <a href = {NewVoteAction post.id currentUserId } class="me-3"> Vote </a>
        <a href ={NewCommentAction post.id}> Add Comment </a>
        <body>
            {modal}
        </body>
        <div>{forEach post.comments renderComment}</div>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Post" PostsAction
                            , breadcrumbText "Show Post"
                            ]
renderMarkdown text = 
    case text |> MMark.parse "" of
            Left error -> "Something went wrong"
            Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

renderComment comment = [hsx| 
       <div class="mt-4">
            <h5>{comment.author}</h5>
            <p>{comment.createdAt |> timeAgo} </p>
            <p>{comment.body}</p>
            <td><a href={DeleteCommentAction comment.id} class="js-delete text-muted">Delete</a></td>
        </div>
    |]

