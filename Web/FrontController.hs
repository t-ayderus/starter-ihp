module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)
import IHP.LoginSupport.Middleware

-- Controller Imports
import Web.Controller.Votes
import Web.Controller.Reactions
import Web.Controller.Users
import Web.Controller.Sessions
import Web.Controller.Comments
import Web.Controller.Posts
import Web.Controller.Static

instance FrontController WebApplication where
    controllers = 
        [ startPage PostsAction
        -- Generator Marker
        , parseRoute @VotesController
        , parseRoute @ReactionsController
        , parseRoute @UsersController
        , parseRoute @SessionsController
        , parseRoute @CommentsController
        , parseRoute @PostsController
        ]
        
instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User


