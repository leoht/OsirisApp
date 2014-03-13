//
//  Constants.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#define ApiConnectionUrl                @"ws://localhost:4567"
#define ApiWebUrl                       @"http://192.168.2.2:8080/tetris/web/_mobile"

#define ApiFromDeviceToPlayer           @"device_to_player"
#define ApiFromPlayerToDevice           @"player_to_device"

#define ApiConnectionOpened             @"api.connected"
#define ApiAssociateWithFacebook        @"api.associate.facebook"
#define ApiAssociateWithCode            @"api.associate.code"
#define ApiAssociationRefused           @"api.associate.refused"
#define ApiAssociatedWithToken          @"api.associated.token"

#define ApiPlayingAtTimecode            @"api.playing.current_timecode"
#define ApiRequestForNoticeAtTimecode   @"api.playing.request_notice"
#define ApiNoticeAtTimecode             @"api.playing.notice"
#define ApiRequestPlay                  @"api.movie.play"
#define ApiRequestPause                 @"api.movie.pause"
#define ApiSetVolume                    @"api.movie.volume"
#define ApiFastForward                  @"api.movie.forward"
#define ApiFastRewind                   @"api.movie.rewind"
#define ApiMovieInfo                    @"api.movie.info"


#define WebViewLoaded                   @"webview.loaded"
#define UserDidLoginWithFacebook        @"login.facebook"