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
    method <- requestMethod

    if method == "POST" then do
        putStrLn "Content-Type: text/plain"
        putStrLn ""
        body <- takeInput
        putStrLn body
    else do
        putStrLn "Content-Type: text/html"
        putStrLn ""

        putStrLn "<!doctype html><html><head><meta charset='utf-8'/>"
        putStrLn "<script src='http://code.jquery.com/jquery-1.10.2.min.js'></script>"
        putStrLn "</head>"
        putStrLn "<body style='width: 600px; margin: auto; margin-top: 1cm;'><p>Wpisz tekst:</p>"
        putStrLn "<form id='formularz' method='POST'>"
        putStrLn "Ciąg znaków, który jest prefixem dla wykopywanego stringa: <input type='text' name='prefix'>"
        putStrLn "<br/>"
        putStrLn "<br/>"
        putStrLn "Ilość oczekiwanych zer:"
        putStrLn "<br/>"
        putStrLn "<input type='text' name='zeros'>"
        putStrLn "<br/><input type='submit' value='Wysij'/></form>"

        qs <- queryString
        putStrLn ("<h4>Query string</h4><pre>" ++ qs ++ "</pre>")
        putStrLn ("<h4>Request method</h4><pre>" ++ method ++ "</pre>")
        putStrLn ("<h4>Input Body</h4><pre id='input_body'></pre>")

        putStrLn ("<script>")
        putStrLn ("jQuery('#formularz').on('submit', function(){")
        putStrLn ("    jQuery.post('starter.hs', jQuery('#formularz').serialize(), function(odpowiedz){")
        putStrLn ("        jQuery('#input_body').text(odpowiedz);")
        putStrLn ("    });")
        putStrLn ("    return false;")
        putStrLn ("});")
        putStrLn ("</script>")

        putStrLn "</body></html>"
