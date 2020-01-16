git clone https://$GH_USER:$GH_USER_TOKEN@github.com/CloudNativeGBB/app-baseline.git

TAG=$(curl -sSk -H "Authorization: Bearer $GH_PKG_TOKEN" https://docker.pkg.github.com/v2/cloudnativegbb/arc-k8s-demos/data-api/tags/list?n=1 | jq '.tags[0]' | tr -d  '"')
cd app-baseline
git checkout -b $TAG
sed -i -e "s|        - image: msftgbb/data-api.*|        - image: msftgbb/data-api:$TAG|g" k8s/data-api.yaml
git config --global user.email $GH_USER_EMAIL
git config --global user.name $GH_USER_NAME
git add .
git add -A
git commit -m 'new change detected, bumping to new release version'
git push origin $TAG
PR_BODY=('{"title": "PR Auto generated based on new release","body": "New release PR","head": "'"$TAG"'","base": "master"}')
curl -u $GH_USER:$GH_USER_TOKEN -d "${PR_BODY}" -H 'Content-Type: application/json' https://api.github.com/repos/cloudnativegbb/app-baseline/pulls