# MyVCam Safe Foundation

This folder contains the initial app-owned media foundation for a safe MyVCam implementation.

Important constraints:
- The code is designed for a self-owned or explicitly authorized test app only.
- There is no third-party app injection, no jailbreak hiding, and no anti-debugging logic.
- The frame pipeline is intentionally single and explicit: FrameSource -> FramePipeline -> CVPixelBuffer / CMSampleBuffer -> app-owned consumer.

## Core concepts
- FrameSource: any legal input source (local file, HLS, RTSP, test pattern)
- FramePipeline: normalizes format, orientation, timestamps, and frame rate
- AudioMode: microphone, video audio, mixed audio, or muted
- MediaSession: top-level app-owned session controller

## Source design

```text
FrameSource
    ↓
FramePipeline
    ↓
CVPixelBuffer / CMSampleBuffer
    ↓
App-owned Preview / Consumer
```

## Audio design

```text
Microphone ─────┐
audio track ─────┼─> AudioMixer -> PCM / CMSampleBuffer -> app-owned output
Muted ──────────┘
```
