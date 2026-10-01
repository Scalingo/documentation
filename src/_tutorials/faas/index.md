---
title: Running Functions on Demand with One-Off Containers
logo: linux
category: automation
kind: demo
permalink: /tutorials/faas
modified_at: 2026-10-01
last_reviewed_at: 2026-10-01
---

Function as a Service lets an application run code when a task is needed, without keeping a dedicated worker running continuously. It is useful for jobs that arrive irregularly or need substantial resources, such as generating documents, processing media, or transforming data in batches.

On Scalingo, [one-off containers][one-off-tasks] provide this execution model. They run the application's deployed code, can be started through the [Scalingo API][run-api], and stop when their command completes. [Studo uses this approach][studo] for tasks with different resource needs. Since a one-off container can take one second or more to start executing its command, we recommend using it for medium to large sized workflows.

## Planning your Deployment

- In this tutorial, the application's `web` process serves the HTTP API and the web interface. It starts a separate one-off container for each PDF generation job.
- The Scalingo API allows choosing the one-off container's [size][container-sizes] through the `size` parameter. In this application, `src/scalingo.js` sets `size: 'M'` for every invocation. Adjust this value according to your workload.
- The application is written in [Node.js][nodejs], using [PDFKit][pdfkit] to generate PDFs from quote data. The backend starts the one-off through the Scalingo API and makes the result available for download.

## Understanding How the Job Works

1. A client sends `POST /functions/quote-pdf?async=true` with quote data and an invocation key.
2. The web process validates the request, creates a job ID, and calls the Scalingo API to start a detached one-off container. It responds with `202 Accepted` and the job ID after the launch is accepted; it does not wait for PDF generation.
3. The one-off runs `node src/run-function.js quote-pdf`, renders the PDF, and calls the application's authenticated result endpoint.
4. The web process records the result. The client checks `GET /jobs/:jobId` and downloads `GET /jobs/:jobId/pdf` when the status is `completed`.

## Deploying the Application

### Using the Command Line

1. Clone the GitHub repository

   ```bash
   git clone https://github.com/SC-Samir/faas-test-scalingo
   ```

2. Create the application

   ```bash
   scalingo create mypdfjob
   git remote -v
   ```

   The CLI automatically detects the Git repository and adds a `scalingo` remote.

3. Create the mandatory environment variables

   ```bash
   scalingo --app mypdfjob env-set \
     SCALINGO_APP=mypdfjob \
     SCALINGO_REGION=osc-fr1 \
     FUNCTION_CALLBACK_BASE_URL=https://mypdfjob.osc-fr1.scalingo.io
   ```

   These variables identify the application and the address where the one-off sends its result.

   `FUNCTION_CALLBACK_BASE_URL` must be the application's public HTTPS address, without a path.

4. Configure the two credentials

   1. Create a dedicated Scalingo API token in your account dashboard, following the [API authentication guide][api-auth].

   2. Set the API token as an application environment variable:

      ```bash
      scalingo --app mypdfjob env-set SCALINGO_API_TOKEN="<scalingo_api_token>"
      ```

      The application uses this token to authenticate with Scalingo and launch one-offs.

   3. Choose a random secret of at least 32 characters and set it as the invocation key:

      ```bash
      scalingo --app mypdfjob env-set INVOKE_API_KEY="<invoke_api_key>"
      ```

      Callers send this key in the `Authorization: Bearer` header to start jobs, check their status, and download PDFs.

      Anyone with the invocation key can start jobs and download a PDF if they know its job ID.

5. Deploy with Git

   ```bash
   git push scalingo main
   ```

6. Check that the web process is ready
   ```bash
   curl --fail https://mypdfjob.osc-fr1.scalingo.io/health
   ```

   The response should be:

   ```json
   {
     "status": "ok"
   }
   ```

## Testing

The example in `examples/quote.json` contains two items: website development for EUR 1,500 and three months of maintenance at EUR 80. The PDF total is EUR 1,740 excluding tax.

1. Start a background job:
   ```bash
   curl --fail --request POST \
     'https://mypdfjob.osc-fr1.scalingo.io/functions/quote-pdf?async=true' \
     --header 'Authorization: Bearer <invoke_api_key>' \
     --header 'Content-Type: application/json' \
     --data-binary @examples/quote.json
   ```

   The application returns HTTP `202` after the launch is accepted. A typical response body is:

   ```json
   {"jobId":"550e8400-e29b-41d4-a716-446655440000","status":"pending","statusUrl":"/jobs/550e8400-e29b-41d4-a716-446655440000"}
   ```

   Replace `<invoke_api_key>` with the key configured on the application. Keep the returned `jobId` for the next steps.

2. Check the job status:
   ```bash
   curl --fail \
     'https://mypdfjob.osc-fr1.scalingo.io/jobs/<job_id>' \
     --header 'Authorization: Bearer <invoke_api_key>'
   ```

    Wait until `status` becomes `completed`. The completed response includes a `downloadUrl`. If the status is `failed`, inspect the application logs before creating a new job.

3. Download the PDF after completion:
   ```bash
   curl --fail \
     'https:/mypdfjob.osc-fr1.scalingo.io/jobs/<job_id>/pdf' \
     --header 'Authorization: Bearer <invoke_api_key>' \
     --output quote.pdf
   ```


Scalingo one-off containers let applications run tasks on demand without keeping a dedicated worker running continuously. This approach can be used for document generation, data processing, or batch operations, with resources chosen to suit each workload.

[one-off-tasks]: https://doc.scalingo.com/platform/app/tasks
[studo]: https://scalingo.com/fr/blog/studo-faas-scalingo
[run-api]: https://developers.scalingo.com/apps#run-a-one-off-container
[operations]: https://developers.scalingo.com/operations
[pdfkit]: https://pdfkit.org/docs/getting_started.html
[nodejs]: https://doc.scalingo.com/languages/nodejs
[container-sizes]: https://doc.scalingo.com/platform/internals/container-sizes
[api-auth]: https://developers.scalingo.com/#authentication
