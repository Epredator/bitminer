#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-}

import System.Environment
import Data.Maybe
import Data.List
import Control.Monad

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


main :: IO ()
main = do
    putStrLn "Content-Type: text/html"
    putStrLn ""

    vars <- getCgiVars
    putStrLn "<!doctype html><html><head><meta charset='utf-8'/></head><body style='width: 600px; margin: auto; margin-top: 1cm;'><h4>Zmienne środowiskowe:</h4>"
    putStrLn "<table>"
    forM_ vars $ \(name, value) -> do
        putStrLn $ "<tr><td>" ++ name ++ "</td><td>" ++ value ++ "</td></tr>"
    putStrLn "</table></body></html>"
