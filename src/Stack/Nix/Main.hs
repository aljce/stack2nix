module Stack.Nix.Main where

import Options.Applicative

data Opts = Opts

data Program = Version | Normal Opts

version = "v0.1.0"

optsP :: Parser Opts
optsP = pure Opts

versionP :: Parser Program
versionP = flag' Version (long "version" <> short 'v' <> help "Prints the version number")

programP :: Parser Program
programP = versionP <|> (Normal <$> optsP)

handle :: Opts -> IO ()
handle _ = return ()

main :: IO ()
main = execParser (info (helper <*> programP) desc) >>= \case
  Normal opts -> handle opts
  Version -> putStrLn ("Version: " ++ version)
  where desc = (fullDesc <>
                progDesc "TODO" <>
                header "stack2nix conerts cabal and stack.yaml files into build instructions for Nix." )


