module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Include "comments" Post, reactions :: [Reaction], votes :: [Vote]}
--        <a href ={NewReactionAction post.id}> Add Reaction </a>
-- {inner} {renderReactionsBar reactions}
instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <p>{post.createdAt |> timeAgo}</p>
        <p>{post.body |> renderMarkdown}</p>
       

        <a href ={NewCommentAction post.id} class="me-3"> Add Comment </a>
        <div class="d-flex align-items-center gap-2">

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="emoji" value="👍" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >👍{renderCount (numReactions reactions "👍") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="emoji" value="👎" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >👎{renderCount (numReactions reactions "👎") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="emoji" value="❤️" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >❤️{renderCount (numReactions reactions "❤️") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="emoji" value="😂" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >😂{renderCount (numReactions reactions "😂") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="emoji" value="🎉" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >🎉{renderCount (numReactions reactions "🎉") }
            </button>
        </form>

        <form action = {CreateVoteAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="ballot" value= "1" />
            <button type="submit" class="border rounded px-2 hover:bg-gray-100" > UpVote {renderVotesCount (numVotes votes 1) } </button>
        </form>   

        <form action = {CreateVoteAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="ballot" value= "-1" />
            <button type="submit" class="border rounded px-2 hover:bg-gray-100" > DownVote {renderVotesCount (numVotes votes (-1)) } </button>
        </form>   

        </div>

            {modal}
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




{--
    <div class="d-flex align-items-center gap-2">
        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="userId" value={tshow currentUserId} />
            <input type="hidden" name="emoji" value="👍" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >👍{renderCount (numReactions reactions "👍") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="userId" value={tshow currentUserId} />
            <input type="hidden" name="emoji" value="👎" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >👎{renderCount (numReactions reactions "👎") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="userId" value={tshow currentUserId} />
            <input type="hidden" name="emoji" value="❤️" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >❤️{renderCount (numReactions reactions "❤️") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="userId" value={tshow currentUserId} />
            <input type="hidden" name="emoji" value="😂" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >😂{renderCount (numReactions reactions "😂") }
            </button>
        </form>

        <form action={CreateReactionAction} method="POST" class="me-3">
            <input type="hidden" name="postId" value={tshow post.id} />
            <input type="hidden" name="userId" value={tshow currentUserId} />
            <input type="hidden" name="emoji" value="🎉" />
            <button 
                type="submit" 
                class="border rounded px-2 hover:bg-gray-100"

            >🎉{renderCount (numReactions reactions "🎉") }
            </button>
        </form>
    </div>
    |]
--}

numVotes :: [Vote] -> Int -> Int
numVotes votes ballot = 
    length ( filter (\vote -> get #ballot vote == ballot) votes )

renderVotesCount :: Int -> Html
renderVotesCount count = 
    if count > 0
    then [hsx| ({count}) |]
    else mempty
    
numReactions :: [Reaction] -> Text -> Int
numReactions reactions emoji = 
    let targetReaction = filter( \reaction -> get #emoji reaction == emoji) reactions
    in length targetReaction

renderCount :: Int -> Html
renderCount count =
    if count > 0
    then [hsx| ({count}) |]
    else mempty


