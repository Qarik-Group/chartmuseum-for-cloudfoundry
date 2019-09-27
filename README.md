# ChartMuseum for Cloud Foundry

[ChartMuseum](https://chartmuseum.com/) is an open-source, easy to deploy,
Helm Chart Repository server. This project deploys ChartMuseum to any Cloud Foundry.

It is being used to deploy https://helm.starkandwayne.com.

```plain
helm repo add starkandwayne https://helm.starkandwayne.com
helm repo update
helm search starkandwayne
```

## Deployment to Cloud Foundry

The project includes a sample `manifest-starkandwayne.yml` with environment variables used by https://helm.starkandwayne.com. Some are secret, and must be provided at `cf push` time as variables

* `((auth-user))` and `((auth-pass))` are the administrator basic auth credentials to push new Charts to ChartMuseum
* `((aws-access-key-id))` and `((aws-secret-access-key))` are the AWS IAM API keys for a user who has read/write permission to the `starkandwayne-chartmuseum` S3 bucket.

We deploy this application, and fulfil the required variables with:

```plain
cf push \
    --var auth-user=USER  --var auth-pass=PASSWORD \
    --var "aws-access-key-id=KEYKEYKEY" \
    --var "aws-secret-access-key=SECRETSECRET"
```

Configuration of ChartMuseum is via environment variables that are passed directly to `chartmuseum` application. To see the full list:

```plain
./bin/start.sh --help
```

### Always Latest ChartMuseum

In the initial version of this project, every time you deploy -- indeed every time your application contain restarts -- the latest release of `chartmuseum` binary for linux will be downloaded.

This might be a bad idea. We'll find out in due course.

## Upload Charts

Given the basic auth credentials from the Deployment example above, you would upload a new chart to your ChartMuseum via `curl`:

```plain
curl -u "USER:PASSWORD" \
    --data-binary "@path/to/chart-1.2.3.tgz" \
    https://helm.starkandwayne.com/api/charts
```
