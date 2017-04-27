# Sometimes its a README fix, or something like that - which isn't relevant for
# including in a CHANGELOG for example
has_app_changes = !git.modified_files.grep(/\.js^/).empty?

# Mainly to encourage writing up some reasoning about the PR, rather than
# just leaving a title
if github.pr_body.length < 5
  warn "Please provide a summary in the Pull Request description"
end

# Let people say that this isn't worth a CHANGELOG entry in the PR if they choose
declared_trivial = (github.pr_title + github.pr_body).include?("#trivial") || !has_app_changes

if !git.modified_files.include?("CHANGELOG.md") && !declared_trivial
  warn("Please include a CHANGELOG entry.", sticky: false)
end
