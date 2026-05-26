---
title: Building speech to text with Whisper
logo: openai
category: ai
permalink: /tutorials/whisper
modified_at: 2026-05-26
---

Whisper is an automatic speech recognition model that converts speech to text. It was trained on a large, multilingual audio corpus, which makes it robust to different accents, background noise, and real-world conditions. As an open-source model, it is well suited for developers who want to integrate speech-to-text without depending entirely on a proprietary API.

Instead of relying on an external SaaS API, Whisper can run directly inside a web application using `faster-whisper`. This implementation keeps the same model family while improving inference speed and reducing resource usage.

In this tutorial, a small speech-to-text demo is deployed on Scalingo using a FastAPI backend, a minimal HTML/JavaScript frontend that records audio in the browser, and `faster-whisper` running on CPU in a single web container.

## Planning your deployment

For this kind of application, it is recommended to start with an M container and move to a larger size if startup time or inference latency becomes an issue. The application warms the model in the background at startup and stores downloaded model files under `/tmp/models`.

The application supports two environment variables: `MODEL_USE`, which defaults to `small`, and `MODEL_CACHE_DIR`, which defaults to `/tmp/models`. Starting with `MODEL_USE=small` is a good default, then moving to a larger model only if better accuracy is required.

## Deploying the application

### Using the command line

1. Clone the repository:

   ```bash
   git clone https://github.com/Scalingo/whisper-speech-to-text
   cd whisper-speech-to-text
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create whisper-speech-to-text
   ```

   The Scalingo command line automatically detects the Git repository and
   adds a Git remote pointing to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/whisper-speech-to-text (fetch)
   origin   https://github.com/Scalingo/whisper-speech-to-text (push)
   scalingo git@ssh.osc-fr1.scalingo.com:whisper-speech-to-text.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:whisper-speech-to-text.git (push)
   ```

3. Configure the application:

   ```bash
   scalingo --app whisper-speech-to-text env-set MODEL_USE=small
   scalingo --app whisper-speech-to-text env-set MODEL_CACHE_DIR=/tmp/models
   ```

4. Deploy to Scalingo:

   ```bash
   git push scalingo main
   ```

   Scalingo detects the Python environment, installs the dependencies declared by the project, and starts the application using the `Procfile`. The speech-to-text demo is now deployed.

## Testing the deployment

Before using the application, check the health endpoint to verify that the model is loaded:

   ```bash
   curl https://whisper-speech-to-text.osc-fr1.scalingo.io/health
   ```

Once the model is ready, open the application in a browser and test recording from the HTML interface. The transcription endpoint can also be tested directly with `curl`:

   ```bash
   curl -X POST https://whisper-speech-to-text.osc-fr1.scalingo.io/transcribe \
   -F "file=@sample.webm"
   ```

The backend writes the uploaded file to `/tmp`, transcribes it, then returns a JSON response containing the transcript and model metadata.

## Updating the model

The application reads the Whisper model name from the `MODEL_USE` environment variable, so changing model size does not require code changes.

To switch the deployed application to another model, update the variable from the command line:

   ```bash
   scalingo --app whisper-speech-to-text env-set MODEL_USE=medium
   ```

Model names such as `tiny`, `base`, `small`, `medium`, `large-v3`, or `turbo` can be used, depending on the balance required between accuracy, startup time, and CPU usage.

After changing the variable, restart the application so the web process reloads the selected model:

   ```bash
   scalingo --app whisper-speech-to-text restart
   ```

At the next startup, the application downloads or reloads the selected model into the cache directory and warms it in the background before serving transcription requests.

## Updating your application

To deploy a new version, commit the changes and push again to the Scalingo remote:

   ```bash
   git add .
   git commit -m "Update Whisper demo"
   git push scalingo main
   ```

If the frontend template, model settings, or Python dependencies change, redeploying is enough for Scalingo to rebuild and restart the application with the new version.
