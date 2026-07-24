---
title: Building Speech to Text with OpenAI Whisper
logo: openai
category: ai
permalink: /tutorials/whisper
modified_at: 2026-07-24
kind: demo
last_reviewed_at: 2026-07-24
---

[Whisper] is a general-purpose Automatic Speech Recognition (ASR) model for converting speech into text. It was trained on a large, multilingual audio corpus, which makes it robust to different accents, background noise, and real-world conditions. As an open source model, it is well suited for developers who want to integrate speech to text without depending entirely on a proprietary Saas or API.

**[faster-whisper]** is an optimized reimplementation of OpenAI's Whisper model built on the [CTranslate2] inference engine. It delivers the same transcription quality as Whisper while significantly improving inference speed and reducing memory usage, making it well suited for production deployments and resource-constrained environments such as Scalingo.

In this tutorial, we use faster-whisper to create a small speech-to-text app featuring a Python backend as well as a minimal HTTP/Javascript frontend.

## Planning your Deployment

- Whisper is available in several sizes (`tiny`, `small`, `medium`, ...). We recommend to start with the `small` size, and switch for a larger model if accuracy becomes an issue.
- The size of the container mainly depends on the size of the model you wish to use. The table below gives some rough recommendations. Please scale up or down depending on your use case and measured performances:

  | Model Size | Container Size |
  | --------- | ------------- |
  | tiny       | L              |
  | base       | L              |
  | small      | XL or 2XL      |
  | medium     | 3XL            |
  | large      | 3XL            |
  | turbo      | 3XL            |

## Deploying the Application

### Using the Command Line

1. Clone the repository:

   ```bash
   git clone https://github.com/Scalingo/scalingo-labs
   cd scalingo-labs/whisper-speech-to-text
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create my-whisper
   ```

   The Scalingo command line automatically detects the Git repository and
   adds a Git remote pointing to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/scalingo-labs (fetch)
   origin   https://github.com/Scalingo/scalingo-labs (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-whisper.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-whisper.git (push)
   ```

3. Set the model size to use:

   ```bash
   scalingo --app my-whisper env-set MODEL_SIZE=small
   ```

4. Deploy to Scalingo:

   ```bash
   git push scalingo main
   ```

   Scalingo detects the Python environment, installs the dependencies declared by the project, and starts the application using the [Procfile]. The speech to text demo is now deployed.

## Testing the Deployment

Since the model is downloaded the first time the container starts, query the `/health` endpoint to check the model status:

   ```bash
   curl https://mywhisper.osc-fr1.scalingo.io/health
   ```

The output should look like this:

   ```bash
   {"ok":true,"model":"tiny","status":"ready","ready":true}
   ```

Check that the status field is set to ready before opening the application in a browser and testing the recording from the HTML interface.

The transcription endpoint can also be tested directly with `curl`.For example, if the audio file is in the current directory of your computer:

   ```bash
   curl --request POST https://mywhisper.osc-fr1.scalingo.io/transcribe \
   --form "file=@sample.webm"
   ```

The backend writes the uploaded file to `/tmp`, transcribes it, then returns a JSON response containing the transcript and model metadata. 

In this demo the transcription runs synchronously. This demo can be adapted to an asynchronous workflow, for example by offloading the transcription to a background job.

## Customizing

### Environment

`MODEL_SIZE`: Size of the model to use. Check [Whisper][whisper] documentation for available values.
**Don't forget to adjust the size of your container(s) accordingly.**
Defaults to `small`.

*[ASR]: Automatic Speech Recognition
[whisper]: https://github.com/openai/whisper
[faster-whisper]: https://github.com/SYSTRAN/faster-whisper
[fastapi]: https://fastapi.tiangolo.com
[CTranslate2]: https://github.com/OpenNMT/CTranslate2

[procfile]: {% post_url platform/app/2000-01-01-procfile %}
