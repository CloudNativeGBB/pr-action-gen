git clone https://$1:$2@github.com/CloudNativeGBB/app-baseline.git

TAG=$(curl -sSk -H "Authorization: Bearer $3" https://docker.pkg.github.com/v2/cloudnativegbb/arc-k8s-demos/data-api/tags/list?n=1 | jq '.tags[0]' | tr -d  '"')
cd app-baseline
git checkout -b $TAG
sed -i -e "s|        - image: msftgbb/data-api.*|        - image: msftgbb/data-api:$TAG|g" k8s/data-api.yaml
git config --global user.email $4
git config --global user.name $5
git add .
git add -A
git commit -m 'new change detected, bumping to new release version'
git push origin $TAG
PR_BODY=('{"title": "PR Auto generated based on new release","body": "New release PR","head": "'"$TAG"'","base": "master"}')
curl -u $1:$2 -d "${PR_BODY}" -H 'Content-Type: application/json' https://api.github.com/repos/cloudnativegbb/app-baseline/pulls
time=$(date)
echo ::set-output name=time::$time