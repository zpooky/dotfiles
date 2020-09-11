// ==UserScript==
// @name           reddit filter things
// @author	       spooky
// @description    reddit filter things
// @include        *://old.reddit.com/r/all/*
// @grant          none
// @namespace      https://github.com/zpooky
// @license        AGPL3
// @supportURL	   https://github.com/zpooky
// @run-at         document-start
// @version 0.0.1
// ==/UserScript==

(function () {
  'use strict';

  function DOM_ContentReady(){
    var allDivs = document.evaluate(
      "//div[@data-subreddit='leagueoflegends' or @data-subreddit='hentaimemes' or @data-subreddit='hentai' or @data-subreddit='HistoryAnimemes' or @data-subreddit='HENTAI_GIF' or @data-subreddit='rule34' or @data-subreddit='traps' or @data-subreddit='Jokes']",
      document,
      null,
      XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE,
      null);

    console.log ("spooky remove subreddits matches:", allDivs.snapshotLength );
    for (var i = 0; i < allDivs.snapshotLength; i++) {
      var thisDiv = allDivs.snapshotItem(i);
      var parnt = thisDiv.parentNode;
      parnt.removeChild(thisDiv);
    }
  }

  document.addEventListener ("DOMContentLoaded", DOM_ContentReady);

}) ();

