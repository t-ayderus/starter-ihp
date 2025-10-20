module Web.Routes where
import IHP.RouterPrelude
import Generated.Types
import Web.Types

-- Generator Marker
instance AutoRoute StaticController
instance AutoRoute PostsController
instance AutoRoute CommentsController

instance AutoRoute SessionsController


instance AutoRoute UsersController


instance AutoRoute ReactionsController


instance AutoRoute VotesController

