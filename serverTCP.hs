--to listen on a port and accept connections!
import Network (listenOn, withSocketsDo, accept, PortID(..), Socket)

--to get command line argument 
import System.Environment (getArgs)

--to change socket handle's buffering mode
import System.IO (hSetBuffering, hGetLine, hPutStrLn, BufferMode(..), Handle)

--to spawn new Haskell threads
import Control.Concurrent (forkIO)


--Our main function will parse the port command line argument, 
--start the server on the port, and then call sockHandler function 
--that will accept connections and put them in a new thread,
main :: IO ()
main = withSocketsDo $ do
    args <- getArgs
    let port = fromIntegral (read $ head args :: Int)
    sock <- listenOn $ PortNumber port
    putStrLn $ "Listening on " ++ (head args)
    sockHandler sock

sockHandler :: Socket -> IO ()
sockHandler sock = do
    (handle, _, _) <- accept sock
    hSetBuffering handle NoBuffering
    forkIO $ commandProcessor handle
    sockHandler sock

commandProcessor :: Handle -> IO ()
commandProcessor handle = do
    line <- hGetLine handle
    let cmd = words line
    case (head cmd) of
        ("echo") -> echoCommand handle cmd
        ("add") -> addCommand handle cmd
        _ -> do hPutStrLn handle "Unknown command"
    commandProcessor handle

echoCommand :: Handle -> [String] -> IO ()
echoCommand handle cmd = do
    hPutStrLn handle (unwords $ tail cmd)

addCommand :: Handle -> [String] -> IO ()
addCommand handle cmd = do
    hPutStrLn handle $ show $ (read $ cmd !! 1) + (read $ cmd !! 2)


