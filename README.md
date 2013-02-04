## TV Mofo

TV Mofo (working title) is a web application to control a SiliconDust
[HDHomeRun Dual](https://www.silicondust.com/products/hdhomerun/atsc/) networked
TV tuner.

The HDHomeRun has two tuners for bringing in ATSC (free broadcast) and ClearQAM
(unencrypted cable) signals and an ethernet jack for connection to a LAN. The
box can send a UDP MPEG2 stream to a client listening on the same network (like [VLC](http://www.videolan.org).
The company publishes [free command-line tools](https://www.silicondust.com/support/hdhomerun/downloads/)
which this app uses to command and query the hardware over the network.

This web app is intended to be a kind of remote control for channel-flipping
while connected to a stream target (like a Raspberry Pi with Raspbmc).

## Requirements

- HDHomeRun Dual device (or any device compatible with their command-line tools)
- The [command-line tools](https://www.silicondust.com/support/hdhomerun/downloads/)
  for your platform (app depends on `hdhomerun_config`)
- Server on the same network as the tuner to host the app
  - Running `hdhomerun_config discover` on the server should return the tuner ID.

## Usage

1. Start the app & delayed_job worker (`foreman start`).
  - Optionally set the `HOMERUN_DEVICE` environment variable to the device ID
    returned by `hdhomerun_config discover`.
1. Visit the app in the browser.
1. Scan for channels.
   - NOTE: not yet implemented; channels currently loaded from
   [channels.yml](/test/fixtures/channels.yml) fixture file: `rake db:fixtures:load`
1. Add your PC as a stream target under "Devices". The IP should be your PC's IP
   and the port can be anything (VLC defaults to 1234). Make sure it's set as the
   primary TV output device.
1. Open VLC (or similar) and tell it to start listening for a UDP stream. VLC's
   URI for this is `udp://@:1234`.
1. Visit the "Channels" page and click a channel button. The TV Mofo server
   should instruct the tuner to start streaming to VLC in a few moments.

## Testing

- `rake`
- To run tests against a live tuner box instead of stubs: `rake test:network`

## TODO

- Get channel scanning working.
- Use sessions so that different clients can use different tuners and stream to
  different devices.
- Implement a real HTML5 remote control for mobile.
- Build out a better control API.
- Figure out if the CLI tools are even necessary for communicating with the box.
