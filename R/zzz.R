.onAttach <- function(libname, pkgname)
{
  # Runs when attached to search() path such as by library() or require()
  if (!interactive()) return(invisible())
    load_text="
  NeonTreeEvaluation: Bug Reports <github.com/Weecology/NeonTreeEvaluation_package>. To submit a benchmark score please include a submission document and score as a pull request to
  https://github.com/weecology/NeonTreeEvaluation#performance
  "
  packageStartupMessage(load_text)
}
