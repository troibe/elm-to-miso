import System.Environment
import Text.Regex

-- only works on single lines!
replacements :: [(Regex, String)]
replacements =
  [ (mkRegex "List\\.concat", "Prelude.concat")
  , (mkRegex "List\\.map", "Prelude.map")
  , (mkRegex "List\\.filterMap identity", "Maybe.mapMaybe id")
  , (mkRegex "Maybe\\.map", "fmap")
  , (mkRegex "Maybe\\.withDefault", "Maybe.maybe")
  , (mkRegex "\\(\\((.*)\\) as config_", "(config_@\\1")
  , (mkRegex "Config \\{ config_ \\|", "config_ {")
  , (mkRegex "type ", "data ")
  , (mkRegex "\\(Config config_\\)", "config_")
  , (mkRegex "Html msg", "Miso.View msg")
  , (mkRegex "Miso\\.Attibute\\.attribute ", "Miso.textProp ")
  , (mkRegex "Miso\\.node ", "Miso.nodeHtml ")
  , (mkRegex "Miso\\.a ", "Miso.a_")
  , (mkRegex "Miso\\.input ", "Miso.input_ ")
  , (mkRegex "Miso\\.div ", "Miso.div_ ")
  , (mkRegex "Miso\\.span ", "Miso.span_ ")
  , (mkRegex "Miso\\.i ", "Miso.i_ ")
  , (mkRegex "Miso\\.label ", "Miso.label_ ")
  , (mkRegex "Miso\\.td ", "Miso.td_ ")
  , (mkRegex "Miso\\.th ", "Miso.th_ ")
  , (mkRegex "Miso\\.tr ", "Miso.tr_ ")
  , (mkRegex "Miso\\.thead ", "Miso.thead_ ")
  , (mkRegex "Miso\\.tbody ", "Miso.tbody_ ")
  , (mkRegex "class ", "Miso.class_ ")
  , (mkRegex "Miso\\.table ", "Miso.table_ ")
  , (mkRegex "Html\\.", "Miso.")
  , (mkRegex "List \\(([^\\)]*)\\)", "[\\1]")
  , (mkRegex " \\$: ", " :: ")
  , (mkRegex " :: ", " : ")
  , (mkRegex " : ", " $: ")
  , (mkRegex "exposing", "")
  ]

translate :: [(Regex, String)] -> String -> String
translate rs s = foldr (\(reg, rep) s -> subRegex reg s rep) s rs

main :: IO ()
main = do
  args <- getArgs
  case args of
    [inFile, outFile] -> do
      inString <- readFile inFile
      let outString = "{-# LANGUAGE OverloadedStrings #-}\n" ++ translate replacements inString
      writeFile outFile outString
    _ -> putStrLn "usage: Translator <inFile> <outFile>"