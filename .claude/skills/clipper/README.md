# Clipper

Version 2.0

A free Claude Code skill that turns a long talking-head video, podcast or gaming livestream into short vertical clips (9:16, 1080x1920), cut and edited:

- transcribes the video on your Mac, with the timing of every word
- Claude reads the transcript and picks the moments that make sense on their own, open on a hook and end on the payoff
- talking heads and podcasts: reframes each shot on the face of whoever is speaking, with a new framing at every camera cut
- **new in 2.0, stream mode**: for gameplay or watch-along streams with a webcam overlay, it finds the facecam by itself and stacks it on top (about 40 %) with the gameplay below (about 60 %), keeping chat and counters out of the gameplay panel
- **new in 2.0, moments from sound**: finds reactions in the audio (screams, laughs, sudden silence) and gives each one a setup before it and a few seconds after it, so the moment can breathe
- captions 2-3 words at a time, key words highlighted, never over a face
- punch-in zooms (on the facecam at each reaction in stream mode), audio levelled for social (-14 LUFS)
- checks every clip from real frames (a contact sheet per clip) before handing it over
- gives you a title and a post caption for each clip

## Install in 3 steps

1. Unzip this folder into `~/.claude/skills/clipper` (so that `~/.claude/skills/clipper/SKILL.md` exists). Updating from 1.x: replace the old folder; keep `.venv` if you want to skip the setup.
2. Open Claude Code and say: **set this up for me**. Claude checks your Mac and installs what is missing (ffmpeg, Python packages). The first run also downloads the speech model once, about 500 MB.
3. Say: **clip this video** or **clip this stream** followed by a YouTube or Twitch link or the path to a video file.

Claude asks five quick questions (how many clips, length, caption colour, sound effects, where they go). Say "go" for the defaults: the 5 best clips, 20-60 s each (15-45 s for a stream).

Stream mode turns on by itself when the video is a stream with a facecam. You can also ask for it: "stream mode", "gameplay clips", "GTA clips".

## Requirements

- A Mac (Apple Silicon or Intel) with Claude Code.
- A paid Claude plan. Pro is enough.
- About 2 GB of free disk space for the tools and the speech model.

## What costs nothing extra

Everything runs on your Mac: downloading, transcription, facecam and face detection, sound analysis, cutting, captions, zooms, sound and checks. The only part that uses Claude is reading the transcript and choosing the moments, which is covered by your normal Claude plan. No API keys, no paid services.

## What is still your job

- Only clip streams and videos you own or are allowed to clip, for example under a clipping campaign brief or with the streamer's written OK. Reposting other people's content can break platform rules and copyright law.
- Read the brief before you post: the handle or credit it wants on screen or in the caption, the ad or sponsorship disclosure, the hashtags, and any moments that are off limits.
- Pick the hook. Clipper proposes and scores the moments; you decide what opens each clip and what goes out.

## What is inside

- `SKILL.md`: the instructions Claude follows, including how it picks moments.
- `scripts/doctor.sh`: checks your Mac and prints one fix command per missing tool.
- `scripts/fetch.py`, `transcribe.py`, `cut.py`, `edit.py`, `check.py`: the pipeline.
- `scripts/layout.py`: decides talk or stream mode, finds the facecam and the gameplay area, writes a preview of the stacked layout.
- `scripts/moments.py`: finds reaction peaks in the sound and merges them with the transcript into clip candidates.
- `scripts/make_sfx.py`: makes the whoosh and pop sounds in `sfx/` from scratch (no third-party sound files).
- `fonts/Montserrat-ExtraBold.ttf`: caption font, under the SIL Open Font License (`fonts/OFL.txt`).

## Changes

- 2.0: stream mode (facecam detection, stacked 9:16 layout, overlay-aware gameplay crop, captions under the divider), sound-based moment candidates with setup and breathe, clip options `peaks`, `skip_captions`, `game_x`, `game_zoom`, stream checks in the contact sheets.
- 1.0: talking-head and podcast clips.

## Credits

Method patterns (a doctor script that prints one fix command per missing tool, numbered questions with defaults where "go" accepts them all, and checking frames instead of code with a contact sheet before calling anything done) are adapted from Jack Roberts' claude-video-2 (MIT License). No code or content from it is included. Font: Montserrat by Julieta Ulanovsky and the Montserrat Project Authors (OFL). Transcription: faster-whisper. Video: FFmpeg, OpenCV, yt-dlp.

Want to schedule the clips everywhere? HubPost connects to Claude: https://hubpost.co/?utm_source=github&utm_medium=skill&utm_campaign=claude-clipper&utm_content=readme

## License

MIT, see `LICENSE`.
