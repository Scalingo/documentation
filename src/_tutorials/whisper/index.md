---
title: Building Speech to Text with Whisper
logo: openai
category: ai
permalink: /tutorials/whisper
modified_at: 2026-05-26
---

[Whisper] is an automatic speech recognition model that converts speech to text. It was trained on a large, multilingual audio corpus, which makes it robust to different accents, background noise, and real-world conditions. As an open source model, it is well suited for developers who want to integrate speech to text without depending entirely on a proprietary API.

Instead of relying on an external SaaS API, Whisper can run directly inside a web application using [faster-whisper], an optimized implementation of the Whisper model that improves inference speed on CPU.

In this tutorial, a small speech to text demo is deployed on Scalingo using a [FastAPI] backend, a Python web framework, a minimal HTML/JavaScript frontend that records audio in the browser, and `faster-whisper` running on CPU in a single web container.

## Planning your Deployment

For this kind of application, it is recommended to start with an M container and move to a larger size if startup time or inference latency becomes an issue.

The application supports one environment variables: `MODEL_USE`. A good starting point is to set `MODEL_USE=small`, then move to a larger model only if better accuracy is required. You can view the possibles values of `MODEL_USE` on [faster-whisper] repository.

## Deploying the Application

### Using the Command Line

1. Clone the repository:

   ```bash
   git clone https://github.com/Scalingo/whisper-speech-to-text
   cd whisper-speech-to-text
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create mywhisper
   ```

   The Scalingo command line automatically detects the Git repository and
   adds a Git remote pointing to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/whisper-speech-to-text (fetch)
   origin   https://github.com/Scalingo/whisper-speech-to-text (push)
   scalingo git@ssh.osc-fr1.scalingo.com:mywhisper.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:mywhisper.git (push)
   ```

3. Configure the application:

   ```bash
   scalingo --app mywhisper env-set MODEL_USE=small
   ```

4. Deploy to Scalingo:

   ```bash
   git push scalingo main
   ```

   Scalingo detects the Python environment, installs the dependencies declared by the project, and starts the application using the [Procfile]. The speech to text demo is now deployed.

## Testing the Deployment

Before using the application, query the health endpoint to check that the model is loaded:

   ```bash
   curl https://mywhisper.osc-fr1.scalingo.io/health
   ```

Since the model is downloaded the first time the container starts, wait until the `status` field is ready before opening the application in a browser and testing the recording from the HTML interface. 

The transcription endpoint can also be tested directly with `curl`.For example, if the audio file is in the current directory of your computer:

   ```bash
   curl --request POST https://mywhisper.osc-fr1.scalingo.io/transcribe \
   --form "file=@sample.webm"
   ```

The backend writes the uploaded file to `/tmp`, transcribes it, then returns a JSON response containing the transcript and model metadata. 

In this demo the transcription runs synchronously. This demo can be adapted to an asynchronous workflow, for example by offloading the transcription to a background job.

## Updating the Model

The application reads the Whisper model name from the `MODEL_USE` environment variable, so changing model size does not require code changes.

To switch the deployed application to another model, update the variable from the command line:

   ```bash
   scalingo --app mywhisper env-set MODEL_USE=medium
   ```

Model names such as `tiny`, `base`, `small`, `medium`, `large-v3`, or `turbo` can be used, depending on the balance required between accuracy, startup time, and CPU usage.

After changing the variable, restart the application so a new container is started with the updated configuration and the selected model is loaded again at startup:

   ```bash
   scalingo --app mywhisper restart
   ```

At the next startup, the application downloads the selected model into the cache directory and warms it in the background before serving transcription requests.

## Updating your Application

To deploy a new version, commit the changes and push again to the Scalingo remote:

   ```bash
   git add .
   git commit -m "Update Whisper demo"
   git push scalingo main
   ```

[whisper]: https://github.com/openai/whisper
[faster-whisper]: https://github.com/SYSTRAN/faster-whisper
[fastapi]: https://fastapi.tiangolo.com
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
