module Main (main) where

import Distribution.PackageDescription
import Distribution.Simple
import Distribution.Simple.LocalBuildInfo
import Distribution.Simple.PackageIndex

main :: IO ()
main = defaultMainWithHooks simpleUserHooks
  { haddockHook = \pkg lbi hooks flags -> do
      blah pkg lbi
      haddockHook simpleUserHooks pkg lbi hooks flags
  }

blah :: PackageDescription -> LocalBuildInfo -> IO ()
blah pkg lbi =
  withLibLBI pkg lbi $ \_ libCLBI -> do
    let libDeps = map fst $ componentPackageDeps libCLBI
    case dependencyClosure (installedPkgs lbi) libDeps of
      Left p  -> p `seq` putStrLn "Found dependency closure"
      Right _ -> error "Broken dependency closure"
