module Web.Types where

import IHP.LoginSupport.Types
import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)

--userId :: !(Id User)
data StaticController = WelcomeAction deriving (Eq, Show, Data)

data PostsController
    = PostsAction
    | NewPostAction 
    | ShowPostAction { postId :: !(Id Post) }
    | CreatePostAction
    | EditPostAction { postId :: !(Id Post) }
    | UpdatePostAction { postId :: !(Id Post) }
    | DeletePostAction { postId :: !(Id Post) }
    deriving (Eq, Show, Data)

data CommentsController
    = CommentsAction
    | NewCommentAction {postId :: !(Id Post) }
    | ShowCommentAction { commentId :: !(Id Comment) }
    | CreateCommentAction
    | EditCommentAction { commentId :: !(Id Comment) }
    | UpdateCommentAction { commentId :: !(Id Comment) }
    | DeleteCommentAction { commentId :: !(Id Comment) }
    deriving (Eq, Show, Data)

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User
data UsersController
    = UsersAction
    | NewUserAction  
    | ShowUserAction { userId :: !(Id User) }
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data ReactionsController
    = ReactionsAction
    | NewReactionAction {postId :: !(Id Post) }
    | ShowReactionAction { reactionId :: !(Id Reaction) }
    | CreateReactionAction
    | EditReactionAction { reactionId :: !(Id Reaction) }
    | UpdateReactionAction { reactionId :: !(Id Reaction) }
    | DeleteReactionAction { reactionId :: !(Id Reaction) }
    deriving (Eq, Show, Data)

data VotesController
    = VotesAction
    | NewVoteAction {postId :: !(Id Post), userId :: !( Id User) }
    | NewDownVoteAction {postId :: !(Id Post), userId :: !( Id User) }
    | ShowVoteAction { voteId :: !(Id Vote) }
    | CreateVoteAction
    | EditVoteAction { voteId :: !(Id Vote) }
    | UpdateVoteAction { voteId :: !(Id Vote) }
    | DeleteVoteAction { voteId :: !(Id Vote) }
    deriving (Eq, Show, Data)
