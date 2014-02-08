#!/usr/bin/env runhaskell

import Network.CGI

main = runCGI $ do
    setHeader "Content-type" "text/html; charset=utf-8"
    output "<!doctype><html><head><meta charset='utf-8'/></head><body>Cześć!</body></html>"
