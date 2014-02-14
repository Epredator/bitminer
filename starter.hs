#!/usr/bin/env runhaskell
import System.Environment
import Data.List
import Control.Monad

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

    putStrLn "<!doctype html><html><head><meta charset='utf-8'/></head><body style='width: 600px; margin: auto; margin-top: 1cm;'><p>Wpisz tekst:</p>"
    putStrLn "<form method='POST'><textarea name='tekst' rows='4' style='width: 100%;'></textarea><br/><input type='submit' value='Wyślij'/></form>"

    qs <- queryString
    method <- requestMethod
    putStrLn ("<h4>Query string</h4><pre>" ++ qs ++ "</pre>")
    putStrLn ("<h4>Request method</h4><pre>" ++ method ++ "</pre>")
    if method == "POST" then do
        body <- takeInput
        putStrLn ("<h4>Input Body</h4><pre>" ++ body ++ "</pre>")
    else return ()

    putStrLn "</body></html>"

