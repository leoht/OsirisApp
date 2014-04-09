//
//  Constants.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#define ApiConnectionUrl                @"ws://192.168.2.1:4567"
//#define ApiWebUrl                       @"http://www.scope.dev"
#define ApiWebUrl                       @"http://192.168.2.1:3000"

#define ApiFromDeviceToPlayer           @"device_to_player"
#define ApiFromPlayerToDevice           @"player_to_device"

#define ApiConnectionOpened             @"api.connected"
#define ApiAssociateWithFacebook        @"api.associate.facebook"
#define ApiAssociateWithCode            @"api.associate.code"
#define ApiAssociationRefused           @"api.associate.refused"
#define ApiAssociatedWithToken          @"api.associated.token"

#define ApiPlayingAtTimecode            @"api.playing.current_timecode"
#define ApiRequestForNoticeAtTimecode   @"api.playing.request_notice"
#define ApiRequestForCommentAtTimecode  @"api.playing.request_comment"
#define ApiNoticeAtTimecode             @"api.playing.notice"
#define ApiRequestPlay                  @"api.movie.play"
#define ApiRequestPause                 @"api.movie.pause"
#define ApiSetVolume                    @"api.movie.volume"
#define ApiFastForward                  @"api.movie.forward"
#define ApiFastRewind                   @"api.movie.rewind"
#define ApiToggleFastForward            @"api.movie.toggle_forward"
#define ApiToggleFastRewind             @"api.movie.toggle_rewind"
#define ApiPrevChapter                  @"api.movie.prev"
#define ApiNextChapter                  @"api.movie.next"
#define ApiMovieInfo                    @"api.movie.info"
#define ApiPostMessage                  @"api.social.post"
#define ApiCommentAtTimecode            @"api.playing.comment"

#define ApiChooseNoticeSaidYes          @"api.chooser.yes"
#define ApiChooseNoticeSaidNo           @"api.chooser.no"

#define WebViewLoaded                   @"webview.loaded"
#define UserDidLoginWithFacebook        @"login.facebook"