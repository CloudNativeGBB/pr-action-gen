
echo "" # see https://github.com/actions/toolkit/issues/168
GH_USER=$INPUT_GHUSER
GH_USER_EMAIL=$INPUT_GHUSEREMAIL
GH_USER_NAME=$INPUT_GHUSERNAME
GH_USER_TOKEN=$INPUT_GHUSERTOKEN
GH_PKG_NAME=$INPUT_PKGNAME
GH_PKG_TOKEN=$INPUT_GHPKGTOKEN


#CLONE REPO DOWN
git clone https://$GH_USER:$GH_USER_TOKEN@github.com/CloudNativeGBB/app-baseline.git

#GET THE LATEST TAG
TAG=$(curl -sSk -H "Authorization: Bearer $GH_PKG_TOKEN" https://docker.pkg.github.com/v2/cloudnativegbb/arc-k8s-demos/$GH_PKG_NAME/tags/list?n=1 | jq '.tags[0]' | tr -d  '"')

#GIT MODS
cd app-baseline
git checkout -b $TAG
sed -i -e "s|        - image: msftgbb/$GH_PKG_NAME.*|        - image: msftgbb/$GH_PKG_NAME:$TAG|g" k8s/$GH_PKG_NAME.yaml
git config --global user.email $GH_USER_EMAIL
git config --global user.name $GH_USER_NAME
git add .
git add -A
git commit -m 'new change detected, bumping to new release version'
git push origin $TAG

#DO THE PR
# PR_BODY=('{"title": "PR Auto generated based on new release","body": "New release PR","head": "'"$TAG"'","base": "master"}')
# curl -u $1:$2 -d "${PR_BODY}" -H 'Content-Type: application/json' https://api.github.com/repos/cloudnativegbb/app-baseline/pulls
# time=$(date)
echo ::set-output name=time::'now'
