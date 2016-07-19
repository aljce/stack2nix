module Stack.Nix.Main where

import Options.Applicative

data Opts = ProjectRoot {
  projectP :: String } | Files {
  stackF :: String,
  cabalF :: String }

data ExecutionType = Version | Normal {
  optionsN   :: Opts,
  modifiersN :: Modifiers }

data Modifiers = Modifiers {
  outputM :: Maybe String }

data Program = Program ExecutionType Modifiers

version = "v0.1.0"

optsP :: Parser Opts
optsP = projectRootP <|> filesP
  where projectRootP = ProjectRoot <$> strArgument (metavar "PROJECT-ROOT" <>
                                                    help "The directory that houses the stack.yaml file and *.cabal file.")
        filesP = Files <$> strOption (long "stack-yaml" <> short 's' <> metavar "FILE" <>
                                      help "The projects stack.yaml file.")
                       <*> strOption (long "cabal" <> short 'c' <> metavar "FILE" <>
                                      help "The projects cabal file.")

modifiersP :: Parser Modifiers
modifiersP = Modifiers <$> optional (strOption (long "output" <> short 'o' <> metavar "FILE" <>
                                                help "Where to write the generated nix configuration."))

versionP :: Parser ExecutionType
versionP = flag' Version (long "version" <> short 'v' <> help "Prints the version number")

programP :: Parser ExecutionType
programP = Normal <$> optsP <*> modifiersP <|> versionP

handle :: Opts -> IO ()
handle _ = return ()

main :: IO ()
main = execParser (info (helper <*> programP) desc) >>= \case
  Normal opts modifiers -> handle opts
  Version -> putStrLn ("Version: " ++ version)
  where desc = (fullDesc <>
                progDesc "TODO" <>
                header "stack2nix conerts cabal and stack.yaml files into build instructions for Nix." )


