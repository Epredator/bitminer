#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-}

import System.Environment
import Data.Maybe
import Data.List
import Control.Monad

import Text.Blaze.Html5 hiding (map)
import Text.Blaze.Html5.Attributes
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.String (renderHtml)

cgiVars = [
    "REQUEST_METHOD",
    "SCRIPT_NAME",
    "QUERY_STRING",
    "CONTENT_TYPE",
    "CONTENT_LENGTH",

    "HTTP_COOKIE",
    "HTTP_REFERER",
    "HTTP_ACCEPT",
    "HTTP_USER_AGENT",
    "REMOTE_HOST",
    "REMOTE_ADDR",

    "PATH_INFO",
    "PATH_TRANSLATED",

    "GATEWAY_INTERFACE", 
    "SERVER_SOFTWARE",
    "SERVER_NAME",
    "SERVER_PROTOCOL",
    "SERVER_PORT"
    ]

getCgiVars :: IO [(String,String)]
getCgiVars = do
    env <- getEnvironment
    return $ catMaybes $ map (\s -> do v <- lookup s env; return (s,v))  cgiVars

contentLength :: IO Int
contentLength = do
    fmap read (getEnv "CONTENT_LENGTH")

takeInput :: IO String
takeInput = do
    length <- contentLength
    fmap (take length) getContents

requestMethod :: IO String
requestMethod = do
    getEnv "REQUEST_METHOD"

queryString :: IO String
queryString = do
    getEnv "QUERY_STRING"


--page :: Html
page vars = docTypeHtml $ do
    H.head $ do
        meta ! charset "utf-8"
        H.style ! A.type_ "text/css" $ "body { width: 600px; margin: auto; }\ntd { border: 1px solid black; }"
    body $ do
        h1 "Zmienne środowiskowe CGI"
        table ! A.style "border: 1px solid black;" $ forM_ vars $ \(name,value) -> do
            tr $ do
                td $ toHtml $ name
                td $ toHtml $ value

        

main :: IO ()
main = do
    putStrLn "Content-Type: text/html"
    putStrLn ""
    vars <- getCgiVars
    putStrLn (renderHtml (page vars))
