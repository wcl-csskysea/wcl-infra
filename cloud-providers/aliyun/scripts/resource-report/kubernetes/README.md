# resource-report/kubernetes

Deploy aliyun resource report cron job to kubernetes.

## How-to

The following steps assume that you are in the `kubernetes` directory, `wiredcraft` namespace is already in place, and environment variables have been configured in `../.env` file.

1.  Create the secret needed by the cron job:

    ```sh
    kubectl -n wiredcraft create secret generic aliyun-scripts-resource-report \
        --from-env-file ../.env
    kubectl -n wiredcraft create secret generic harbor-auth \
        --from-file .dockerconfigjson="$HOME"/.docker/config.json \
        --type kubernetes.io/dockerconfigjson
    ```

2.  Apply the cron job:

    ```sh
    kubectl -n wiredcraft apply -f cronjob.yaml
    ```

3.  (Optional) Test the cron job by triggering it immediately:

    ```sh
    # Run the job
    kubectl -n wiredcraft create job --from cronjob/aliyun-scripts-resource-report aliyun-scripts-resource-report

    # Check the logs
    kubectl -n wiredcraft logs jobs/aliyun-scripts-resource-report
    ```
