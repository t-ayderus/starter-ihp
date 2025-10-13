module Web.View.Posts.Index where
import Web.View.Prelude

data IndexView = IndexView { posts :: [Post] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Home
            <a href={pathTo NewPostAction} class="btn btn-info ms-4">+ New</a> 
            {authButton}
          
        </h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Posts</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach posts renderPost}</tbody>
            </table>
            
        </div>
    |]

        where 
            authButton :: Html
            authButton =
                case currentUserOrNothing of
                    Just _  -> [hsx|
                        <a href={DeleteSessionAction}
                        class="btn btn-outline-danger ms-2 js-delete js-delete-no-confirm">
                        Logout
                        </a>
                    |]
                    Nothing -> [hsx|
                        <a href={NewSessionAction}
                        class="btn btn-info ms-2">
                        Login
                        </a>
                        <a href={NewUserAction}
                        class="btn btn-info ms-2">
                        Create Account
                        </a>

                    |]
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                ]
      

renderPost :: Post -> Html
renderPost post = [hsx|
    <tr>
        <td><a href={ShowPostAction post.id}>{post.title}</a></td>
        <td><a href={EditPostAction post.id} class="text-muted">Edit</a></td>
        <td><a href={DeletePostAction post.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]