git status
git add --all
$am = Read-Host -Prompt 'Enter Commit Message: '
git commit -am $am
git push origin
$tag = Read-Host -Prompt 'Enter Tag: '
$m = Read-Host -Prompt 'Enter Tag Message: '
git tag $tag -m $m
git push origin $tag