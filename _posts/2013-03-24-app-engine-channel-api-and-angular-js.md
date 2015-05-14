---
layout: post
title: App Engine Channel API and Angular JS
date: '2013-03-24T01:07:00.002-07:00'
author: David Hatanian
tags:
modified_time: '2013-03-24T01:26:12.117-07:00'
blogger_id: tag:blogger.com,1999:blog-5219665179084602082.post-3957253144001263652
blogger_orig_url: http://david-codes.blogspot.com/2013/03/app-engine-channel-api-and-angular-js.html
---

I've been using Google App Engine for a while now, and it is hard to go back to traditional java webapp development given how easy it is to deploy a demo version for a customer, and how great some of the tools provided in the App Engine SDK are.


Among those tools is the <a
        href="https://developers.google.com/appengine/docs/java/channel/">Channel API</a>. It offers push messaging with
    only a few lines of code. There are some drawbacks (mainly regarding the reliability of the communications) but it
    still is a <b>great</b>&nbsp;tool to provide real-time notifications to the user.


I also recently discovered <a href="http://angularjs.org/">Angular JS</a>. A great
    Javascript MVP framework (also by Google, it turns out). If you don't know it already, have a look at their web
    site. The web-binding part is quite amazing.

Now, I read Angular JS provides some support for Comet notifications, but nothing for
    the Channel API. On a project I'm developping on my spare time there's this need to send chat messages to various
    users.

Here's how I did it with AngularJS and the Channel API :
<ul>
    <li>Create an AngularJS service to hold the list of the chats. This is not required but it is the recommended way to
        share an observable array (which means with two-way data binding) between controllers.
    </li>
    <li>Initiate &nbsp;the Channel API inside that service. Now there's the trick : for the modifications to the
        observable array to be pushed to the controllers, we need to use the <i>$rootScope </i>method.
    </li>
</ul>

So here's how the service looks ( the chat repository which receives the chats from the Channel API is
    `AllChats`):

{% highlight javascript %}
    angular.module('hatChatServices', ['ngResource'])
          .factory('Chat', function($resource){
       return $resource('chats/:chatId', {}, {
         query: {method:'GET', params:{chatId:'latest'}, isArray:true},
       });
     })
     .factory('AllChats', function($rootScope,Chat){
        var chatsList = Chat.query();
        var unreadChats = {
            "PENDING" : 0,
            "APPROVED" : 0,
            "ANSWERED" : 0
        }

        //that's where we connect
        var socket = new SocketHandler();
        socket.onMessage(function(data){
         $rootScope.$apply(function () {
          var newChat = new Chat(data);
           angular.copy(removeChatIfAlreadyExists(newChat, chatsList), chatsList);
           chatsList.push(newChat);
           unreadChats[newChat.type]++;
          });
        });

        return {
         list : chatsList,
         unreadChats : unreadChats
        }
     });

    function removeChatIfAlreadyExists(chat, array){
      var result = array.filter(function(potentialMatch){
        return potentialMatch.id != chat.id;
      })

      return result;
    }
{% endhighlight %}

And here's the definition of the `SocketHandler` :

{% highlight javascript %}
    var SocketHandler = function(){
        this.messageCallback = function(){};

        this.onMessage = function(callback){
            var theCallback = function(message){
             callback(JSON.parse(message.data));
            }

            if(this.channelSocket ==undefined){
             this.messageCallback = theCallback;
            }else{
             this.channelSocket.onmessage = theCallback;
            }
        }

        var context = this;
        this.socketCreationCallback = function(channelData){
              var channel = new goog.appengine.Channel(channelData.channelToken);
              context.channelId = channelData.channelId;
              var socket = channel.open();
              socket.onerror = function(){
                  console.log("Channel error");
              };
              socket.onclose = function(){
                  console.log("Channel closed, reopening");
                  //We reopen the channel
                  context.messageCallback = context.channelSocket.onmessage;
                  context.channelSocket = undefined;
                  $.getJSON("chats/channel",context.socketCreationCallback);
              };
              context.channelSocket = socket;
              console.log("Channel info received");
              console.log(channelData.channelId);
              context.channelSocket.onmessage = context.messageCallback;
          };

        $.getJSON("chats/channel",this.socketCreationCallback);
    }
{% endhighlight %}
